//
//  LoadingView.h
//  ImageBlur
//
//  Created by Roman Utrata on 25.05.15.
//  Copyright (c) 2015 Roman Utrata. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipesTVC.h"

@interface LoadingView : UIView {
    UIActivityIndicatorViewStyle loadIndicatorStyle; //default is UIActivityIndicatorViewStyleWhiteLarge
}

@property (nonatomic, assign) UIActivityIndicatorViewStyle loadIndicatorStyle;
@property (nonatomic, weak) IBOutlet UIImageView *animImageView;

- (id)initWithLoadIndicatorStyle:(UIActivityIndicatorViewStyle)aStyle;

- (void)showWithView:(UIView*)superView;
- (void)hideThreadSave;

@end
