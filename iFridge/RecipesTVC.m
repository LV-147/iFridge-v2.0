//
//  RecipesTableViewController.m
//  iFridge
//
//  Created by Alexey Pelekh on 5/14/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import "RecipesTVC.h"
#import "RecipeWithImage.h"
#import "Recipe.h"
#import "Ingredient.h"
#import "UIViewController+Context.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+LoadingView.h"
#import "DataDownloader.h"

@import CoreGraphics;


@interface RecipesTVC ()


@property (strong, nonatomic)NSArray *coreDataRecipes;

@end

@implementation RecipesTVC


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    //Create number formatter to round NSNumbers
    NSNumberFormatter *numbFormatter = [[NSNumberFormatter alloc] init];
    [numbFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numbFormatter setMaximumFractionDigits:2];
    [numbFormatter setRoundingMode: NSNumberFormatterRoundUp];
    
    if ([self.dataSource isEqualToString:@"Search results"]){
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self showLoadingViewInView:self.view];
        
    }
    self.navigationController.view.backgroundColor =
    [UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    DataDownloader *downloadManager = [[DataDownloader alloc] init];
    [downloadManager downloadRecipesForQuery:self.query than:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.recipes = downloadManager.recipes;
            [self.tableView reloadData];
            [self performSelector:@selector(hideLoadingViewThreadSave) withObject:nil afterDelay:0];
            [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        });
    }];
    
}

-(void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
    }

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    
    //cell.accessoryView = [UIImage]//[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory.png"]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.coreDataRecipes = [[NSArray alloc] init];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    request.predicate = nil;
    NSError *error;
    
    self.coreDataRecipes = [self.currentContext executeFetchRequest:request error:&error];
    //    self.selectDataSourceButton.selectedSegmentIndex = 0;
    [self.tableView reloadData];
}

//-(void)loading{
//    if (self.recipes.count <= 100 && self.recipes.count != 0) {
//        [activityIndicator stopAnimating];
//        activityIndicator.hidesWhenStopped = YES;
//    }
//    else{
//        [activityIndicator startAnimating];
//    }
//}

