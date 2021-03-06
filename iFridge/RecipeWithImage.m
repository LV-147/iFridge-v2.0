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

@property(strong, nonatomic) IBOutlet UILabel *recipeCountIndicator;
@property(strong, nonatomic) RecipesTVC *masterRecipeController;
@property(nonatomic, assign) NSInteger recipeRow;
@end

@implementation RecipeWithImage

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor =
      [UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];

  self.title = @"Recipe";

  self.recipeCountIndicator.text = @"";

  [self ifRecipeAtIndexSaved:self.index];

  self.carousel.type = iCarouselTypeLinear;
  self.carousel.scrollSpeed = 0.5;
  self.carousel.decelerationRate = 0.7;

  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    self.masterRecipeController =
        (RecipesTVC
             *)((UINavigationController *)
                    [self.splitViewController.viewControllers objectAtIndex:0])
            .topViewController;

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(orientationChanged:)
             name:UIDeviceOrientationDidChangeNotification
           object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  self.navigationController.view.backgroundColor =
      [UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
  self.navigationController.toolbar.hidden = YES;

  self.carousel.currentItemIndex = self.index;
  self.carousel.scrollSpeed = 0.5;
}

- (void)orientationChanged:(UIDeviceOrientation *)ori {
  [self.carousel scrollToItemAtIndex:self.index animated:NO];
}

- (void)awakeFromNib {
  [self.carousel reloadData];
}

- (void)setIndex:(NSInteger)value {

  _index = value;
  self.recipeCountIndicator.text = [NSString
      stringWithFormat:@"%d/%d", (int)_index + 1, (int)_carousel.numberOfItems];
}

- (IBAction)googlePlusShareButton:(id)sender {
  id<GPPNativeShareBuilder> shareBuilder =
      [[GPPShare sharedInstance] nativeShareDialog];
  NSURL *url = [[self.availableRecipes objectAtIndex:self.index]
      valueForKeyPath:@"recipe.image"];
  NSArray *ingredientLines = [[self.availableRecipes objectAtIndex:self.index]
      valueForKeyPath:@"recipe.ingredientLines"];
  NSString *result = [[ingredientLines valueForKey:@"description"]
      componentsJoinedByString:@"\n"];
  [shareBuilder
      setPrefillText:[NSString stringWithFormat:@"Look for such a great recipe "
                                                @"from iFridge \n\n "
                                                @"Ingredient needed \n %@%@",
                                                result, @"\n\n #говно_код"]];
  NSString *urlString = [NSString stringWithString:(NSString *)url];
  [shareBuilder setURLToShare:[NSURL URLWithString:urlString]];

  [shareBuilder open];
}

- (void)shareOnGPlus {
  id<GPPNativeShareBuilder> shareBuilder =
      [[GPPShare sharedInstance] nativeShareDialog];
  NSURL *url = [[self.availableRecipes objectAtIndex:self.index]
      valueForKeyPath:@"recipe.image"];
  NSArray *ingredientLines = [[self.availableRecipes objectAtIndex:self.index]
      valueForKeyPath:@"recipe.ingredientLines"];
  NSString *result = [[ingredientLines valueForKey:@"description"]
      componentsJoinedByString:@"\n"];
  [shareBuilder
      setPrefillText:[NSString stringWithFormat:@"Look for such a great recipe "
                                                @"from iFridge \n\n "
                                                @"Ingredient needed \n %@%@",
                                                result, @"\n\n #meal"]];
  NSString *urlString = [NSString stringWithString:(NSString *)url];
  [shareBuilder setURLToShare:[NSURL URLWithString:urlString]];
  [shareBuilder open];
}

