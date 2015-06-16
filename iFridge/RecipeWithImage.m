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
<<<<<<< HEAD
#import <GooglePlus/GPPShare.h>
#import <FacebookSDK/FacebookSDK.h>
#import "RecipeCarouselItem.h"
=======


>>>>>>> 59861c03c84206d85b8df742de75183a31311f7f

@interface RecipeWithImage ()

@property (weak, nonatomic) IBOutlet UILabel *nameOfDish;
@property (weak, nonatomic) IBOutlet UITextView *recipeIngredients;
@property (weak, nonatomic) IBOutlet UIImageView *imageForDish;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UILabel *recipeCountIndicator;
<<<<<<< HEAD
@property (nonatomic) BOOL recipeSaved;
@property (strong, nonatomic) NSArray *availableRecipes;
=======
@property (strong , nonatomic) DataDownloader *dataDownloader;
@property (nonatomic) BOOL recipeSaved;
@property (strong, nonatomic) NSArray *availableRecipes;
@property (nonatomic, assign) NSInteger recipeRow;

>>>>>>> 59861c03c84206d85b8df742de75183a31311f7f
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
    
<<<<<<< HEAD
    self.recipeCountIndicator.text = @"";
    
    [self ifCurrentRecipeSaved];
    
    self.carousel.type = iCarouselTypeLinear;
    self.carousel.scrollSpeed = 0.4;
    self.carousel.decelerationRate = 0.5;
    
    self.index = self.index;
}
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    
    self.carousel.currentItemIndex = self.index;
    self.carousel.scrollSpeed = 0.5;
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
}

- (void)awakeFromNib
{
    [self.carousel reloadData];
}

- (void)setIndex:(NSInteger)value {
    _index = value;
    self.recipeCountIndicator.text = [NSString stringWithFormat:@"%ld/%ld", _index+1, _carousel.numberOfItems];
}

- (void)initWithRecipeAtIndex:(NSInteger)recipeIndex from:(NSArray *)recipes {
    self.availableRecipes = recipes;
    self.index = recipeIndex;
    self.recipeCountIndicator.text = [NSString stringWithFormat:@"%ld/%ld", _index+1, _carousel.numberOfItems];
}

- (IBAction)googlePlusShareButton:(id)sender {
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    [shareBuilder open];
}

- (void) setRecipeForIndex:(NSInteger)index usingICaruselItem:(RecipeCarouselItem *)item
{
    if ([[self.availableRecipes objectAtIndex:self.index] isKindOfClass:[NSDictionary class]]) {
        [DataDownloader setRecipeImageWithURL:[[self.availableRecipes objectAtIndex:self.index] valueForKeyPath:@"recipe.image"]
                               usingImageView:item.recipeItemImage
                        withCompletionHandler:^{
                        //stop activity indicator
                        }];
        NSArray *ingredientLines = [[self.availableRecipes objectAtIndex:self.index] valueForKeyPath:@"recipe.ingredientLines"];
        item.recipeItemTextField.text = [NSString stringWithFormat:@"Ingredient needed \n %@", ingredientLines];
        item.recipeItemName.text = [[self.availableRecipes objectAtIndex:self.index] valueForKeyPath:@"recipe.label"];
        
    }else if ([[self.availableRecipes objectAtIndex:self.index] isKindOfClass:[Recipe class]]){
        Recipe *currentRecipe = [self.availableRecipes objectAtIndex:self.index];
        
        [DataDownloader setRecipeImageWithURL:currentRecipe.imageUrl
                               usingImageView:item.recipeItemImage
                        withCompletionHandler:^{
                           //don't forget stop activity indicator!!
                        }];
        item.recipeItemName.text = currentRecipe.label;
        
=======
    /*[self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = NO;*/
    self.navigationController.navigationBar.backgroundColor=[UIColor colorWithWhite:0xFFFFF alpha:0.8];

    
    self.recipeCountIndicator.text = [NSString stringWithFormat:@"%ld/%lu", (self.recipeRow + 1), (unsigned long)self.availableRecipes.count];
    
    [self ifCurrentRecipeSaved];
    
    [self setRecipeForRecipeIndex:self.recipeRow];

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
        
>>>>>>> 59861c03c84206d85b8df742de75183a31311f7f
        NSMutableDictionary *ingredientLines = [[NSMutableDictionary alloc] init];
        NSNumber *numb = [[NSNumber alloc] initWithInt:0];
        for (Ingredient *ingredient in currentRecipe.ingredients) {
            [ingredientLines setObject:ingredient.label forKey:numb];
            int value = [numb intValue];
            numb = [NSNumber numberWithInt:value + 1];
        }
<<<<<<< HEAD
        item.recipeItemTextField.text = [NSString stringWithFormat:@"Ingredient needed \n %@", [ingredientLines allValues]];
=======
        self.recipeIngredients.text = [NSString stringWithFormat:@"Ingredient needed \n %@", [ingredientLines allValues]];
>>>>>>> 59861c03c84206d85b8df742de75183a31311f7f
    }
}


- (IBAction)saveRecipeToCoreData:(UIBarButtonItem *)sender {
    
<<<<<<< HEAD
    NSMutableArray *availibleRecipes = [[NSMutableArray alloc] initWithArray:self.availableRecipes];
    
    if (![self ifCurrentRecipeSaved]){
        NSDictionary *recipeDict = [self.availableRecipes objectAtIndex:_index ];
        Recipe *currentRecipe = [Recipe createRecipeWithInfo:recipeDict inManagedObiectContext:self.currentContext];
        [availibleRecipes replaceObjectAtIndex:_index withObject:currentRecipe];
        sender.title = @"Delete";
        
    }else{
        NSDictionary *currentRecipeDict = [Recipe deleteRecipe:[self.availableRecipes objectAtIndex:_index] fromManagedObjectContext:self.currentContext];
        [availibleRecipes replaceObjectAtIndex:_index withObject:currentRecipeDict];
=======
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
>>>>>>> 59861c03c84206d85b8df742de75183a31311f7f
        sender.title = @"Save";
    }
    self.availableRecipes = availibleRecipes;
    
}


