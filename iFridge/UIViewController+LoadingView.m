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

    for (int i = 1; i<=63; i++) {
        [UIView animateWithDuration:5.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             
                             lv.animImageView.transform = CGAffineTransformMakeRotation(i * 0.2);
                             
                         } completion:nil];
        
        
    }
}

- (void)hideLoadingViewThreadSave {
    LoadingView *lv = objc_getAssociatedObject(self, (__bridge const void *)(LoadingViewKey));
    [lv hideThreadSave];
    objc_setAssociatedObject(self, (__bridge const void *)(LoadingViewKey), nil, OBJC_ASSOCIATION_ASSIGN);
}

@end
