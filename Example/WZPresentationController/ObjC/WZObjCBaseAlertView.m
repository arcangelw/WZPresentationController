//
//  WZObjCBaseAlertView.m
//  WZPresentationController
//
//  Created by 吴哲 on 2018/10/12.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

#import "WZObjCBaseAlertView.h"

@implementation WZObjCBaseAlertView
@synthesize preferredContentSize = _preferredContentSize;
@synthesize passthroughViews = _passthroughViews;
@synthesize dismissPresentedOnTap = _dismissPresentedOnTap;
@synthesize maskAlpha = _maskAlpha;
@synthesize maskEffect = _maskEffect;
@synthesize presentationClass = _presentationClass;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.preferredContentSize = UIScreen.mainScreen.bounds.size;
        self.passthroughViews = @[];
        self.dismissPresentedOnTap = YES;
        self.maskAlpha = 0.4;
        self.presentationClass = WZPresentationController.class;
    }
    return self;
}

- (CGRect)frameOfPresentedViewInContainerView:(UIView *)containerView
{
    return containerView.bounds;
}
@end
