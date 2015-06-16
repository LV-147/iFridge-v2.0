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

<<<<<<< HEAD
@interface RecipeWithImage : UIViewController <iCarouselDataSource, iCarouselDelegate>

- (void)initWithRecipeAtIndex:(NSInteger)recipeIndex from:(NSArray *)recipes;
- (IBAction)googlePlusShareButton:(id)sender;
@property (strong, nonatomic) IBOutlet iCarousel *carousel;
@property (assign, nonatomic) NSInteger index;
=======
@interface RecipeWithImage : UIViewController
>>>>>>> 59861c03c84206d85b8df742de75183a31311f7f

- (void)initWithRecipeAtIndex:(NSInteger)recipeIndex from:(NSArray *)recipes;
@property (weak, nonatomic) IBOutlet UITextView *myText;

@end