#pragma mark Save
- (void)saveRecipeToCoreData:(UIButton *)sender {

  if (![self ifRecipeAtIndexSaved:self.index]) {
    NSDictionary *recipeDict = [self.availableRecipes objectAtIndex:_index];
    Recipe *currRecipe = [Recipe createRecipeWithInfo:recipeDict
                               inManagedObiectContext:self.currentContext];
    [self.availableRecipes replaceObjectAtIndex:self.index
                                     withObject:currRecipe];
    [sender setImage:[UIImage imageNamed:@"delete-icon.png"]
            forState:UIControlStateNormal];

  } else {
    [Recipe deleteRecipe:[self.availableRecipes objectAtIndex:self.index]
        fromManagedObjectContext:self.currentContext];
    [self.availableRecipes removeObjectAtIndex:_index];
    if (self.availableRecipes.count != 0 && self.index != 0) {
      self.index = self.index - 1;
    }

    [self.carousel reloadData];
    self.recipeCountIndicator.text =
        [NSString stringWithFormat:@"%d/%d", (int)_index + 1,
                                   (int)_carousel.numberOfItems];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
      self.masterRecipeController.recipes = self.availableRecipes;
      [self.masterRecipeController.tableView reloadData];
    }
  }

  if (!self.availableRecipes.count) {

    UIAlertView *noRecipecAvailible = [[UIAlertView alloc]
            initWithTitle:@"No recipes left"
                  message:@"You just have deleted the last of them."
                 delegate:self
        cancelButtonTitle:nil
        otherButtonTitles:@"OK", nil];
    [noRecipecAvailible show];
  }
}

