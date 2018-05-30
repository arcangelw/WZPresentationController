//
//  UIKitExtension.swift
//
//  Created by 吴哲 on 2018/5/4.
//  Copyright © 2018年 arcangelw. All rights reserved.

import UIKit
import Accelerate

public extension UIView {
    
    func wz_snapshotImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0.0)
        defer {
            UIGraphicsEndImageContext()
        }
        drawHierarchy(in: bounds, afterScreenUpdates: false)
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}

extension UIImage {
  
    public var wz_imageByBlurExtraLight:UIImage? {
        return wz_image(byBlurRadius: 40.0, tintColor: UIColor(white: 0.97, alpha: 0.82), tintMode: .normal, saturation: 1.8, maskImage: nil)
    }
    
    public var wz_imageByBlurLight:UIImage? {
        return wz_image(byBlurRadius: 60.0, tintColor: UIColor(white: 1.0, alpha: 0.3), tintMode: .normal, saturation: 1.8, maskImage: nil)
    }
    
    public var wz_imageByBlurDark:UIImage? {
        return wz_image(byBlurRadius: 40.0, tintColor: UIColor(white: 0.11, alpha: 0.73), tintMode: .normal, saturation: 1.8, maskImage: nil)
    }
    
    /// https://github.com/ibireme/YYCategories.git
    /// UIImage+YY
    public func wz_image(byBlurRadius blurRadius:CGFloat,
                         tintColor:UIColor?,
                         tintMode tintBlendMode:CGBlendMode,
                         saturation:CGFloat,
                         maskImage:UIImage?) -> UIImage? {
        if size.height < 1 || size.height < 1 {
            print("wz_image  error: invalid size: \(size). Both dimensions must be >= 1: \(description) ")
            return nil
        }
        guard let `cgImage` = self.cgImage else {
            print("wz_image error: inputImage must be backed by a CGImage: \(description)")
            return nil
        }
        
        if let `maskImage` = maskImage , `maskImage`.cgImage == nil {
            NSLog ("wz_image error: effectMaskImage must be backed by a CGImage:: \(maskImage.description)");
            return nil
        }
        self.ciImage
        let hasBlur:Bool = blurRadius > CGFloat.ulpOfOne
        let hasSaturation:Bool = fabs(saturation - 1.0) > CGFloat.ulpOfOne
        
        let rect = CGRect(origin: .zero, size: size)
        var isOpaque:Bool = false
        
        if !hasBlur && !hasSaturation {
            guard let `cgImage` = self.cgImage else {
                return nil }
            return wz_mergeImageRef(effectCGImage: cgImage, tintColor: tintColor, tintBlendMode: tintBlendMode, maskImage: maskImage, isOpaque: isOpaque)
        }

        var effect:vImage_Buffer = vImage_Buffer()
        var scratch:vImage_Buffer = vImage_Buffer()
        var input:vImage_Buffer
        var output:vImage_Buffer
        var format:vImage_CGImageFormat = vImage_CGImageFormat(bitsPerComponent: UInt32(8),
                                                               bitsPerPixel: UInt32(32),
                                                               colorSpace: nil,
                                                               bitmapInfo:CGBitmapInfo(rawValue:CGBitmapInfo.byteOrder32Little.rawValue|CGImageAlphaInfo.premultipliedFirst.rawValue),
                                                               version: UInt32(0),
                                                               decode: nil,
                                                               renderingIntent: .defaultIntent)
        
        var err:vImage_Error?
        
        err = vImageBuffer_InitWithCGImage(&effect, &format, nil, cgImage, vImage_Flags(kvImagePrintDiagnosticsToConsole))
        if err != kvImageNoError {
            print("wz_image error: vImageBuffer_InitWithCGImage returned error code \(err) for inputImage: \(description)")
            
            return nil
        }
        err = vImageBuffer_Init(&scratch, effect.height, effect.width, format.bitsPerPixel, vImage_Flags(kvImageNoFlags))
        if err != kvImageNoError {
            print("wz_image error: vImageBuffer_Init returned error code \(err) for inputImage: \(description)")
            return nil;
        }
        
        input = effect
        output = scratch
        
        if hasBlur {
            // A description of how to compute the box kernel width from the Gaussian
            // radius (aka standard deviation) appears in the SVG spec:
            // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
            //
            // For larger values of 's' (s >= 2.0), an approximation can be used: Three
            // successive box-blurs build a piece-wise quadratic convolution kernel, which
            // approximates the Gaussian kernel to within roughly 3%.
            //
            // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
            //
            // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
            //
            
            var inputRadius:CGFloat = blurRadius * scale
            if inputRadius - 2.0 < CGFloat.ulpOfOne { inputRadius = 2.0 }
            
            var radius:UInt32 = UInt32(floor((Double(inputRadius) * 3.0 * sqrt(2 * M_PI) / 4.0 + 0.5 ) / 2.0))
            radius = radius | 1 // force radius to be odd so that the three box-blur methodology works.
            var iterations:Int
            if blurRadius * scale < 0.5 { iterations = 1 }
            else if blurRadius * scale < 1.5 { iterations = 2 }
            else { iterations = 3 }
            
            var tempSize:vImage_Error = vImageBoxConvolve_ARGB8888(&input, &output, nil, vImagePixelCount(0), vImagePixelCount(0), radius, radius, nil, vImage_Flags(kvImageGetTempBufferSize|kvImageEdgeExtend))

            let alignment = MemoryLayout<vImage_Error>.alignment(ofValue: tempSize)
            let temp = UnsafeMutableRawPointer.allocate(byteCount: tempSize, alignment: alignment)
            for _ in 0..<iterations {
                vImageBoxConvolve_ARGB8888(&input, &output, temp, vImagePixelCount(0), vImagePixelCount(0), radius, radius, nil, vImage_Flags(kvImageEdgeExtend))
                swap(&input, &output)
            }
            temp.deallocate()
            
        }
        
        if hasSaturation {
            // These values appear in the W3C Filter Effects spec:
            // https://dvcs.w3.org/hg/FXTF/raw-file/default/filters/Publish.html#grayscaleEquivalent
            let s:CGFloat = saturation
            let matrixFloat:[CGFloat] = [
                (0.0722 + 0.9278 * s),(0.0722 - 0.0722 * s),(0.0722 - 0.0722 * s),0.0,
                (0.7152 - 0.7152 * s),(0.7152 + 0.2848 * s),(0.7152 - 0.7152 * s),0.0,
                (0.2126 - 0.2126 * s),(0.2126 - 0.2126 * s),(0.2126 + 0.7873 * s),0.0,
                0.0,                  0.0,                  0.0,                  1.0
            ]
            let divisor:Int32 = 256
            let matrix:[Int16] = matrixFloat.map({Int16(roundf(Float($0 * CGFloat(divisor))))})
            vImageMatrixMultiply_ARGB8888(&input, &output, matrix, divisor, nil, nil, vImage_Flags(kvImageNoFlags))
            swap(&input, &output)
        }
        
        var effectCGImage = vImageCreateCGImageFromBuffer(&input, &format, {free($1)}, nil, vImage_Flags(kvImageNoAllocate), nil)
        
        if effectCGImage == nil {
           effectCGImage = vImageCreateCGImageFromBuffer(&input, &format, nil, nil, vImage_Flags(kvImageNoFlags), nil)
            free(input.data)
        }
        free(output.data)
        var outputImage:UIImage?
        if effectCGImage != nil  {
            outputImage = wz_mergeImageRef(effectCGImage: effectCGImage!.takeUnretainedValue(), tintColor: tintColor, tintBlendMode: tintBlendMode, maskImage: maskImage, isOpaque: isOpaque)
        }
        effectCGImage?.release()
        return outputImage
    }
    
    
    // Helper function to add tint and mask.
    fileprivate func wz_mergeImageRef(effectCGImage:CGImage,
                                      tintColor:UIColor?,
                                      tintBlendMode:CGBlendMode,
                                      maskImage:UIImage?,
                                      isOpaque:Bool) -> UIImage? {
        
        let hasTint = tintColor is UIColor && tintColor!.cgColor.alpha > CGFloat.ulpOfOne
        let hasMask = maskImage is UIImage
        let rect = CGRect(origin: .zero, size: size)
        
        if !hasTint && !hasMask {
            return UIImage(cgImage: effectCGImage)
        }
    
        UIGraphicsBeginImageContextWithOptions(size, isOpaque, scale)
        defer {
            UIGraphicsEndImageContext()
        }
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -size.height)
        
        if hasMask {
            guard let cgImage = self.cgImage else { return nil }
            context.draw(cgImage, in: rect)
            context.saveGState()
            guard let maskCgImage = maskImage?.cgImage else { return nil }
            context.clip(to: rect, mask: maskCgImage)
        }
        context.draw(effectCGImage, in: rect)
        
        if hasTint {
            context.saveGState()
            context.setBlendMode(tintBlendMode)
            context.setFillColor(tintColor!.cgColor)
            context.fill(rect)
            context.restoreGState()
        }
        
        if hasMask {
            context.restoreGState()
        }
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
}




















