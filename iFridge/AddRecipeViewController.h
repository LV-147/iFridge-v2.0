//
//  AddRecipeViewController.h
//  iFridge
//
//  Created by Vladius on 6/12/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddRecipeViewController : UIViewController
@property (strong, nonatomic) NSMutableArray *ingredients;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *recipeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UITextField *cookingTime;
@property (weak, nonatomic) IBOutlet UITextField *weight;
@property (strong, nonatomic) NSString *recipeImageURL;

@end
