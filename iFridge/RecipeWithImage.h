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
#import "ReminderTableViewController.h"

@interface RecipeWithImage : UIViewController

- (void)initWithRecipes:(NSArray *)recipes;

@end