-(void) doAnimation:(RecipesCell*) cell{
    //    [cell.layer setBackgroundColor:[UIColor blackColor].CGColor];
    //    [UIView beginAnimations:nil context:NULL];
    //    [UIView setAnimationDuration:0.1];
    //    [cell.layer setBackgroundColor:[UIColor whiteColor].CGColor];
    //    [UIView commitAnimations];
    [cell setBackgroundColor:[UIColor blackColor]];
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         //Leave it empty
                         [cell setBackgroundColor:[UIColor whiteColor]];
                     }
                     completion:^(BOOL finished){
                         
                         //                         // Your code goes here
                         //                         [UIView animateWithDuration:1.0 delay:0.0 options:
                         //                          UIViewAnimationOptionCurveEaseIn animations:^{
                         //                          } completion:^ (BOOL completed) {}];
                     }];
    
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         cell.nameOfDish.alpha = 0.7;
                         cell.nameOfDish.center = CGPointMake(300.0, 100.0);
                     }
                     completion:^(BOOL finished){}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectDataSource:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.dataSource = @"Search results";
            [self.tableView reloadData];
            break;
        case 1:
            self.dataSource = @"My recipes";
            [self.tableView reloadData];
            break;
        default:
            break;
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.dataSource isEqualToString:@"Search results"]) {
        return self.recipes.count;
    }else
        return self.coreDataRecipes.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    
    if ([self.dataSource isEqualToString:@"Search results"]) {
        //        NSDictionary *recipe = [[NSDictionary alloc] initWithDictionary:[[self.recipes objectAtIndex:indexPath.row] valueForKey:@"recipe"]];
        self.urlImageString = [[self.recipes objectAtIndex:indexPath.row] valueForKeyPath:@"recipe.image"];
        __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.center = cell.recipeImageCell.center;
        activityIndicator.hidesWhenStopped = YES;
        
        [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:self.urlImageString]
                                                             options:SDWebImageDownloaderLowPriority
                                                            progress:nil
                                                           completed:^(UIImage* image, NSData* data, NSError *error, BOOL finished) {
                                                               [activityIndicator removeFromSuperview];
                                                               [cell.recipeImageCell setBackgroundColor:[UIColor colorWithPatternImage:image]];
                                                           }];
        [cell.recipeImageCell addSubview:activityIndicator];
        [activityIndicator startAnimating];
        
        cell.nameOfDish.text = self.recipes[indexPath.row][@"recipe"][@"label"];
        
        cell.cookingLevel.text = self.recipes[indexPath.row][@"recipe"][@"level"];
        
        cell.cookingTime.text = [NSString stringWithFormat:@"Cooking time: %@ min", self.recipes[indexPath.row][@"recipe"][@"cookingTime"]];
        
        //    cell.caloriesTotal.text = [NSString stringWithFormat:@"caloriesTotal: %@",  self.recipes[indexPath.row][@"recipe"][@"calories"]];
        //    cell.caloriesTotal.text = [cell.caloriesTotal.text substringToIndex:22];
        
        
        double str1 = [self.recipes[indexPath.row][@"recipe"][@"calories"] doubleValue];
        NSString *caloriesTotal = [NSString stringWithFormat:@"Calories: %2.2f ccal", str1];
        cell.caloriesTotal.text = [NSString stringWithString:caloriesTotal];
        
        double str4 = [self.recipes[indexPath.row][@"recipe"][@"totalNutrients"][@"SUGAR"][@"quantity"] doubleValue];
        NSString *sugarsTotal = [NSString stringWithFormat:@"sugar: %2.3f", str4];
        cell.sugarsTotal.text = [NSString stringWithString:sugarsTotal];
        
        NSNumber *str3 = self.recipes[indexPath.row][@"recipe"][@"totalWeight"] ;
        NSString *weightTotal = [NSString stringWithFormat:@"Weight %@ g", [str3 stringValue]];
        cell.weightTotal.text = [NSString stringWithString:weightTotal];
        
        double str2 = [self.recipes[indexPath.row][@"recipe"][@"totalNutrients"][@"FAT"][@"quantity"] doubleValue];
        NSString *fatTotal = [NSString stringWithFormat:@"fat: %2.3f", str2];
        cell.fatTotal.text = [NSString stringWithString:fatTotal];
        
        [self doAnimation:cell];
        
        return cell;
        
    }else{
        
        Recipe *recipe = self.coreDataRecipes[indexPath.row];
        cell.nameOfDish.text = recipe.label;
        cell.cookingTime.text = [NSString stringWithFormat:@"Cooking time: %@ s", recipe.cookingTime];
        cell.caloriesTotal.text = [NSString stringWithFormat:@"Total calories %@", recipe.calories];
        cell.weightTotal.text = [NSString stringWithFormat:@"Total weight: %@ g", recipe.weight];
        cell.fatTotal.text = [NSString stringWithFormat:@"Total fat: %@ g", recipe.fat];
        cell.sugarsTotal.text = [NSString stringWithFormat:@"Total sugar %@ g", recipe.sugars];
        cell.cookingLevel.text = [NSString stringWithFormat:@"Cooking level: %@", recipe.cookingLevel];
        
        return cell;
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RecipesCell *recipeCell = sender;
    NSInteger recipeIndex = [self.tableView indexPathForCell:recipeCell].row;
    RecipeWithImage *newController = segue.destinationViewController;
    if ([self.dataSource isEqualToString:@"Search results"]) {
        [newController initWithRecipeAtIndex: recipeIndex from:self.recipes];
    }else [newController initWithRecipeAtIndex: recipeIndex from:self.coreDataRecipes];

}

@end
