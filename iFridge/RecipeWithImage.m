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
#import <GooglePlus/GPPShare.h>
#import <FacebookSDK/FacebookSDK.h>
#import "RecipeCarouselItem.h"

@interface RecipeWithImage ()

@property (weak, nonatomic) IBOutlet UILabel *nameOfDish;
@property (weak, nonatomic) IBOutlet UITextView *recipeIngredients;
@property (weak, nonatomic) IBOutlet UIImageView *imageForDish;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UILabel *recipeCountIndicator;
@property (nonatomic) BOOL recipeSaved;
@property (strong, nonatomic) NSArray *availableRecipes;
@property (nonatomic, assign) NSInteger recipeRow;
@property (strong, nonatomic) IBOutlet UIImageView *frame;

@end

@implementation RecipeWithImage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    self.carousel.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    
    FBLikeControl *like = [[FBLikeControl alloc] init];
    like.frame = CGRectMake(16, 589, like.frame.size.width, like.frame.size.height);
    like.objectID = @"https://www.facebook.com/groups/1599931206891002";
    like.likeControlStyle = FBLikeControlStyleButton;
    like.objectType = FBLikeControlObjectTypePage;
    [self.view addSubview:like];
    
    self.title = @"Recipe";

    self.view.backgroundColor = [UIColor clearColor];
    
    self.recipeCountIndicator.text = [NSString stringWithFormat:@"%ld/%lu", (self.recipeRow + 1), (unsigned long)self.availableRecipes.count];
    
    [self ifCurrentRecipeSaved];
    
    [self setRecipeForRecipeIndex:self.recipeRow];
    
    self.carousel.type = iCarouselTypeLinear;

}
- (void) viewWillAppear:(BOOL)animated {
   self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    
}

- (void)awakeFromNib
{
    [self.carousel reloadData];
}


- (void)initWithRecipeAtIndex:(NSInteger)recipeIndex from:(NSArray *)recipes {
    self.availableRecipes = recipes;
    self.recipeRow = recipeIndex;
}

- (IBAction)googlePlusShareButton:(id)sender {
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    [shareBuilder open];
}

