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


@interface RecipesTVC : UITableViewController

@property (strong, nonatomic) NSString *query;
<<<<<<< HEAD
@property (strong, nonatomic) NSMutableArray *recipes;
=======
@property (strong, nonatomic) NSArray *recipes;
@property (strong, nonatomic) NSString *urlImageString;
@property (strong, nonatomic) IBOutlet UISegmentedControl *selectDataSourceButton;
>>>>>>> 59861c03c84206d85b8df742de75183a31311f7f
@property (strong, nonatomic) NSString *dataSource;

@end