- (void)alertView:(UIAlertView *)alertView
    clickedButtonAtIndex:(NSInteger)buttonIndex {
  [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)ifRecipeAtIndexSaved:(NSUInteger)index {
  // checking if current recipe is alredy in the data base
  BOOL recipeSaved = NO;
  if ([[self.availableRecipes objectAtIndex:index]
          isKindOfClass:[NSDictionary class]]) {
    NSDictionary *currRecipe = [self.availableRecipes objectAtIndex:index];
    NSFetchRequest *request =
        [NSFetchRequest fetchRequestWithEntityName:@"Recipe"];
    request.predicate = [NSPredicate
        predicateWithFormat:@"label = %@",
                            [currRecipe valueForKeyPath:@"recipe.label"]];
    NSError *error;
    NSArray *mathes =
        [self.currentContext executeFetchRequest:request error:&error];
    if (mathes && !error && mathes.count == 1) {
      [self.availableRecipes
          replaceObjectAtIndex:self.index
                    withObject:[Recipe
                                     createRecipeWithInfo:currRecipe
                                   inManagedObiectContext:self.currentContext]];
      recipeSaved = YES;
    } else {
      recipeSaved = NO;
    }
  } else if ([[self.availableRecipes objectAtIndex:index]
                 isKindOfClass:[Recipe class]]) {
    recipeSaved = YES;
  }
  return recipeSaved;
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel {
  return [self.availableRecipes count];
}

- (UIView *)carousel:(iCarousel *)carousel
  viewForItemAtIndex:(NSInteger)index
         reusingView:(UIView *)view {
  RecipeCarouselItem *recipeCarouselItem = nil;

  if (view == nil) {
    UINib *n = [UINib nibWithNibName:@"RecipeCarouselItem" bundle:nil];
    NSArray *a = [n instantiateWithOwner:self options:nil];
    recipeCarouselItem = [a firstObject];
      
  } else {
    recipeCarouselItem = (RecipeCarouselItem *)view;
  }
  //присвоєння тексту і картинки

  if ([[self.availableRecipes objectAtIndex:index]
          isKindOfClass:[NSDictionary class]]) {

    [DataDownloader
        setRecipeImageWithURL:[[self.availableRecipes objectAtIndex:index]
                                  valueForKeyPath:@"recipe.image"]
               usingImageView:recipeCarouselItem.recipeItemImage
        withCompletionHandler:nil];

    NSArray *ingredientLines = [[self.availableRecipes objectAtIndex:index]
        valueForKeyPath:@"recipe.ingredientLines"];

    recipeCarouselItem.recipeItemTextField.text = @"Ingredient needed:";
    for (NSString *str in ingredientLines) {
      recipeCarouselItem.recipeItemTextField.text = [NSString
          stringWithFormat:@"%@ \n\t \"%@\"",
                           recipeCarouselItem.recipeItemTextField.text, str];
    }
    recipeCarouselItem.recipeItemName.text =
        [[self.availableRecipes objectAtIndex:index]
            valueForKeyPath:@"recipe.label"];

  } else if ([[self.availableRecipes objectAtIndex:index]
                 isKindOfClass:[Recipe class]]) {
    Recipe *currentRecipe = [self.availableRecipes objectAtIndex:index];

    recipeCarouselItem.recipeItemImage.image = [UIImage imageNamed:@"noimage"];
    [DataDownloader setRecipeImageWithURL:currentRecipe.imageUrl
                           usingImageView:recipeCarouselItem.recipeItemImage
                    withCompletionHandler:nil];
    recipeCarouselItem.recipeItemName.text = currentRecipe.label;

    for (Ingredient *ingredient in currentRecipe.ingredients) {
      recipeCarouselItem.recipeItemTextField.text = [NSString
          stringWithFormat:@"%@ \n\t \"%@\"",
                           recipeCarouselItem.recipeItemTextField.text,
                           ingredient.label];
    }
  }

  if ([[self.availableRecipes objectAtIndex:self.index]
          isKindOfClass:[NSDictionary class]]) {
    NSURL *url = [[self.availableRecipes objectAtIndex:self.index]
        valueForKeyPath:@"recipe.url"];
    NSString *urlString = [NSString stringWithString:(NSString *)url];
    recipeCarouselItem.facebookButton.objectID = urlString;
    recipeCarouselItem.facebookButton.objectType = FBSDKLikeObjectTypePage;
  } else {
    recipeCarouselItem.facebookButton.objectID =
        @"https://www.facebook.com/groups/1599931206891002/";
    recipeCarouselItem.facebookButton.objectType = FBSDKLikeObjectTypePage;
  }

  [recipeCarouselItem.googleButton addTarget:self
                                      action:@selector(shareOnGPlus)
                            forControlEvents:UIControlEventTouchUpInside];

  // config save button
  if ([self ifRecipeAtIndexSaved:index])
    [recipeCarouselItem.saveButton
        setImage:[UIImage imageNamed:@"delete-icon.png"]
        forState:UIControlStateNormal];
  else
    [recipeCarouselItem.saveButton setImage:nil forState:UIControlStateNormal];

  [recipeCarouselItem.saveButton addTarget:self
                                    action:@selector(saveRecipeToCoreData:)
                          forControlEvents:UIControlEventTouchUpInside];

  [self.masterRecipeController.tableView
      scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.index
                                                inSection:0]
            atScrollPosition:UITableViewScrollPositionMiddle
                    animated:NO];

  return recipeCarouselItem;
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel {
  self.index = carousel.currentItemIndex;
  if ([self.availableRecipes count])
    [self.masterRecipeController.tableView
        selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.index
                                                inSection:0]
                    animated:NO
              scrollPosition:UITableViewScrollPositionBottom |
                             UITableViewScrollPositionTop];
}

#pragma mark Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  if ([segue.identifier isEqualToString:@"reminderSegue"]) {
    ReminderTableViewController *newController =
        segue.destinationViewController;
    if ([[self.availableRecipes objectAtIndex:_index]
            isKindOfClass:[NSDictionary class]]) {
      newController.ingredientsForReminder =
          [[self.availableRecipes objectAtIndex:_index]
              valueForKeyPath:@"recipe.ingredientLines"];
      newController.nameOfEventForCalendar =
          [[self.availableRecipes objectAtIndex:_index]
              valueForKeyPath:@"recipe.label"];

    } else {
      Recipe *currRecipe = [self.availableRecipes objectAtIndex:_index];
      NSMutableArray *ingredient = [[NSMutableArray alloc] init];
      for (Ingredient *ingr in currRecipe.ingredients) {
        [ingredient addObject:ingr.label];
      }
      newController.ingredientsForReminder =
          [NSArray arrayWithArray:ingredient];
      newController.nameOfEventForCalendar = currRecipe.label;
    }
  }
}

@end
