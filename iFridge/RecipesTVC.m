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


@interface RecipesTVC () <UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating>
@property (strong, nonatomic) IBOutlet UISegmentedControl *selectDataSourceController;
@property (strong, nonatomic) NSArray *allRecipes;
//SEARCH
@property (nonatomic, strong) UISearchController *searchController;
// our secondary search results table view
@property (nonatomic, strong) RecipesTVC *resultsController;
// for state restoration
@property BOOL searchControllerWasActive;
@property BOOL searchControllerSearchFieldWasFirstResponder;
//SEARCH
@end

@implementation RecipesTVC

- (void)viewDidLoad {
    [super viewDidLoad];
        self.resultsController.dataSource = @"Search results";
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    if ([self.dataSource isEqualToString:@"Search results"]){
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self searchForRecipesForQuery:self.query];
    }else {
        self.selectDataSourceController.selectedSegmentIndex = 1;
        [self getRecipesFromCoreData];
    }
    //SEARCH
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    //config view of search bar
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.tintColor = [UIColor redColor];
    self.searchController.searchBar.barTintColor = [UIColor colorWithRed:1 green:0.6 blue:0.6 alpha:0.5];
    [self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.text = self.query;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    self.searchController.dimsBackgroundDuringPresentation = NO; // default is YES
    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
    //SEARCH
}


#pragma mark - search bar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([self.dataSource isEqualToString:@"Search results"]) {
        self.query = self.searchController.searchBar.text;
        [self searchForRecipesForQuery:self.query];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    @try {
        if ([self.dataSource isEqualToString:@"My recipes"]) {
            [self getRecipesFromCoreData];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"bad");
    }
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    if ([self.dataSource isEqualToString:@"My recipes"]) {
        NSString *query = searchController.searchBar.text;
        if ([query isEqualToString:@""]) {
            self.recipes = self.allRecipes;
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Recipe *evaluatedObject, NSDictionary *bindings) {
                BOOL result = NO;
                if ([evaluatedObject.label rangeOfString:query options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    result = YES;
                }
                return result;
            }];
            
            NSArray *filteredRecipes = [self.allRecipes filteredArrayUsingPredicate:predicate];
            self.recipes = filteredRecipes;
        }
        [self.tableView reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.dataSource isEqualToString:@"My recipes"]) {
        [self getRecipesFromCoreData];
        [self.tableView reloadData];
    }
    [self.searchController.searchBar becomeFirstResponder];
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
    }
    [super viewWillDisappear:animated];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    
    //cell.accessoryView = [UIImage]//[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory.png"]];
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
}

- (void)searchForRecipesForQuery:(NSString *)newQuery
{
        self.selectDataSourceController.selectedSegmentIndex = 0;
        [self showLoadingViewInView:self.view];
        DataDownloader *downloadManager = [[DataDownloader alloc]init];
        [downloadManager downloadRecipesForQuery:newQuery withCompletionHandler:^(NSArray *recipes){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.recipes = recipes;
                [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
                [self.tableView reloadData];
                [self performSelector:@selector(hideLoadingViewThreadSave) withObject:nil afterDelay:0];
            });
        }];
}

- (void)getRecipesFromCoreData
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    request.predicate = nil;
    NSError *error;
    
    self.recipes = [self.currentContext executeFetchRequest:request error:&error];
    self.allRecipes = self.recipes;
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectDataSource:(UISegmentedControl *)sender {
    switch (sender.selectedSegmentIndex) {
        case 0:
            self.dataSource = @"Search results";
            [self searchForRecipesForQuery:self.query];
            break;
        case 1:
            self.dataSource = @"My recipes";
            [self getRecipesFromCoreData];
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
    
    return self.recipes.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];


    NSString *urlImageString = [[NSString alloc] init];
    if ([self.dataSource isEqualToString:@"Search results"]) {
        urlImageString = [[self.recipes objectAtIndex:indexPath.row] valueForKeyPath:@"recipe.image"];
    }
    else {
        Recipe *recipe = [self.recipes objectAtIndex:indexPath.row];
        urlImageString = recipe.imageUrl;
    }
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = cell.recipeImageCell.center;
    activityIndicator.hidesWhenStopped = YES;

    [DataDownloader setRecipeImageWithURL:urlImageString
                           usingImageView:cell.recipeImageCell
                    withCompletionHandler:^{
                        [activityIndicator removeFromSuperview];
                    }];

    [cell.recipeImageCell addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:0];
    
    if ([self.dataSource isEqualToString:@"Search results"]) {
        cell.nameOfDish.text = self.recipes[indexPath.row][@"recipe"][@"label"];
        
        cell.cookingTime.text = [NSString stringWithFormat:@"cookingTime: %@", self.recipes[indexPath.row][@"recipe"][@"cookingTime"]];
        
        NSNumber *str1 = self.recipes[indexPath.row][@"recipe"][@"calories"];
        NSString *caloriesTotal = [NSString stringWithFormat:@"calories: %@", [numberFormatter stringFromNumber:str1]];
        cell.caloriesTotal.text = [NSString stringWithString:caloriesTotal];
        
        NSNumber *str3 = self.recipes[indexPath.row][@"recipe"][@"totalWeight"];
        NSString *weightTotal = [NSString stringWithFormat:@"weight: %@ g", [numberFormatter stringFromNumber:str3]];
        cell.weightTotal.text = [NSString stringWithString:weightTotal];
        
        [self doAnimation:cell];
        
        return cell;
        
    }else{
        
        Recipe *recipe = self.recipes[indexPath.row];
        cell.nameOfDish.text = recipe.label;
        cell.cookingTime.text = [NSString stringWithFormat:@"Cooking time: %@ s", [numberFormatter stringFromNumber:recipe.cookingTime]];
        cell.caloriesTotal.text = [NSString stringWithFormat:@"Total calories %@", [numberFormatter stringFromNumber:recipe.calories]];
        cell.weightTotal.text = [NSString stringWithFormat:@"Total weight: %@ g", [numberFormatter stringFromNumber:recipe.weight]];
        
        return cell;
    }
}
#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RecipesCell *recipeCell = (RecipesCell *)sender;
    NSInteger recipeIndex = [self.tableView indexPathForCell:recipeCell].row;
    RecipeWithImage *newController = segue.destinationViewController;
    newController.index = recipeIndex;
    [newController initWithRecipeAtIndex:recipeIndex from:self.recipes];
    
}
@end
