//
//  RecipeCarouselItem.h
//  iFridge
//
//  Created by Taras Pasichnyk on 6/5/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKShareKit/FBSDKLikeButton.h>

@interface RecipeCarouselItem : UIView

@property (strong, nonatomic) IBOutlet UIImageView *recipeItemImage;
@property (strong, nonatomic) IBOutlet UILabel *recipeItemName;
@property (strong, nonatomic) IBOutlet UITextView *recipeItemTextField;
@property (weak, nonatomic) IBOutlet UIImageView *recipeItemFrame;
@property (strong, nonatomic) IBOutlet UIButton *googleButton;
@property (strong, nonatomic) IBOutlet FBSDKLikeButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end