- (BOOL)ifCurrentRecipeSaved{
    //checking if current recipe is alredy in the data base
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    NSString *predicateString = [[NSString alloc] init];
<<<<<<< HEAD
    if ([[self.availableRecipes objectAtIndex:_index] isKindOfClass:[NSDictionary class]]) {
        predicateString = [[self.availableRecipes objectAtIndex:_index] valueForKeyPath:@"recipe.label"];
    }else if ([[self.availableRecipes objectAtIndex:_index] isKindOfClass:[Recipe class]]) {
        Recipe *currentRecipe = [self.availableRecipes objectAtIndex:_index];
=======
    if ([self.availableRecipes.firstObject isKindOfClass:[NSDictionary class]]) {
        predicateString = [[self.availableRecipes objectAtIndex:self.recipeRow] valueForKeyPath:@"recipe.label"];
    }else if ([self.availableRecipes.firstObject isKindOfClass:[Recipe class]]) {
        Recipe *currentRecipe = [self.availableRecipes objectAtIndex:self.recipeRow];
>>>>>>> 59861c03c84206d85b8df742de75183a31311f7f
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
    
    if (view == nil)
    {
        UINib *n = [UINib nibWithNibName:@"RecipeCarouselItem" bundle:nil];
        NSArray *a = [n instantiateWithOwner:self options:nil];
        recipeCarouselItem = [a firstObject];
        
        [recipeCarouselItem layoutSubviews];
    }
    else
    {
        recipeCarouselItem = (RecipeCarouselItem *)view;
        self.recipeCountIndicator.text = [NSString stringWithFormat:@"%ld", carousel.currentItemIndex];
    }
    //присвоєння тексту і картинки

    if ([[self.availableRecipes objectAtIndex:index] isKindOfClass:[NSDictionary class]]) {
        [DataDownloader setRecipeImageWithURL:[[self.availableRecipes objectAtIndex:index] valueForKeyPath:@"recipe.image"]
                               usingImageView:recipeCarouselItem.recipeItemImage
                        withCompletionHandler:nil];
        NSArray *ingredientLines = [[self.availableRecipes objectAtIndex:index] valueForKeyPath:@"recipe.ingredientLines"];
        recipeCarouselItem.recipeItemTextField.text = [NSString stringWithFormat:@"Ingredient needed \n %@", ingredientLines];
        recipeCarouselItem.recipeItemName.text = [[self.availableRecipes objectAtIndex:index] valueForKeyPath:@"recipe.label"];
        
    }else if ([[self.availableRecipes objectAtIndex:index] isKindOfClass:[Recipe class]]){
        Recipe *currentRecipe = [self.availableRecipes objectAtIndex:index];
        
        [DataDownloader setRecipeImageWithURL:currentRecipe.imageUrl
                               usingImageView:recipeCarouselItem.recipeItemImage
                        withCompletionHandler:nil];
        recipeCarouselItem.recipeItemName.text = currentRecipe.label;
        
        NSMutableDictionary *ingredientLines = [[NSMutableDictionary alloc] init];
        NSNumber *numb = [[NSNumber alloc] initWithInt:0];
        for (Ingredient *ingredient in currentRecipe.ingredients) {
            [ingredientLines setObject:ingredient.label forKey:numb];
            int value = [numb intValue];
            numb = [NSNumber numberWithInt:value + 1];
        }
        recipeCarouselItem.recipeItemTextField.text = [NSString stringWithFormat:@"Ingredient needed \n %@", [ingredientLines allValues]];
    }
<<<<<<< HEAD
    return recipeCarouselItem;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    self.index = carousel.currentItemIndex;
    [self ifCurrentRecipeSaved];
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    CGFloat itemWidth = self.view.frame.size.width;
    return itemWidth;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ReminderTableViewController *newController = segue.destinationViewController;
    if ([[self.availableRecipes objectAtIndex:_index] isKindOfClass:[NSDictionary class]]) {
        newController.ingredientsForReminder = [[self.availableRecipes objectAtIndex:_index] valueForKeyPath:@"recipe.ingredientLines"];
        newController.nameOfEventForCalendar = [[self.availableRecipes objectAtIndex:_index] valueForKeyPath:@"recipe.label"];

    } else {
        Recipe *currRecipe = [self.availableRecipes objectAtIndex:_index];
        NSMutableArray *ingredient = [[NSMutableArray alloc] init];
        for (Ingredient *ingr in currRecipe.ingredients) {
            [ingredient addObject:ingr.label];
        }
        newController.ingredientsForReminder = [NSArray arrayWithArray:ingredient];
        newController.nameOfEventForCalendar = currRecipe.label;
    }
=======
    [self setRecipeForRecipeIndex:self.recipeRow];
    [self ifCurrentRecipeSaved];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    ReminderTableViewController *newController = segue.destinationViewController;
    newController.ingredientsForReminder = [[self.availableRecipes objectAtIndex:self.recipeRow] valueForKeyPath:@"recipe.ingredientLines"];
>>>>>>> 59861c03c84206d85b8df742de75183a31311f7f
    
}

@end
