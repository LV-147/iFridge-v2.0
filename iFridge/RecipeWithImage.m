//
//  RecipeWithImage.m
//  iFridge
//
//  Created by Alexey Pelekh on 5/15/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import "RecipeWithImage.h"
#import "Recipe+Cat.h"
#import "UIViewController+Context.h"
#import "AppDelegate.h"
#import "Ingredient.h"
#import "DataDownloader.h"
#import "ReminderTableViewController.h"
#import <GooglePlus/GPPShare.h>
#import <FBSDKShareKit/FBSDKLikeControl.h>
#import "RecipeCarouselItem.h"
#import "RecipesTVC.h"

@interface RecipeWithImage () <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UILabel *recipeCountIndicator;
@property (strong, nonatomic) RecipesTVC *masterRecipeController;
@property (nonatomic, assign) NSInteger recipeRow;
@end

@implementation RecipeWithImage

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.carousel.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    
    self.title = @"Recipe";
    
    self.recipeCountIndicator.text = @"";
    
    [self ifRecipeAtIndexSaved:self.index];
    
    self.carousel.type = iCarouselTypeLinear;
    self.carousel.scrollSpeed = 0.5;
    self.carousel.decelerationRate = 0.7;
    
    if (UIUserInterfaceIdiomPad)
        self.masterRecipeController = (RecipesTVC *)((UINavigationController *)[self.splitViewController.viewControllers objectAtIndex:0]).topViewController;
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    self.navigationController.toolbar.hidden = YES;
    
    self.carousel.currentItemIndex = self.index;
    self.carousel.scrollSpeed = 0.5;
}

- (void)awakeFromNib
{
    [self.carousel reloadData];
}

- (void)setIndex:(NSInteger)value {
    _index = value;
    self.recipeCountIndicator.text = [NSString stringWithFormat:@"%d/%d", _index+1, _carousel.numberOfItems];
}

- (IBAction)googlePlusShareButton:(id)sender {
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    NSURL *url = [[self.availableRecipes objectAtIndex:self.index] valueForKeyPath:@"recipe.image"];
    NSArray *ingredientLines = [[self.availableRecipes objectAtIndex:self.index] valueForKeyPath:@"recipe.ingredientLines"];
    NSString * result = [[ingredientLines valueForKey:@"description"] componentsJoinedByString:@"\n"];
    [shareBuilder setPrefillText:[NSString stringWithFormat:@"Look for such a great recipe from iFridge \n\n Ingredient needed \n %@%@", result, @"\n\n #говно_код"]];
    NSString *urlString = [NSString stringWithString:(NSString *)url];
    [shareBuilder setURLToShare:[NSURL URLWithString:urlString]];
    
    //    NSString *urlString = [url absoluteString];
    //[shareBuilder setPrefillText:@"Look for such a great recipe from iFridge #говно_код"];
    //[shareBuilder setURLToShare:url];
    
    //if ([myUrl isKindOfClass:[NSString class]]) {
    //    [shareBuilder setURLToShare:url];
    //    [shareBuilder setPrefillText:@"Look for such a great recipe from iFridge #"];
    //[shareBuilder setTitle:@"Look for such a great recipe from iFridge #" description:@"Look for such a great recipe from iFridge #" thumbnailURL:url];
    //    [shareBuilder setPrefillText:@"Look for such a great recipe from iFridge #говно_код"];
    //    [shareBuilder setURLToShare:url];
    
    
    [shareBuilder open];

}

- (void) shareOnGPlus {

    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    NSURL *url = [[self.availableRecipes objectAtIndex:self.index] valueForKeyPath:@"recipe.image"];
    NSArray *ingredientLines = [[self.availableRecipes objectAtIndex:self.index] valueForKeyPath:@"recipe.ingredientLines"];
    NSString * result = [[ingredientLines valueForKey:@"description"] componentsJoinedByString:@"\n"];
    [shareBuilder setPrefillText:[NSString stringWithFormat:@"Look for such a great recipe from iFridge \n\n Ingredient needed \n %@%@", result, @"\n\n #говно_код"]];
    NSString *urlString = [NSString stringWithString:(NSString *)url];
    [shareBuilder setURLToShare:[NSURL URLWithString:urlString]];
    [shareBuilder open];
}

