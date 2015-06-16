//
//  RecipeWithImage.h
//  iFridge
//
//  Created by Alexey Pelekh on 5/15/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//


#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/SDWebImageManager.h>
#import "Recipe.h"
#import "iCarousel.h"
#import "UIView+Animation.h"

@interface RecipeWithImage : UIViewController <iCarouselDataSource, iCarouselDelegate>

- (void)initWithRecipeAtIndex:(NSInteger)recipeIndex from:(NSArray *)recipes;
- (IBAction)googlePlusShareButton:(id)sender;
@property (strong, nonatomic) IBOutlet iCarousel *carousel;
@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) IBOutlet UIView *portraitView;
@property (nonatomic,weak) IBOutlet UIImageView *movingImageForDish;
@property (nonatomic,weak) IBOutlet UIImageView *movingPhotoFrame;
@property (nonatomic,weak) IBOutlet UILabel *movingNameForDish;
@property (nonatomic,weak) IBOutlet UIImageView *movingNotePaper;
@property (nonatomic,weak) IBOutlet UITextView *movingRecipeIngredients;

@end
