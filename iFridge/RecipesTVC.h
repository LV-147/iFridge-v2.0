//
//  RecipesTableViewController.h
//  iFridge
//
//  Created by Alexey Pelekh on 5/14/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecipesCell.h"
#import <AFNetworking/AFNetworking.h>


@interface RecipesTVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSString *query;
@property (strong, nonatomic) NSMutableArray *recipes;
@property (strong, nonatomic) NSString *dataSource;
@property (strong, nonatomic) NSString *userEmail;
@property (strong, nonatomic) NSString *userId;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *userSocialNetwork;
<<<<<<< HEAD
@property (weak, nonatomic) IBOutlet UIButton *byNameButton;
@property (weak, nonatomic) IBOutlet UIButton *byCaloriesButton;

@property (strong, nonatomic) IBOutlet UIButton *saveAllRecipes;
- (IBAction)saveAllRecipesToParse:(id)sender;
- (IBAction)sortByName:(id)sender;
- (IBAction)sortByCalories:(id)sender;
=======

@property (strong, nonatomic) IBOutlet UIButton *saveAllRecipes;
- (IBAction)saveAllRecipesToParse:(id)sender;

>>>>>>> 0fbc5f768003a1d8305c5988a5f013ddd6a54db6

@end
