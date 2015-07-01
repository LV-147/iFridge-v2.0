//
//  RecipesTableViewController.m
//  iFridge
//
//  Created by Alexey Pelekh on 5/14/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import "RecipesTVC.h"
#import "RecipeWithImage.h"
#import "Ingredient.h"
#import "UIViewController+Context.h"
#import <QuartzCore/QuartzCore.h>
#import "UIViewController+LoadingView.h"
#import "DataDownloader.h"
#import "Recipe.h"
#import "Recipe+Cat.h"
#import "AddRecipeViewController.h"
#import <Parse/Parse.h>
//#import <SDWebImage/UIImageView+WebCache.h>

@import CoreGraphics;


@interface RecipesTVC () <UIAlertViewDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UISegmentedControl *selectDataSourceController;
@property (weak, nonatomic) IBOutlet UIButton *dataSourceButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSArray *allRecipes;
@end

@implementation RecipesTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        self.dataSource = @"Search results";
    
    if ([self.dataSource isEqualToString:@"Search results"]){
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self searchForRecipesForQuery:self.query];
    }else {
        self.selectDataSourceController.selectedSegmentIndex = 1;
        [self getRecipesFromCoreData];
    }
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

#pragma mark - search bar delegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    if ([self.dataSource isEqualToString:@"Search results"]) {
        self.query = searchBar.text;
        [self searchForRecipesForQuery:self.query];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([self.dataSource isEqualToString:@"My recipes"]) {
        if ([searchText isEqualToString:@""]) {
            self.recipes = [[NSMutableArray alloc]initWithArray:self.allRecipes];
            [searchBar resignFirstResponder];
        }else{
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Recipe *evaluatedObject, NSDictionary *bindings) {
                BOOL result = NO;
                if ([evaluatedObject.label rangeOfString:searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    result = YES;
                }
                return result;
            }];
            
            NSArray *filteredRecipes = [self.allRecipes filteredArrayUsingPredicate:predicate];
            self.recipes = [[NSMutableArray alloc]initWithArray:filteredRecipes];
        }
        [self.tableView reloadData];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        [[self navigationController] setNavigationBarHidden:YES animated:YES];
    else
        [[self navigationController] setNavigationBarHidden:NO animated:YES];
    self.searchBar.text = self.query;
    if ([self.dataSource isEqualToString:@"My recipes"]) {
        [self getRecipesFromCoreData];
        [self.tableView reloadData];
    }
    
    NSString *deviceType = [UIDevice currentDevice].model;
    
    if([deviceType isEqualToString:@"iPad"]  || [deviceType isEqualToString:@"iPad Simulator"])
        [DataDownloader networkIsReachable];
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
}

-(void) doAnimation:(RecipesCell*) cell{

    [cell setBackgroundColor:[UIColor blackColor]];
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void) {
                         [cell setBackgroundColor:[UIColor whiteColor]];
                     }
                     completion:^(BOOL finished){
                         
                     }];
}

