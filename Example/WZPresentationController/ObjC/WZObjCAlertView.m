//
//  WZObjCAlertView.m
//  WZPresentationController
//
//  Created by 吴哲 on 2018/10/12.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

#import "WZObjCAlertView.h"

@implementation WZObjCAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.dismissPresentedOnTap = YES;
        self.preferredContentSize = CGSizeMake(200.f, 300.f);
        self.backgroundColor = UIColor.yellowColor;
    }
    return self;
}

- (CGRect)frameOfPresentedViewInContainerView:(UIView *)containerView
{
    CGRect rect = containerView.bounds;
    CGSize size = self.preferredContentSize;
    CGFloat x = (rect.size.width - size.width ) / 2.0f;
    CGFloat y = (rect.size.height - size.height ) / 2.0f;
    return CGRectMake(x, y, size.width, size.height);
}

@end
