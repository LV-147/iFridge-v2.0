//
//  UIViewController+LoadingView.h
//  ImageBlur
//
//  Created by Roman Utrata on 25.05.15.
//  Copyright (c) 2015 Roman Utrata. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LoadingView)

- (void)showLoadingViewInView:(UIView *)superView;
- (void)hideLoadingViewThreadSave;

@end