- (void)searchForRecipesForQuery:(NSString *)newQuery
{
    [self showLoadingViewInView:self.view];
    [DataDownloader downloadRecipesForQuery:newQuery withCompletionHandler:^(NSArray *recipes){
        dispatch_async(dispatch_get_main_queue(), ^{
            self.recipes = [[NSMutableArray alloc]initWithArray:recipes];
            //self.recipes = recipes;
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
    self.recipes = [[NSMutableArray alloc]initWithArray:[self.currentContext executeFetchRequest:request error:&error]];
    //self.recipes = [self.currentContext executeFetchRequest:request error:&error];
    self.allRecipes = self.recipes;
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectDataSource:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"Web"]) {
        self.dataSource = @"Search results";
        [self searchForRecipesForQuery:self.query];
        [self.dataSourceButton setTitle:@"My recipes" forState:UIControlStateNormal];
    } else {
        self.dataSource = @"My recipes";
        [self getRecipesFromCoreData];
        [self.tableView reloadData];
        [self.dataSourceButton setTitle:@"Web" forState:UIControlStateNormal];
    }
}

- (IBAction)changeDataSource:(UISegmentedControl *)sender {
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
//    RecipesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Recipe cell"];
    RecipesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Recipe cell" forIndexPath:indexPath];
    
    
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
    
    [cell.recipeImageCell addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    cell.recipeImageCell.image = nil;
    [DataDownloader setRecipeImageWithURL:urlImageString
                           usingImageView:cell.recipeImageCell
                    withCompletionHandler:^{
                        [activityIndicator removeFromSuperview];
                    }];
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIStoryboard *iPad = [UIStoryboard storyboardWithName:@"iPad" bundle:nil];
        RecipeWithImage *detailRecipeController = [iPad instantiateViewControllerWithIdentifier:@"detailController"];
        detailRecipeController.index = indexPath.row;
        detailRecipeController.availableRecipes = self.recipes;
        [detailRecipeController.carousel reloadData];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if([self.dataSource  isEqual: @"My recipes"]){
            NSMutableArray *availableRecipes = [[NSMutableArray alloc] initWithArray:self.recipes];
            [Recipe deleteRecipe:[availableRecipes objectAtIndex:indexPath.row]
        fromManagedObjectContext:self.currentContext];
            [availableRecipes removeObjectAtIndex:indexPath.row];
            self.recipes = availableRecipes;
        }else
            [self.recipes removeObjectAtIndex:indexPath.row];
        [tableView reloadData]; // tell table to refresh now
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"SegueToRecipeWithImage"])
    {
        RecipesCell *recipeCell = (RecipesCell *)sender;
        NSInteger recipeIndex = [self.tableView indexPathForCell:recipeCell].row;
        RecipeWithImage *newController = segue.destinationViewController;
        newController.index = recipeIndex;
        newController.availableRecipes = self.recipes;
    }
}

- (IBAction)recipeAdded:(UIStoryboardSegue *)segue
{
    AddRecipeViewController *addRecipeController = segue.sourceViewController;
    NSNumber *weight = [NSNumber numberWithDouble:[addRecipeController.weight.text doubleValue]];
    NSNumber *cookingTime = [NSNumber numberWithDouble:[addRecipeController.cookingTime.text doubleValue]];
    NSDictionary *recipeDict = [[NSDictionary alloc] initWithObjectsAndKeys:
                                addRecipeController.recipeLabel.text, RECIPE_LABEL_KEYPATH,
                                addRecipeController.ingredients, RECIPE_INGREDIENTS_KEYPATH,
                                weight, RECIPE_WEIGHT_KEYPATH,
                                cookingTime, RECIPE_COOKING_TIME_KEYPATH,
                                nil];
    [self.recipes addObject:[Recipe createRecipeWithInfo:recipeDict
                                  inManagedObiectContext:self.currentContext]];
    [self.tableView reloadData];
}


- (IBAction)saveAllRecipesToParse:(id)sender {
    
    self.saveAllRecipes.hidden = YES;
    
    for (int i=0; i < self.recipes.count; i++) {
        if( _userEmail != nil &&
           _userId != nil &&
           self.recipes[i][@"recipe"][@"ingredientLines"] != nil &&
           self.recipes[i][@"recipe"][@"label"] != nil &&
           self.recipes[i][@"recipe"][@"calories"] != nil &&
           self.recipes[i][@"recipe"][@"totalNutrients"][@"FAT"][@"quantity"] != nil &&
           self.recipes[i][@"recipe"][@"totalWeight"] != nil &&
           self.recipes[i][@"recipe"][@"totalNutrients"][@"SUGAR"][@"quantity"] != nil &&
           self.recipes[i][@"recipe"][@"image"] != nil &&
           _userName != nil &&
           _userSocialNetwork != nil ){
            
            //        NSLog(@"%@", _userEmail);
            //        NSLog(@"%@", _userId);
            //        NSLog(@"%@", self.recipes[i][@"recipe"][@"label"]);
            //        NSLog(@"%@", self.recipes[i][@"recipe"][@"ingredientLines"]);
            //        NSLog(@"%@", self.recipes[i][@"recipe"][@"calories"]);
            //        NSLog(@"%@", self.recipes[i][@"recipe"][@"level"]);
            //        NSLog(@"%@", [NSString stringWithFormat:@"Cooking time: %@ min", self.recipes[i][@"recipe"][@"cookingTime"]]);
            //        NSLog(@"%@", self.recipes[i][@"recipe"][@"totalNutrients"][@"FAT"][@"quantity"]);
            //        NSLog(@"%@", self.recipes[i][@"recipe"][@"totalWeight"]);
            //        NSLog(@"%@", self.recipes[i][@"recipe"][@"totalNutrients"][@"SUGAR"][@"quantity"]);
            //        NSLog(@"%@", self.recipes[i][@"recipe"][@"image"]);
            //        NSLog(@"%@", _userName);
            //        NSLog(@"%@", _userSocialNetwork);
            
            PFObject *SomeProduct = [PFObject objectWithClassName:@"SavedProducts"];
            SomeProduct[@"UserEmail"] = _userEmail;
            SomeProduct[@"UserId"] = _userId;
            SomeProduct[@"DishName"] = self.recipes[i][@"recipe"][@"label"];
            SomeProduct[@"DishIngredients"] = self.recipes[i][@"recipe"][@"ingredientLines"];
            SomeProduct[@"Calories"] = self.recipes[i][@"recipe"][@"calories"];
            SomeProduct[@"CookingLevel"] = @"Cooking Level Not Allowed For This Recipe";
            SomeProduct[@"CookingTime"] = @"Cooking Time Not Allowed For This Recipe";
            SomeProduct[@"Fat"] = self.recipes[i][@"recipe"][@"totalNutrients"][@"FAT"][@"quantity"];
            SomeProduct[@"Weight"] = self.recipes[i][@"recipe"][@"totalWeight"];
            SomeProduct[@"Sugars"] = self.recipes[i][@"recipe"][@"totalNutrients"][@"SUGAR"][@"quantity"];
            SomeProduct[@"ImageUrl"] = self.recipes[i][@"recipe"][@"image"];
            SomeProduct[@"UserName"] = _userName;
            SomeProduct[@"SocialNetwork"] = _userSocialNetwork;
            
            
            [SomeProduct saveInBackground];
        }
    }
}
@end
