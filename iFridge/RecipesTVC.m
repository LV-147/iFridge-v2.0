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


<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 0d1649ca4b818c5beaed2ebf267da006482fa445
@interface RecipesTVC () <UISearchBarDelegate, UISearchControllerDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *recipeSearchBar;
@property (strong, nonatomic) IBOutlet UISegmentedControl *selectDataSourceController;
<<<<<<< HEAD
=======
=======
@interface RecipesTVC ()


@property (strong, nonatomic)NSArray *coreDataRecipes;
>>>>>>> fb2a596d08adff39858c46a8aae7f5a006f90f05

>>>>>>> 0d1649ca4b818c5beaed2ebf267da006482fa445
@end

@implementation RecipesTVC


- (void)viewDidLoad {
    [super viewDidLoad];
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 0d1649ca4b818c5beaed2ebf267da006482fa445
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.recipeSearchBar.delegate = self;
<<<<<<< HEAD
=======
=======
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    //Create number formatter to round NSNumbers
    NSNumberFormatter *numbFormatter = [[NSNumberFormatter alloc] init];
    [numbFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numbFormatter setMaximumFractionDigits:2];
    [numbFormatter setRoundingMode: NSNumberFormatterRoundUp];
>>>>>>> fb2a596d08adff39858c46a8aae7f5a006f90f05
>>>>>>> 0d1649ca4b818c5beaed2ebf267da006482fa445
    
    if ([self.dataSource isEqualToString:@"Search results"]){
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self searchForRecipesForQuery:self.query];
    }else {
        self.selectDataSourceController.selectedSegmentIndex = 1;
        [self getRecipesFromCoreDataForQuery:nil];
    }
<<<<<<< HEAD
    self.recipeSearchBar.text = self.query;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.dataSource isEqualToString:@"My recipes"]) {
        [self getRecipesFromCoreDataForQuery:nil];
        [self.tableView reloadData];
    }
=======
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
    
>>>>>>> 0d1649ca4b818c5beaed2ebf267da006482fa445
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

<<<<<<< HEAD
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
=======
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
<<<<<<< HEAD
    if ([self.dataSource isEqualToString:@"My recipes"]) {
        [self getRecipesFromCoreDataForQuery:nil];
        [self.tableView reloadData];
    }
>>>>>>> 0d1649ca4b818c5beaed2ebf267da006482fa445
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    self.query = self.recipeSearchBar.text;
    if ([self.dataSource isEqualToString:@"Search results"])
    {
        [self searchForRecipesForQuery:self.query];
    }else {
        [self getRecipesFromCoreDataForQuery:self.query];
    }
    [self.recipeSearchBar resignFirstResponder];
    
}


- (void)searchForRecipesForQuery:(NSString *)newQuery {
    if (!newQuery) {
        [[[UIAlertView alloc] initWithTitle:@"Table is empty because of empty request!"
                                    message:@"Please, enter some text in Search field!"
                                   delegate:self
                          cancelButtonTitle:@"Ok!"
                          otherButtonTitles:nil] show];
        [self.tableView reloadData];
    }else
    {
        self.selectDataSourceController.selectedSegmentIndex = 0;
        [self showLoadingViewInView:self.view];
        [DataDownloader downloadRecipesForQuery:newQuery withCompletionHandler:^(NSArray *recipes){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.recipes = recipes;
                [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
                [self.tableView reloadData];
                [self performSelector:@selector(hideLoadingViewThreadSave) withObject:nil afterDelay:0];
            });
        }];
    }
    
}

