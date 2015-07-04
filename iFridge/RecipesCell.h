//
//  RecipesCell.h
//  iFridge
//
//  Created by Alexey Pelekh on 5/14/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/SDWebImageManager.h>

@interface RecipesCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameOfDish;
@property (strong, nonatomic) IBOutlet UILabel *cookingTime;
@property (strong, nonatomic) IBOutlet UILabel *caloriesTotal;
@property (strong, nonatomic) IBOutlet UILabel *weightTotal;
@property (strong, nonatomic) IBOutlet UIImageView *recipeImageCell;

@end
