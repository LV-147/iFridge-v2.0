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

@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (strong, nonatomic) IBOutlet UILabel *recipeCountIndicator;
@property (nonatomic) BOOL recipeSaved;
@property (strong, nonatomic) NSArray *availableRecipes;
@property FBLikeControl *like;
@end

@implementation RecipeWithImage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    self.carousel.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    
    self.like = [[FBLikeControl alloc] init];
    self.like.frame = CGRectMake(10, 633, self.like.frame.size.width, self.like.frame.size.height);
    self.like.objectID = @"https://www.facebook.com/groups/1599931206891002";
    self.like.likeControlStyle = FBLikeControlStyleButton;
    self.like.objectType = FBLikeControlObjectTypePage;
    [self.view addSubview:self.like];
    
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
    //self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    
    self.carousel.currentItemIndex = self.index;
    self.carousel.scrollSpeed = 0.5;
    
   // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
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
        
        NSMutableDictionary *ingredientLines = [[NSMutableDictionary alloc] init];
        NSNumber *numb = [[NSNumber alloc] initWithInt:0];
        for (Ingredient *ingredient in currentRecipe.ingredients) {
            [ingredientLines setObject:ingredient.label forKey:numb];
            int value = [numb intValue];
            numb = [NSNumber numberWithInt:value + 1];
        }
        item.recipeItemTextField.text = [NSString stringWithFormat:@"Ingredient needed \n %@", [ingredientLines allValues]];
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
/*
- (void)didRotateFromInterfaceOrientation:
(UIInterfaceOrientation)fromInterfaceOrientation {
    
    CGRect currentBounds=self.view.bounds;
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight || self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        // self.movingImageForDish.frame = CGRectMake(30, 50, self.movingImageForDish.frame.size.width, self.movingImageForDish.frame.size.height);
        [self.movingImageForDish moveTo:
         CGPointMake(self.view.center.x - (self.movingImageForDish.frame.size.width+75),
                     self.view.center.y - (self.movingImageForDish.frame.size.height-90))
                               duration:0.3 option:0];
        [self.movingPhotoFrame moveTo:
         CGPointMake(self.view.center.x - (self.movingPhotoFrame.frame.size.width+50),
                     self.view.center.y - (self.movingPhotoFrame.frame.size.height-170))
                             duration:0.3 option:0];
        [self.movingNameForDish moveTo:
         CGPointMake(self.view.center.x - (self.movingNameForDish.frame.size.width+65),
                     self.view.center.y - (self.movingNameForDish.frame.size.height-140))
                              duration:0.3 option:0];
        [self.movingNotePaper moveTo:
         CGPointMake(self.view.center.x - (self.movingNotePaper.frame.size.width-300),
                     self.view.center.y - (self.movingNotePaper.frame.size.height-130))
                            duration:0.3 option:0];
        [self.movingRecipeIngredients moveTo:
         CGPointMake(self.view.center.x - (self.movingRecipeIngredients.frame.size.width-290),
                     self.view.center.y - (self.movingRecipeIngredients.frame.size.height-110))
                                    duration:0.3 option:0];
        self.like.frame = CGRectMake(10, 341, self.like.frame.size.width, self.like.frame.size.height);
        
    } else {
        self.view=self.portraitView;
        self.like.frame = CGRectMake(10, 633, self.like.frame.size.width, self.like.frame.size.height);
    }
    self.view.bounds=currentBounds;
    
}
*/

- (void)didRotateFromInterfaceOrientation:
(UIInterfaceOrientation)fromInterfaceOrientation {
    
    CGRect currentBounds=self.view.bounds;
    
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight || self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
               self.like.frame = CGRectMake(10, 341, self.like.frame.size.width, self.like.frame.size.height);
        
    } else {
        self.like.frame = CGRectMake(10, 633, self.like.frame.size.width, self.like.frame.size.height);
    }
    self.view.bounds=currentBounds;
    
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
