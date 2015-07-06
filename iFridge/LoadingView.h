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

@property (strong, nonatomic) IBOutlet UIView *viewWithImage;

@property (strong, nonatomic) IBOutlet UIImageView *imageView1;
@property (strong, nonatomic) IBOutlet UIImageView *imageView2;
@property (strong, nonatomic) IBOutlet UIImageView *imageView3;
@property (strong, nonatomic) IBOutlet UIImageView *imageView4;
@property (strong, nonatomic) IBOutlet UIImageView *imageView5;
@property (strong, nonatomic) IBOutlet UIImageView *imageView6;
@property (strong, nonatomic) IBOutlet UIImageView *imageView7;
@property (strong, nonatomic) IBOutlet UIImageView *imageView8;

- (id)initWithLoadIndicatorStyle:(UIActivityIndicatorViewStyle)aStyle;

- (void)showWithView:(UIView*)superView;
- (void)hideThreadSave;

@end
