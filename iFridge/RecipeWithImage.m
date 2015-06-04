//
//  RecipeWithImage.m
//  iFridge
//
//  Created by Alexey Pelekh on 5/15/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import "RecipeWithImage.h"
#import "RecipesTVC.h"
#import "Recipe+Cat.h"
#import "UIViewController+Context.h"
#import "AppDelegate.h"
#import "Ingredient.h"
#import "DataDownloader.h"
#import "ReminderTableViewController.h"



@interface RecipeWithImage ()

@property (weak, nonatomic) IBOutlet UILabel *nameOfDish;
@property (weak, nonatomic) IBOutlet UITextView *recipeIngredients;
@property (weak, nonatomic) IBOutlet UIImageView *imageForDish;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UILabel *recipeCountIndicator;
@property (strong , nonatomic) DataDownloader *dataDownloader;
@property (nonatomic) BOOL recipeSaved;
@property (strong, nonatomic) NSArray *availableRecipes;
@property (nonatomic, assign) NSInteger recipeRow;

@end

@implementation RecipeWithImage

- (void)viewDidLoad {
    [super viewDidLoad];
      NSLog(@"did");
    
    self.title = @"Recipe";

    self.view.backgroundColor = [UIColor clearColor];
    
    self.recipeCountIndicator.text = [NSString stringWithFormat:@"%ld/%lu", (self.recipeRow + 1), (unsigned long)self.availableRecipes.count];
  
    [self ifCurrentRecipeSaved];
    
    [self setRecipeForRecipeIndex:self.recipeRow];

}

- (void)viewWillAppear:(BOOL)animated{
      NSLog(@"will");
    self.view.backgroundColor =
    [UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
}


- (void)initWithRecipeAtIndex:(NSInteger)recipeIndex from:(NSArray *)recipes {
    self.availableRecipes = recipes;
    self.recipeRow = recipeIndex;
}

- (void) setRecipeForRecipeIndex:(NSInteger)recipeIndexPath
{
        DataDownloader *dataDownloader = [[DataDownloader alloc] init];
    if ([self.availableRecipes.firstObject isKindOfClass:[NSDictionary class]]) {
        [dataDownloader setImageWithURL:[[self.availableRecipes objectAtIndex:recipeIndexPath] valueForKeyPath:@"recipe.image"] usingImageView:self.imageForDish];
        NSArray *ingredientLines = [[self.availableRecipes objectAtIndex:self.recipeRow] valueForKeyPath:@"recipe.ingredientLines"];
        self.recipeIngredients.text = [NSString stringWithFormat:@"Ingredient needed \n %@", ingredientLines];
        self.nameOfDish.text = [[self.availableRecipes objectAtIndex:recipeIndexPath] valueForKeyPath:@"recipe.label"];
        
    }else if ([self.availableRecipes.firstObject isKindOfClass:[Recipe class]]){
        Recipe *currentRecipe = [self.availableRecipes objectAtIndex:recipeIndexPath];
        
        [dataDownloader setImageWithURL:currentRecipe.imageUrl usingImageView:self.imageForDish];
        self.nameOfDish.text = currentRecipe.label;
        
        NSMutableDictionary *ingredientLines = [[NSMutableDictionary alloc] init];
        NSNumber *numb = [[NSNumber alloc] initWithInt:0];
        for (Ingredient *ingredient in currentRecipe.ingredients) {
            [ingredientLines setObject:ingredient.label forKey:numb];
            int value = [numb intValue];
            numb = [NSNumber numberWithInt:value + 1];
        }
        self.recipeIngredients.text = [NSString stringWithFormat:@"Ingredient needed \n %@", [ingredientLines allValues]];
    }
}

- (IBAction)saveRecipeToCoreData:(UIBarButtonItem *)sender {
    
    if (!self.recipeSaved){
        NSDictionary *recipeDict = [[self.availableRecipes objectAtIndex:self.recipeRow ] valueForKey:@"recipe"];
        [Recipe createRecipeWithInfo:recipeDict inManagedObiectContext:self.currentContext];
        self.recipeSaved = YES;
        sender.title = @"Delete";
        
    }else{
        NSMutableArray *availibleRecipes = [[NSMutableArray alloc] initWithArray:self.availableRecipes];
        [availibleRecipes removeObjectAtIndex:self.recipeRow];
        self.availableRecipes = availibleRecipes;
        [Recipe deleteRecipe:[self.availableRecipes objectAtIndex:self.recipeRow] fromManagedObjectContext:self.currentContext];
        self.recipeSaved = NO;
        sender.title = @"Save";
    }
    
}

- (void)ifCurrentRecipeSaved{
    //checking if current recipe is alredy in the data base
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    NSString *predicateString = [[NSString alloc] init];
    if ([self.availableRecipes.firstObject isKindOfClass:[NSDictionary class]]) {
        predicateString = [[self.availableRecipes objectAtIndex:self.recipeRow] valueForKeyPath:@"recipe.label"];
    }else if ([self.availableRecipes.firstObject isKindOfClass:[Recipe class]]) {
        Recipe *currentRecipe = [self.availableRecipes objectAtIndex:self.recipeRow];
        predicateString = currentRecipe.label;
    }
    request.predicate = [NSPredicate predicateWithFormat:@"label = %@", predicateString];
    
    NSError *error;
    NSArray *mathes = [self.currentContext executeFetchRequest:request error:&error];
    if (mathes && !error && mathes.count == 1) {
        self.saveButton.title = @"Delete";
        self.recipeSaved = YES;
    }else{
        self.saveButton.title = @"Save";
        self.recipeSaved = NO;
    }
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft){
        ++self.recipeRow;
        if (self.recipeRow == self.availableRecipes.count) self.recipeRow = 0;
        self.recipeCountIndicator.text = [NSString stringWithFormat:@"%ld/%lu", (self.recipeRow + 1), self.availableRecipes.count];
        
    }else if (sender.direction == UISwipeGestureRecognizerDirectionRight){
        --self.recipeRow;
        if (self.recipeRow == -1) self.recipeRow = self.availableRecipes.count - 1;
        self.recipeCountIndicator.text = [NSString stringWithFormat:@"%ld/%lu", (self.recipeRow + 1), self.availableRecipes.count];
    }
    [self setRecipeForRecipeIndex:self.recipeRow];
    [self ifCurrentRecipeSaved];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ReminderTableViewController *newController = segue.destinationViewController;
    if ([[self.availableRecipes objectAtIndex:self.recipeRow] isKindOfClass:[NSDictionary class]]) {
        newController.ingredientsForReminder = [[self.availableRecipes objectAtIndex:self.recipeRow] valueForKeyPath:@"recipe.ingredientLines"];
    } else {
        Recipe *currRecipe = [self.availableRecipes objectAtIndex:self.recipeRow];
        NSMutableArray *ingredient = [[NSMutableArray alloc] init];
        for (Ingredient *ingr in currRecipe.ingredients) {
            [ingredient addObject:ingr.label];
        }
        newController.ingredientsForReminder = [NSArray arrayWithArray:ingredient];
    }
    
}

@end
