//
//  RecipeWithImage.m
//  iFridge
//
//  Created by Lv-147 on 5/15/15.
//  Copyright (c) 2015 Lv-147. All rights reserved.
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

@interface RecipeWithImage () <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UILabel *recipeCountIndicator;
@property (strong, nonatomic) NSMutableArray *availableRecipes;
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
    self.availableRecipes = [[NSMutableArray alloc] initWithArray:recipes];
    self.index = recipeIndex;
    self.recipeCountIndicator.text = [NSString stringWithFormat:@"%ld/%ld", _index+1, _carousel.numberOfItems];
}

- (IBAction)googlePlusShareButton:(id)sender {
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    [shareBuilder open];
}

- (IBAction)saveRecipeToCoreData:(UIBarButtonItem *)sender {
    
    if (![self ifCurrentRecipeSaved]){
        NSDictionary *recipeDict = [self.availableRecipes objectAtIndex:_index ];
        Recipe *currRecipe = [Recipe createRecipeWithInfo:recipeDict inManagedObiectContext:self.currentContext];
        [self.availableRecipes replaceObjectAtIndex:self.index withObject:currRecipe];
        sender.title = @"Delete";
        
    }else{
        [Recipe deleteRecipe:[self.availableRecipes objectAtIndex:self.index] fromManagedObjectContext:self.currentContext];
        [self.availableRecipes removeObjectAtIndex:_index];
        sender.title = @"Save";
    }
    
    if (self.availableRecipes.count) {
        [self.carousel reloadData];
        self.recipeCountIndicator.text = [NSString stringWithFormat:@"%ld/%ld", _index+1, _carousel.numberOfItems];
    }else{
        UIAlertView *noRecipecAvailible = [[UIAlertView alloc] initWithTitle:@"No recipes left"
                                                                     message:@"You just have deleted the last of them."
                                                                    delegate:self
                                                           cancelButtonTitle:nil
                                                           otherButtonTitles:@"OK", nil];
        [noRecipecAvailible show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (BOOL)ifCurrentRecipeSaved{
    //checking if current recipe is alredy in the data base
    BOOL recipeSaved;
    if ([[self.availableRecipes objectAtIndex:_index] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *currRecipe = [self.availableRecipes objectAtIndex:_index];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
        request.predicate = [NSPredicate predicateWithFormat:@"label = %@", [currRecipe valueForKeyPath:@"recipe.label"]];
        NSError *error;
        NSArray *mathes = [self.currentContext executeFetchRequest:request error:&error];
        if (mathes && !error && mathes.count == 1) {
            [self.availableRecipes replaceObjectAtIndex:self.index withObject:[Recipe createRecipeWithInfo:currRecipe inManagedObiectContext:self.currentContext]];
            self.saveButton.title = @"Delete";
            recipeSaved = YES;
        }else{
            self.saveButton.title = @"Save";
            recipeSaved = NO;
        }
    }else if ([[self.availableRecipes objectAtIndex:_index] isKindOfClass:[Recipe class]]) {
        self.saveButton.title = @"Delete";
        recipeSaved = YES;
    }
    return recipeSaved;
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
    }
    //присвоєння тексту і картинки

    if ([[self.availableRecipes objectAtIndex:index] isKindOfClass:[NSDictionary class]]) {
        [DataDownloader setRecipeImageWithURL:[[self.availableRecipes objectAtIndex:index] valueForKeyPath:@"recipe.image"]
                               usingImageView:recipeCarouselItem.recipeItemImage
                        withCompletionHandler:NULL];
        NSArray *ingredientLines = [[self.availableRecipes objectAtIndex:index] valueForKeyPath:@"recipe.ingredientLines"];
        recipeCarouselItem.recipeItemTextField.text = [NSString stringWithFormat:@"Ingredient needed \n %@", ingredientLines];
        recipeCarouselItem.recipeItemName.text = [[self.availableRecipes objectAtIndex:index] valueForKeyPath:@"recipe.label"];
        
    }else if ([[self.availableRecipes objectAtIndex:index] isKindOfClass:[Recipe class]]){
        Recipe *currentRecipe = [self.availableRecipes objectAtIndex:index];
        
        [DataDownloader setRecipeImageWithURL:currentRecipe.imageUrl
                               usingImageView:recipeCarouselItem.recipeItemImage
                        withCompletionHandler:NULL];
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

#pragma mark Navigation
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
