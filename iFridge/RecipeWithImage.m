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



@interface RecipeWithImage ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UILabel *recipeCountIndicator;

@end

@implementation RecipeWithImage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Recipe";
    
    self.navigationController.view.backgroundColor =
    [UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.recipeCountIndicator.text = [NSString stringWithFormat:@"%ld/%lu", (self.recipeRow + 1), (unsigned long)self.availableRecipes.count];
    
    [self ifCurrentRecipeSaved];
    if (self.recipeSaved) {
        self.saveButton.title = @"Delete";
    }else self.saveButton.title = @"Save";
    
    self.textViewForRecipe.text = [NSString stringWithFormat:@"%@", self.ingredientsLines];
    
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:self.imageLink] options:SDWebImageDownloaderLowPriority
                                                        progress:nil
                                                       completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                           
                                                           [self.imageForDish setBackgroundColor:[UIColor colorWithPatternImage:image]];
                                                       }];
    
   
}



- (void) setRecipeWithImageContents:(NSInteger)recipeIndexPath
{
    if ([self.dataSource isEqualToString:@"Search results"]) {
        self.imageLink = self.availableRecipes[recipeIndexPath][@"recipe"][@"image"];
        self.ingredientsLines = self.availableRecipes[recipeIndexPath][@"recipe"][@"ingredientLines"];
        
    }else{
        Recipe *currentRecipe = [self.availableRecipes objectAtIndex:recipeIndexPath];
        self.imageLink = currentRecipe.imageUrl;
        
        NSMutableDictionary *ingredienteLines = [[NSMutableDictionary alloc] init];
        NSNumber *numb = [[NSNumber alloc] initWithInt:0];
        for (Ingredient *ingredient in currentRecipe.ingredients) {
            [ingredienteLines setObject:ingredient.label forKey:numb];
            int value = [numb intValue];
            numb = [NSNumber numberWithInt:value + 1];
        }
        self.ingredientsLines = ingredienteLines;
    }
    self.textViewForRecipe.text = [NSString stringWithFormat:@"%@", _ingredientsLines];
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:_imageLink]
                                                         options:SDWebImageDownloaderLowPriority
                                                        progress:nil
                                                       completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        [self.imageForDish setBackgroundColor:[UIColor colorWithPatternImage:image]];
    }];
}

- (IBAction)saveRecipeToCoreData:(UIBarButtonItem *)sender {
    
    if (!self.recipeSaved){
        NSDictionary *recipeDict = [[self.availableRecipes objectAtIndex:self.recipeRow ] valueForKey:@"recipe"];
        self.recipe = [Recipe createRecipeWithInfo:recipeDict inManagedObiectContext:self.currentContext];
        self.recipeSaved = YES;
        sender.title = @"Delete";
        
    }else{
        NSMutableArray *availibleRecipes = [[NSMutableArray alloc] initWithArray:self.availableRecipes];
        [availibleRecipes removeObjectAtIndex:self.recipeRow];
        self.availableRecipes = availibleRecipes;
        [Recipe deleteRecipe:self.recipe fromManagedObjectContext:self.currentContext];
        self.recipeSaved = NO;
        sender.title = @"Save";
    }
    
}

- (void)ifCurrentRecipeSaved{
    //checking if current recipe is alredy in the data base
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    NSString *predicateString = [[NSString alloc] init];
    if ([self.dataSource isEqualToString:@"Search results"]) {
        predicateString = [[self.availableRecipes objectAtIndex:self.recipeRow] valueForKeyPath:@"recipe.label"];
    }else {
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
        if(self.recipeRow == self.availableRecipes.count) self.recipeRow = 0;
        self.recipeCountIndicator.text = [NSString stringWithFormat:@"%ld/%lu", (self.recipeRow + 1), self.availableRecipes.count];
        
    }else if (sender.direction == UISwipeGestureRecognizerDirectionRight){
        --self.recipeRow;
        if (self.recipeRow == -1) self.recipeRow = self.availableRecipes.count - 1;
        self.recipeCountIndicator.text = [NSString stringWithFormat:@"%ld/%lu", (self.recipeRow + 1), self.availableRecipes.count];
    }
    [self setRecipeWithImageContents:self.recipeRow];
    [self ifCurrentRecipeSaved];
}

@end
