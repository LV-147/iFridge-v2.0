//
//  UIViewController+LoadingView.m
//  ImageBlur
//
//  Created by Roman Utrata on 25.05.15.
//  Copyright (c) 2015 Roman Utrata. All rights reserved.
//

#import "UIViewController+LoadingView.h"
#import "LoadingView.h"
#import <objc/runtime.h>
#import "RecipesTVC.h"

static const NSString *LoadingViewKey = @"LoadingViewKey";
static int imgAngle=0;

@implementation UIViewController (LoadingView)

- (void)showLoadingViewInView:(UIView *)superView {
    LoadingView *lv = objc_getAssociatedObject(self, (__bridge const void *)(LoadingViewKey));
    if (lv == nil) {
//        lv = [LoadingView new];
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:self options:nil];
        lv = (LoadingView *)[views lastObject];
        
//        lv.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
//        lv.loadIndicatorStyle = UIActivityIndicatorViewStyleWhiteLarge;
        objc_setAssociatedObject(self, (__bridge const void *)(LoadingViewKey), lv, OBJC_ASSOCIATION_ASSIGN);
    }
//    [lv showWithView:superView];
    [lv showWithView:superView];

    CABasicAnimation *animation = [CABasicAnimation   animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 120;
    animation.additive = YES;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.fromValue = [NSNumber numberWithFloat:0];
    animation.toValue = [NSNumber numberWithFloat:240];
    [lv.viewWithImage.layer addAnimation:animation forKey:@"90rotation"];
    
    CABasicAnimation *animationForSingleProduct = [CABasicAnimation   animationWithKeyPath:@"transform.rotation.z"];
    animationForSingleProduct.duration = 120;
    animationForSingleProduct.additive = YES;
    animationForSingleProduct.removedOnCompletion = NO;
    animationForSingleProduct.fillMode = kCAFillModeForwards;
    animationForSingleProduct.fromValue = [NSNumber numberWithFloat:0];
    animationForSingleProduct.toValue = [NSNumber numberWithFloat:480];
    
    [lv.imageView1.layer addAnimation:animationForSingleProduct forKey:@"90rotation"];
    [lv.imageView2.layer addAnimation:animationForSingleProduct forKey:@"90rotation"];
    [lv.imageView3.layer addAnimation:animationForSingleProduct forKey:@"90rotation"];
    [lv.imageView4.layer addAnimation:animationForSingleProduct forKey:@"90rotation"];
    [lv.imageView5.layer addAnimation:animationForSingleProduct forKey:@"90rotation"];
    [lv.imageView6.layer addAnimation:animationForSingleProduct forKey:@"90rotation"];
    [lv.imageView7.layer addAnimation:animationForSingleProduct forKey:@"90rotation"];
    [lv.imageView8.layer addAnimation:animationForSingleProduct forKey:@"90rotation"];
    
    imgAngle+=90;
    if (imgAngle>360) {
        imgAngle = 0;
    }
}

- (void)hideLoadingViewThreadSave {
    LoadingView *lv = objc_getAssociatedObject(self, (__bridge const void *)(LoadingViewKey));
    [lv hideThreadSave];
    objc_setAssociatedObject(self, (__bridge const void *)(LoadingViewKey), nil, OBJC_ASSOCIATION_ASSIGN);
}

@end
