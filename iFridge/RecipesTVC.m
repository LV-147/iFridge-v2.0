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


@interface RecipesTVC ()  {
    BOOL isSearching; //for dynamic search feature
}
@property (weak, nonatomic) IBOutlet UISearchBar *recipeSearchBar;
@property (strong, nonatomic) IBOutlet UISegmentedControl *selectDataSourceController;

@property (strong, nonatomic) NSArray *recipes;
@property (strong, nonatomic) NSArray *filteredRecipes; //for dynamic search feature
@end

@implementation RecipesTVC
@synthesize query;
- (void)viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.recipeSearchBar.delegate = self;

    //Create number formatter to round NSNumbers
    NSNumberFormatter *numbFormatter = [[NSNumberFormatter alloc] init];
    [numbFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numbFormatter setMaximumFractionDigits:2];
    [numbFormatter setRoundingMode: NSNumberFormatterRoundUp];
    
    self.filteredRecipes = [[NSMutableArray alloc] init];
    
    if ([self.dataSource isEqualToString:@"Search results"]){
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self searchForRecipesForQuery:self.query];
    }else {
        self.selectDataSourceController.selectedSegmentIndex = 1;
        [self getRecipesFromCoreData];
    }
    self.recipeSearchBar.text = self.query;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    
    //cell.accessoryView = [UIImage]//[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory.png"]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.dataSource isEqualToString:@"My recipes"]) {
        [self getRecipesFromCoreData];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    [self searchForRecipesForQuery:searchText];
}

- (void)searchForRecipesForQuery:(NSString *)newQuery {
    if (!newQuery) {
        newQuery = @"";
        [[[UIAlertView alloc] initWithTitle:@"Table is empty because of empty request!"
                                    message:@"Please, enter some text in Search field!"
                                   delegate:self
                          cancelButtonTitle:@"Ok!"
                          otherButtonTitles:nil] show];
    }
    self.selectDataSourceController.selectedSegmentIndex = 0;
    [self showLoadingViewInView:self.view];
    [DataDownloader downloadRecipesForQuery:newQuery than:^(NSArray *recipes){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.recipes = recipes;
            [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
            [self.tableView reloadData];
            [self performSelector:@selector(hideLoadingViewThreadSave) withObject:nil afterDelay:0];
        });
    }];
    
}

- (void)getRecipesFromCoreData {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    request.predicate = nil;
    NSError *error;
    
    self.recipes = [self.currentContext executeFetchRequest:request error:&error];
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

-(void) doAnimation:(UITableViewCell*) cell{
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

- (void)setRecipeImage {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isSearching) return self.filteredRecipes.count;
    else return self.recipes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RecipesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell" forIndexPath:indexPath];
    NSString *urlImageString = [[NSString alloc] init];
    if ([self.dataSource isEqualToString:@"Search results"]) {
        urlImageString = [[self.recipes objectAtIndex:indexPath.row] valueForKeyPath:@"recipe.image"];
    }
    else {
        Recipe *recipe = [self.recipes objectAtIndex:indexPath.row];
        urlImageString = recipe.imageUrl;
    }
    __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.center = cell.recipeImageView.center;
    activityIndicator.hidesWhenStopped = YES;
    
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:urlImageString]
                                                         options:SDWebImageDownloaderLowPriority
                                                        progress:nil
                                                       completed:^(UIImage* image, NSData* data, NSError *error, BOOL finished) {
                                                           [activityIndicator removeFromSuperview];
                                                           [cell.recipeImageView setBackgroundColor:[UIColor colorWithPatternImage:image]];
                                                       }];
    [cell.recipeImageView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    if ([self.dataSource isEqualToString:@"Search results"]) {
        //        NSDictionary *recipe = [[NSDictionary alloc] initWithDictionary:[[self.recipes objectAtIndex:indexPath.row] valueForKey:@"recipe"]];

        cell.nameOfDish.text = self.recipes[indexPath.row][@"recipe"][@"label"];
        
        cell.cookingTime.text = [NSString stringWithFormat:@"cookingTime: %@", self.recipes[indexPath.row][@"recipe"][@"cookingTime"]];
        
        //    cell.caloriesTotal.text = [NSString stringWithFormat:@"caloriesTotal: %@",  self.recipes[indexPath.row][@"recipe"][@"calories"]];
        //    cell.caloriesTotal.text = [cell.caloriesTotal.text substringToIndex:22];
        
        
        double str1 = [self.recipes[indexPath.row][@"recipe"][@"calories"] doubleValue];
        NSString *caloriesTotal = [NSString stringWithFormat:@"calories: %2.3f", str1];
        cell.caloriesTotal.text = [NSString stringWithString:caloriesTotal];
        
        NSNumber *str3 = self.recipes[indexPath.row][@"recipe"][@"totalWeight"] ;
        NSString *weightTotal = [NSString stringWithFormat:@"weight: %@", [str3 stringValue]];
        cell.weightTotal.text = [NSString stringWithString:weightTotal];
        
        [self doAnimation:cell];
        
        return cell;
        
    }else{
        
        Recipe *recipe = self.recipes[indexPath.row];
        cell.nameOfDish.text = recipe.label;
        cell.cookingTime.text = [NSString stringWithFormat:@"Cooking time: %@ s", recipe.cookingTime];
        cell.caloriesTotal.text = [NSString stringWithFormat:@"Total calories %@", recipe.calories];
        cell.weightTotal.text = [NSString stringWithFormat:@"Total weight: %@ g", recipe.weight];
        
        return cell;
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    RecipesCell *recipeCell = sender;
    NSInteger recipeIndex = [self.tableView indexPathForCell:recipeCell].row;
    RecipeWithImage *newController = segue.destinationViewController;

    [newController initWithRecipeAtIndex:recipeIndex from:self.recipes];

}

@end