- (void) setRecipeForRecipeIndex:(NSInteger)recipeIndexPath
{
    if ([[self.availableRecipes objectAtIndex:self.recipeRow] isKindOfClass:[NSDictionary class]]) {
        [DataDownloader setRecipeImageWithURL:[[self.availableRecipes objectAtIndex:self.recipeRow] valueForKeyPath:@"recipe.image"] usingImageView:self.imageForDish];
        NSArray *ingredientLines = [[self.availableRecipes objectAtIndex:self.recipeRow] valueForKeyPath:@"recipe.ingredientLines"];
        self.recipeIngredients.text = [NSString stringWithFormat:@"Ingredient needed \n %@", ingredientLines];
        self.nameOfDish.text = [[self.availableRecipes objectAtIndex:recipeIndexPath] valueForKeyPath:@"recipe.label"];
        
    }else if ([[self.availableRecipes objectAtIndex:self.recipeRow] isKindOfClass:[Recipe class]]){
        Recipe *currentRecipe = [self.availableRecipes objectAtIndex:recipeIndexPath];
        
        [DataDownloader setRecipeImageWithURL:currentRecipe.imageUrl usingImageView:self.imageForDish];
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
    
    NSMutableArray *availibleRecipes = [[NSMutableArray alloc] initWithArray:self.availableRecipes];
    
    if (![self ifCurrentRecipeSaved]){
        NSDictionary *recipeDict = [self.availableRecipes objectAtIndex:self.recipeRow ];
        Recipe *currentRecipe = [Recipe createRecipeWithInfo:recipeDict inManagedObiectContext:self.currentContext];
        [availibleRecipes replaceObjectAtIndex:self.recipeRow withObject:currentRecipe];
        sender.title = @"Delete";
        
    }else{
        NSDictionary *currentRecipeDict = [Recipe deleteRecipe:[self.availableRecipes objectAtIndex:self.recipeRow] fromManagedObjectContext:self.currentContext];
        [availibleRecipes replaceObjectAtIndex:self.recipeRow withObject:currentRecipeDict];
        sender.title = @"Save";
    }
    self.availableRecipes = availibleRecipes;
    
}


- (BOOL)ifCurrentRecipeSaved{
    //checking if current recipe is alredy in the data base
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    NSString *predicateString = [[NSString alloc] init];
    if ([[self.availableRecipes objectAtIndex:self.recipeRow] isKindOfClass:[NSDictionary class]]) {
        predicateString = [[self.availableRecipes objectAtIndex:self.recipeRow] valueForKeyPath:@"recipe.label"];
    }else if ([[self.availableRecipes objectAtIndex:self.recipeRow] isKindOfClass:[Recipe class]]) {
        Recipe *currentRecipe = [self.availableRecipes objectAtIndex:self.recipeRow];
        predicateString = currentRecipe.label;
    }
    request.predicate = [NSPredicate predicateWithFormat:@"label = %@", predicateString];
    
    NSError *error;
    NSArray *mathes = [self.currentContext executeFetchRequest:request error:&error];
    if (mathes && !error && mathes.count == 1) {
        self.saveButton.title = @"Delete";
        return YES;
    }else{
        self.saveButton.title = @"Save";
        return NO;
    }
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.availableRecipes count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    RecipeCarouselItem *recipeCarouselItem = nil;
    //index = self.recipeRow;
    
    //NSLog(@"%ld", index);
    //CGRect deviceViewRect = self.view.frame.size.height;
    
    //переписати кусок для індикатора
    self.recipeCountIndicator.text = [NSString stringWithFormat:@"%ld/%lu", ([carousel indexOfItemViewOrSubview:view] + 1), self.availableRecipes.count];
    
    if (view == nil)
    {
        recipeCarouselItem = [RecipeCarouselItem new];
        recipeCarouselItem.frame = self.view.frame;//CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height);
        
        recipeCarouselItem.recipeItemImage = [UIImageView new];
        [recipeCarouselItem addSubview:recipeCarouselItem.recipeItemImage];
        recipeCarouselItem.recipeItemImage.frame = self.imageForDish.frame;//CGRectMake(0, 0, 230, 230);
        recipeCarouselItem.recipeItemImage.bounds = self.imageForDish.bounds;//CGRectMake(0, 0, 230, 230);
        
        recipeCarouselItem.recipeItemFrame = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image-frame.png"]];
        [recipeCarouselItem addSubview:recipeCarouselItem.recipeItemFrame];
        recipeCarouselItem.recipeItemFrame.frame = self.frame.frame;//CGRectMake(0, 0, 230, 230);
        recipeCarouselItem.recipeItemFrame.bounds = self.frame.bounds;//CGRectMake(0, 0, 230, 230);
        
        recipeCarouselItem.recipeItemName = [UILabel new];
        [recipeCarouselItem addSubview:recipeCarouselItem.recipeItemName];
        recipeCarouselItem.recipeItemName.textAlignment = NSTextAlignmentCenter;
        recipeCarouselItem.recipeItemName.frame = self.nameOfDish.frame;//CGRectMake(0, 0, 230, 230);
        recipeCarouselItem.recipeItemName.bounds = self.nameOfDish.bounds;//CGRectMake(0, 0, 230, 230);
        
        recipeCarouselItem.recipeItemTextField = [UITextView new];
        [recipeCarouselItem addSubview:recipeCarouselItem.recipeItemTextField];
        recipeCarouselItem.recipeItemTextField.selectable = NO;
        recipeCarouselItem.recipeItemTextField.frame = self.recipeIngredients.frame;//CGRectMake(100, 100, 400, 500);
        recipeCarouselItem.recipeItemTextField.bounds = self.recipeIngredients.bounds;//CGRectMake(100, 100, 400, 500);
        recipeCarouselItem.recipeItemTextField.alpha = 0.9;//self.recipeIngredients.alpha;
        
        [recipeCarouselItem layoutSubviews];
    }
    else
    {
        recipeCarouselItem = (RecipeCarouselItem *)view;
    }
    //присвоєння тексту і картинки
    [DataDownloader setRecipeImageWithURL:[[self.availableRecipes objectAtIndex:index] valueForKeyPath:@"recipe.image"] usingImageView:recipeCarouselItem.recipeItemImage];
    recipeCarouselItem.recipeItemImage.contentMode = UIViewContentModeScaleAspectFit;
    
    recipeCarouselItem.recipeItemName.text = [[self.availableRecipes objectAtIndex:index] valueForKeyPath:@"recipe.label"];
    
    NSArray *ingredientLines = [[self.availableRecipes objectAtIndex:index] valueForKeyPath:@"recipe.ingredientLines"];
    recipeCarouselItem.recipeItemTextField.text = [NSString stringWithFormat:@"Ingredient needed \n %@", ingredientLines];

    NSLog(@"%@", [[self.availableRecipes objectAtIndex:index] valueForKeyPath:@"recipe.label"]);
    
    return recipeCarouselItem;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    CGFloat itemWidth = self.view.frame.size.width;
    return itemWidth;
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
        newController.nameOfEventForCalendar = [[self.availableRecipes objectAtIndex:self.recipeRow] valueForKeyPath:@"recipe.label"];

    } else {
        Recipe *currRecipe = [self.availableRecipes objectAtIndex:self.recipeRow];
        NSMutableArray *ingredient = [[NSMutableArray alloc] init];
        for (Ingredient *ingr in currRecipe.ingredients) {
            [ingredient addObject:ingr.label];
        }
        newController.ingredientsForReminder = [NSArray arrayWithArray:ingredient];
        newController.nameOfEventForCalendar = currRecipe.label;
    }
    
}

@end
