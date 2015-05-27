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
    
    
    UISwipeGestureRecognizer * swipeleft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeleft:)];
    swipeleft.direction=UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeleft];
    
    UISwipeGestureRecognizer * swiperight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swiperight:)];
    swiperight.direction=UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swiperight];
    
    self.recipeCountIndicator.text = [NSString stringWithFormat:@"%ld/%lu", (self.recipeRow + 1), (unsigned long)self.avaivableRecipes.count];
    
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
        self.imageLink = self.avaivableRecipes[recipeIndexPath][@"recipe"][@"image"];
        self.ingredientsLines = self.avaivableRecipes[recipeIndexPath][@"recipe"][@"ingredientLines"];
        
    }else{
        Recipe *currentRecipe = [self.avaivableRecipes objectAtIndex:recipeIndexPath];
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
    [[SDWebImageDownloader sharedDownloader]downloadImageWithURL:[NSURL URLWithString:_imageLink] options:SDWebImageDownloaderLowPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        [self.imageForDish setBackgroundColor:[UIColor colorWithPatternImage:image]];
    }];
}

- (IBAction)saveRecipeToCoreData:(UIBarButtonItem *)sender {
    
    if (!self.recipeSaved){
        NSDictionary *recipeDict = [[self.avaivableRecipes objectAtIndex:self.recipeRow ] valueForKey:@"recipe"];
        self.recipe = [Recipe createRecipeWithInfo:recipeDict inManagedObiectContext:self.currentContext];
        self.recipeSaved = YES;
        sender.title = @"Delete";
        
    }else{
        NSMutableArray *availibleRecipes = [[NSMutableArray alloc] initWithArray:self.avaivableRecipes];
        [availibleRecipes removeObjectAtIndex:self.recipeRow];
        self.avaivableRecipes = availibleRecipes;
        [Recipe deleteRecipe:self.recipe fromManagedObjectContext:self.currentContext];
        self.recipeSaved = NO;
        sender.title = @"Save";
    }
    
}

- (void)swipeleft:(UISwipeGestureRecognizer*)gestureRecognizer
{
    self.recipeSaved = NO;
    self.saveButton.title = @"Save";
    
    //    if ([self.dataSource isEqualToString:@"Search results"]) {
    //selected row
    ++self.recipeRow;
    if(self.recipeRow == self.avaivableRecipes.count) self.recipeRow = 0;
    
    self.recipeCountIndicator.text = [NSString stringWithFormat:@"%ld/%lu", (self.recipeRow + 1), self.avaivableRecipes.count];
    [self setRecipeWithImageContents:self.recipeRow];
}

- (void)swiperight:(UISwipeGestureRecognizer*)gestureRecognizer
{
    self.recipeSaved = NO;
    self.saveButton.title = @"Save";
    
    --self.recipeRow;
    if (self.recipeRow == -1) self.recipeRow = self.avaivableRecipes.count - 1;
    
    [self setRecipeWithImageContents:self.recipeRow];
    self.recipeCountIndicator.text = [NSString stringWithFormat:@"%ld/%lu", (self.recipeRow + 1), self.avaivableRecipes.count];
}

@end