- (void)getRecipesFromCoreDataForQuery:(NSString *)newQuery
{
    newQuery = nil;
<<<<<<< HEAD
=======
=======
    self.coreDataRecipes = [[NSArray alloc] init];
>>>>>>> fb2a596d08adff39858c46a8aae7f5a006f90f05
>>>>>>> 0d1649ca4b818c5beaed2ebf267da006482fa445
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    if (newQuery)
        request.predicate = [NSPredicate predicateWithFormat:@"label = %@", newQuery];
    else
        request.predicate = nil;
    NSError *error;
    
    self.recipes = [self.currentContext executeFetchRequest:request error:&error];
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
            [self getRecipesFromCoreDataForQuery:self.query];
            [self.tableView reloadData];
            break;
        default:
            break;
    }
    self.query = self.recipeSearchBar.text;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.recipes.count;
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
    activityIndicator.center = cell.recipeImageCell.center;
    activityIndicator.hidesWhenStopped = YES;
    
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:urlImageString]
                                                         options:SDWebImageDownloaderLowPriority
                                                        progress:nil
                                                       completed:^(UIImage* image, NSData* data, NSError *error, BOOL finished) {
                                                           [activityIndicator removeFromSuperview];
                                                           [cell.recipeImageCell setBackgroundColor:[UIColor colorWithPatternImage:image]];
                                                       }];
    [cell.recipeImageCell addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:0];
    
    if ([self.dataSource isEqualToString:@"Search results"]) {
        //        NSDictionary *recipe = [[NSDictionary alloc] initWithDictionary:[[self.recipes objectAtIndex:indexPath.row] valueForKey:@"recipe"]];
        
        cell.nameOfDish.text = self.recipes[indexPath.row][@"recipe"][@"label"];
        
        cell.cookingTime.text = [NSString stringWithFormat:@"cookingTime: %@", self.recipes[indexPath.row][@"recipe"][@"cookingTime"]];
        
        //    cell.caloriesTotal.text = [NSString stringWithFormat:@"caloriesTotal: %@",  self.recipes[indexPath.row][@"recipe"][@"calories"]];
        //    cell.caloriesTotal.text = [cell.caloriesTotal.text substringToIndex:22];
        
<<<<<<< HEAD
=======
<<<<<<< HEAD
>>>>>>> 0d1649ca4b818c5beaed2ebf267da006482fa445
        NSNumber *str1 = self.recipes[indexPath.row][@"recipe"][@"calories"];
        NSString *caloriesTotal = [NSString stringWithFormat:@"calories: %@", [numberFormatter stringFromNumber:str1]];
        cell.caloriesTotal.text = [NSString stringWithString:caloriesTotal];
        
        NSNumber *str3 = self.recipes[indexPath.row][@"recipe"][@"totalWeight"];
        NSString *weightTotal = [NSString stringWithFormat:@"weight: %@ g", [numberFormatter stringFromNumber:str3]];
<<<<<<< HEAD
=======
=======
        
        double str1 = [self.recipes[indexPath.row][@"recipe"][@"calories"] doubleValue];
        NSString *caloriesTotal = [NSString stringWithFormat:@"Calories: %2.2f ccal", str1];
        cell.caloriesTotal.text = [NSString stringWithString:caloriesTotal];
        
        double str4 = [self.recipes[indexPath.row][@"recipe"][@"totalNutrients"][@"SUGAR"][@"quantity"] doubleValue];
        NSString *sugarsTotal = [NSString stringWithFormat:@"sugar: %2.3f", str4];
        cell.sugarsTotal.text = [NSString stringWithString:sugarsTotal];
        
        NSNumber *str3 = self.recipes[indexPath.row][@"recipe"][@"totalWeight"] ;
        NSString *weightTotal = [NSString stringWithFormat:@"Weight %@ g", [str3 stringValue]];
>>>>>>> fb2a596d08adff39858c46a8aae7f5a006f90f05
>>>>>>> 0d1649ca4b818c5beaed2ebf267da006482fa445
        cell.weightTotal.text = [NSString stringWithString:weightTotal];
        
        [self doAnimation:cell];
        
        return cell;
        
    }else{
        
        Recipe *recipe = self.recipes[indexPath.row];
        cell.nameOfDish.text = recipe.label;
<<<<<<< HEAD
        cell.cookingTime.text = [NSString stringWithFormat:@"Cooking time: %@ s", [numberFormatter stringFromNumber:recipe.cookingTime]];
        cell.caloriesTotal.text = [NSString stringWithFormat:@"Total calories %@", [numberFormatter stringFromNumber:recipe.calories]];
        cell.weightTotal.text = [NSString stringWithFormat:@"Total weight: %@ g", [numberFormatter stringFromNumber:recipe.weight]];
=======
<<<<<<< HEAD
        cell.cookingTime.text = [NSString stringWithFormat:@"Cooking time: %@ s", [numberFormatter stringFromNumber:recipe.cookingTime]];
        cell.caloriesTotal.text = [NSString stringWithFormat:@"Total calories %@", [numberFormatter stringFromNumber:recipe.calories]];
        cell.weightTotal.text = [NSString stringWithFormat:@"Total weight: %@ g", [numberFormatter stringFromNumber:recipe.weight]];
=======
        cell.cookingTime.text = [NSString stringWithFormat:@"Cooking time: %@ s", recipe.cookingTime];
        cell.caloriesTotal.text = [NSString stringWithFormat:@"Total calories %@", recipe.calories];
        cell.weightTotal.text = [NSString stringWithFormat:@"Total weight: %@ g", recipe.weight];
        cell.fatTotal.text = [NSString stringWithFormat:@"Total fat: %@ g", recipe.fat];
        cell.sugarsTotal.text = [NSString stringWithFormat:@"Total sugar %@ g", recipe.sugars];
        cell.cookingLevel.text = [NSString stringWithFormat:@"Cooking level: %@", recipe.cookingLevel];
>>>>>>> fb2a596d08adff39858c46a8aae7f5a006f90f05
>>>>>>> 0d1649ca4b818c5beaed2ebf267da006482fa445
        
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
