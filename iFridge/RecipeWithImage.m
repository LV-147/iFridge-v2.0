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

@property (weak, nonatomic) IBOutlet UIImageView *frame;
@property (weak, nonatomic) IBOutlet UILabel *nameOfDish;
@property (weak, nonatomic) IBOutlet UITextView *recipeIngredients;
@property (weak, nonatomic) IBOutlet UIImageView *imageForDish;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UILabel *recipeCountIndicator;
@property (nonatomic) BOOL recipeSaved;
@property (strong, nonatomic) NSArray *availableRecipes;
@property (nonatomic, assign) NSInteger recipeRow;

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
    
    self.recipeCountIndicator.text = @"";
    
    [self ifCurrentRecipeSaved];
    
    [self setRecipeForRecipeIndex:_index];
    
    self.carousel.type = iCarouselTypeLinear;
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
    self.recipeRow = recipeIndex;
}

- (IBAction)googlePlusShareButton:(id)sender {
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    [shareBuilder open];
}

- (void) setRecipeForRecipeIndex:(NSInteger)recipeIndexPath
{
    if ([[self.availableRecipes objectAtIndex:self.recipeRow] isKindOfClass:[NSDictionary class]]) {
        [DataDownloader setRecipeImageWithURL:[[self.availableRecipes objectAtIndex:self.recipeRow] valueForKeyPath:@"recipe.image"]
                               usingImageView:self.imageForDish
                        withCompletionHandler:^{
                        
                        }];
        NSArray *ingredientLines = [[self.availableRecipes objectAtIndex:self.recipeRow] valueForKeyPath:@"recipe.ingredientLines"];
        self.recipeIngredients.text = [NSString stringWithFormat:@"Ingredient needed \n %@", ingredientLines];
        self.nameOfDish.text = [[self.availableRecipes objectAtIndex:recipeIndexPath] valueForKeyPath:@"recipe.label"];
        
    }else if ([[self.availableRecipes objectAtIndex:self.recipeRow] isKindOfClass:[Recipe class]]){
        Recipe *currentRecipe = [self.availableRecipes objectAtIndex:recipeIndexPath];
        
        [DataDownloader setRecipeImageWithURL:currentRecipe.imageUrl
                               usingImageView:self.imageForDish
                        withCompletionHandler:^{
                            
                        }];
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
        NSDictionary *recipeDict = [self.availableRecipes objectAtIndex:_index ];
        Recipe *currentRecipe = [Recipe createRecipeWithInfo:recipeDict inManagedObiectContext:self.currentContext];
        [availibleRecipes replaceObjectAtIndex:_index withObject:currentRecipe];
        sender.title = @"Delete";
        
    }else{
        NSDictionary *currentRecipeDict = [Recipe deleteRecipe:[self.availableRecipes objectAtIndex:_index] fromManagedObjectContext:self.currentContext];
        [availibleRecipes replaceObjectAtIndex:_index withObject:currentRecipeDict];
        sender.title = @"Save";
    }
    self.availableRecipes = availibleRecipes;
    
}


- (BOOL)ifCurrentRecipeSaved{
    //checking if current recipe is alredy in the data base
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    NSString *predicateString = [[NSString alloc] init];
    if ([[self.availableRecipes objectAtIndex:_index] isKindOfClass:[NSDictionary class]]) {
        predicateString = [[self.availableRecipes objectAtIndex:_index] valueForKeyPath:@"recipe.label"];
    }else if ([[self.availableRecipes objectAtIndex:_index] isKindOfClass:[Recipe class]]) {
        Recipe *currentRecipe = [self.availableRecipes objectAtIndex:_index];
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
        NSLog(@"Third: %ld", (long)index);
    //присвоєння тексту і картинки
    [DataDownloader setRecipeImageWithURL:[[self.availableRecipes objectAtIndex:index] valueForKeyPath:@"recipe.image"] usingImageView:recipeCarouselItem.recipeItemImage
     withCompletionHandler:^{
     }];
    recipeCarouselItem.recipeItemImage.contentMode = UIViewContentModeScaleAspectFit;
    
    recipeCarouselItem.recipeItemName.text = [[self.availableRecipes objectAtIndex:index] valueForKeyPath:@"recipe.label"];
    
    NSArray *ingredientLines = [[self.availableRecipes objectAtIndex:index] valueForKeyPath:@"recipe.ingredientLines"];
    recipeCarouselItem.recipeItemTextField.text = [NSString stringWithFormat:@"Ingredient needed \n %@", ingredientLines];

    [self ifCurrentRecipeSaved];
    return recipeCarouselItem;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    self.index = carousel.currentItemIndex;
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
    
}

@end