- (void)saveRecipeToCoreData:(UIButton *)sender {
    
    if (![self ifRecipeAtIndexSaved:self.index]){
        NSDictionary *recipeDict = [self.availableRecipes objectAtIndex:_index ];
        Recipe *currRecipe = [Recipe createRecipeWithInfo:recipeDict inManagedObiectContext:self.currentContext];
        [self.availableRecipes replaceObjectAtIndex:self.index withObject:currRecipe];
        [sender setImage:[UIImage imageNamed:@"delete-icon.png"] forState:UIControlStateNormal];
        
    }else{
        [Recipe deleteRecipe:[self.availableRecipes objectAtIndex:self.index] fromManagedObjectContext:self.currentContext];
        [self.availableRecipes removeObjectAtIndex:_index];
        [self.carousel reloadData];
        self.recipeCountIndicator.text = [NSString stringWithFormat:@"%d/%d", _index+1, _carousel.numberOfItems];
        if (UIUserInterfaceIdiomPad) {
            self.masterRecipeController.recipes = self.availableRecipes;
            [self.masterRecipeController.tableView reloadData];
        }
    }
    
    if (!self.availableRecipes.count) {

        UIAlertView *noRecipecAvailible = [[UIAlertView alloc] initWithTitle:@"No recipes left"
                                                                     message:@"You just have deleted the last of them."
                                                                    delegate:self
                                                           cancelButtonTitle:nil
                                                           otherButtonTitles:@"OK", nil];
        [noRecipecAvailible show];
    }}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)ifRecipeAtIndexSaved:(NSUInteger)index {
    //checking if current recipe is alredy in the data base
    BOOL recipeSaved;
    if ([[self.availableRecipes objectAtIndex:index] isKindOfClass:[NSDictionary class]]) {
        NSDictionary *currRecipe = [self.availableRecipes objectAtIndex:index];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
        request.predicate = [NSPredicate predicateWithFormat:@"label = %@", [currRecipe valueForKeyPath:@"recipe.label"]];
        NSError *error;
        NSArray *mathes = [self.currentContext executeFetchRequest:request error:&error];
        if (mathes && !error && mathes.count == 1) {
            [self.availableRecipes replaceObjectAtIndex:self.index withObject:[Recipe createRecipeWithInfo:currRecipe inManagedObiectContext:self.currentContext]];
            recipeSaved = YES;
        }else{
            recipeSaved = NO;
        }
    }else if ([[self.availableRecipes objectAtIndex:index] isKindOfClass:[Recipe class]]) {
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
        recipeCarouselItem.recipeItemImage.image = [UIImage imageNamed:@"noimage"];
        [DataDownloader setRecipeImageWithURL:[[self.availableRecipes objectAtIndex:index] valueForKeyPath:@"recipe.image"]
                               usingImageView:recipeCarouselItem.recipeItemImage
                        withCompletionHandler:nil];

        NSArray *ingredientLines = [[self.availableRecipes objectAtIndex:index] valueForKeyPath:@"recipe.ingredientLines"];
        //        item.recipeItemTextField.text = [NSString stringWithFormat:@"Ingredient needed \n %@", ingredientLines];
        //        item.recipeItemName.text = [[self.availableRecipes objectAtIndex:self.index] valueForKeyPath:@"recipe.label"];
        recipeCarouselItem.recipeItemTextField.text = @"Ingredient needed:";
        for(NSString* str in ingredientLines){
            recipeCarouselItem.recipeItemTextField.text = [NSString stringWithFormat:@"%@ \n\t \"%@\"", recipeCarouselItem.recipeItemTextField.text, str];
        }
        recipeCarouselItem.recipeItemName.text = [[self.availableRecipes objectAtIndex:index] valueForKeyPath:@"recipe.label"];
        
    }else if ([[self.availableRecipes objectAtIndex:index] isKindOfClass:[Recipe class]]){
        Recipe *currentRecipe = [self.availableRecipes objectAtIndex:index];
        
        recipeCarouselItem.recipeItemImage.image = [UIImage imageNamed:@"noimage"];
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
    
    recipeCarouselItem.facebookButton.objectID = @"https://www.facebook.com/{sub_url}";
    recipeCarouselItem.facebookButton.objectType = FBSDKLikeObjectTypePage;
    
    [recipeCarouselItem.googleButton addTarget:self
                                        action:@selector(shareOnGPlus)
                              forControlEvents:UIControlEventTouchUpInside];
    //config save button
    if ([self ifRecipeAtIndexSaved:index])
        [recipeCarouselItem.saveButton setImage:[UIImage imageNamed:@"delete-icon.png"] forState:UIControlStateNormal];
    else
        [recipeCarouselItem.saveButton setImage:nil forState:UIControlStateNormal];

    [recipeCarouselItem.saveButton addTarget:self
                                      action:@selector(saveRecipeToCoreData:)
                            forControlEvents:UIControlEventTouchUpInside];
    return recipeCarouselItem;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
    self.index = carousel.currentItemIndex;
    [self.masterRecipeController.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.index inSection:0]
                                                       animated:YES
                                                 scrollPosition:UITableViewScrollPositionNone];
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel {
    CGFloat itemWidth = self.view.frame.size.width;
    return itemWidth;
}

#pragma mark Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"reminderSegue"]) {
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
    
}

@end
