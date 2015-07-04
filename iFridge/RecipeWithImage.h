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

@interface RecipeWithImage
    : UIViewController <iCarouselDataSource, iCarouselDelegate>

- (IBAction)googlePlusShareButton:(id)sender;
@property(strong, nonatomic) NSMutableArray *availableRecipes;
@property(strong, nonatomic) IBOutlet iCarousel *carousel;
@property(assign, nonatomic) NSInteger index;

@end
