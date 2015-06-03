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


@interface RecipesTVC : UITableViewController <UISearchBarDelegate>
@property (strong, nonatomic) NSString *query;
@property (strong, nonatomic) NSString *dataSource;

@end
