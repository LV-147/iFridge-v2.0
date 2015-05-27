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

@import CoreGraphics;


@interface RecipesTVC ()


@property (strong, nonatomic)NSArray *coreDataRecipes;

@end

@implementation RecipesTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    

    if ([self.dataSource isEqualToString:@"Search results"]){
    [self showLoadingViewInView:self.view];
    [self performSelector:@selector(hideLoadingViewThreadSave) withObject:nil afterDelay:2.8];
    }
    self.navigationController.view.backgroundColor =
    [UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    
    self.tableView.backgroundColor = [UIColor clearColor];

    
    NSString *myRequest = [[NSString alloc] initWithFormat:@"%@%@%@", @"https://api.edamam.com/search?q=",self.query,@"&app_id=4e8543af&app_key=e1309c8e747bdd4d7363587a4435f5ee&from=0&to=100"];
//    NSLog(@"myLink: %@", myRequest);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:myRequest parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        self.allRecipes = (NSDictionary *) responseObject;
        self.recipes = self.allRecipes[@"hits"];
        //NSLog(@"JSON: %@", self.recipes);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
 

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
        
        cell.nameOfDish.text = self.recipes[indexPath.row][@"recipe"][@"label"];
        
        cell.cookingLevel.text = self.recipes[indexPath.row][@"recipe"][@"level"];
        
        cell.cookingTime.text = [NSString stringWithFormat:@"cookingTime: %@", self.recipes[indexPath.row][@"recipe"][@"cookingTime"]];
        
        //    cell.caloriesTotal.text = [NSString stringWithFormat:@"caloriesTotal: %@",  self.recipes[indexPath.row][@"recipe"][@"calories"]];
        //    cell.caloriesTotal.text = [cell.caloriesTotal.text substringToIndex:22];
        
        double str1 = [self.recipes[indexPath.row][@"recipe"][@"calories"] doubleValue];
        NSString *caloriesTotal = [NSString stringWithFormat:@"calories: %2.3f", str1];
        cell.caloriesTotal.text = [NSString stringWithString:caloriesTotal];
        
        double str4 = [self.recipes[indexPath.row][@"recipe"][@"totalNutrients"][@"SUGAR"][@"quantity"] doubleValue];
        NSString *sugarsTotal = [NSString stringWithFormat:@"sugar: %2.3f", str4];
        cell.sugarsTotal.text = [NSString stringWithString:sugarsTotal];
        
        
        NSNumber *str3 = self.recipes[indexPath.row][@"recipe"][@"totalWeight"] ;
        NSString *weightTotal = [NSString stringWithFormat:@"weight: %@", [str3 stringValue]];
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
    RecipesCell *cell = (RecipesCell *)sender;
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    
    RecipeWithImage *newController = segue.destinationViewController;
    
    if ([self.dataSource isEqualToString:@"Search results"]) {
        newController.imageLink = self.recipes[path.row][@"recipe"][@"image"];
        newController.ingredientsLines = self.recipes[path.row][@"recipe"][@"ingredientLines"];
        newController.recipeDict = [[self.recipes objectAtIndex:path.row] valueForKey:@"recipe"];
        newController.availableRecipes = self.recipes;
    }else{
        Recipe *recipe = self.coreDataRecipes[path.row];
        newController.imageLink = recipe.imageUrl;
        newController.recipe = recipe;
        
        NSMutableDictionary *ingredienteLines = [[NSMutableDictionary alloc] init];
        NSNumber *numb = [[NSNumber alloc] initWithInt:0];
        for (Ingredient *ingredient in recipe.ingredients) {
            [ingredienteLines setObject:ingredient.label forKey:numb];
            int value = [numb intValue];
            numb = [NSNumber numberWithInt:value + 1];
        }
        newController.ingredientsLines = ingredienteLines;
        newController.availableRecipes = self.coreDataRecipes;
    }
    
    newController.recipeRow = [self.tableView indexPathForCell:cell].row;
    newController.dataSource = self.dataSource;
}

@end
