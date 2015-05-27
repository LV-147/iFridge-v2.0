//
//  RecipeWithImage.h
//  iFridge
//
//  Created by Alexey Pelekh on 5/15/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//


#import <SDWebImage/SDWebImageDownloader.h>
#import <SDWebImage/SDWebImageManager.h>
#import "Recipe.h"

@interface RecipeWithImage : UIViewController
@property (strong, nonatomic) IBOutlet UIImageView *imageForDish;
@property (strong, nonatomic) IBOutlet UITextView *textViewForRecipe;

@property (strong, nonatomic) NSString * imageLink;
@property (strong, nonatomic) NSDictionary * ingredientsLines;

@property (strong, nonatomic) NSDictionary *recipeDict;
@property (nonatomic) BOOL recipeSaved;
@property (nonatomic, strong)Recipe *recipe;

@property (strong, nonatomic) NSArray *avaivableRecipes;
@property (strong, nonatomic) NSArray *savedRecipes;

@property (strong, nonatomic) NSMutableArray *recipeName;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (strong, nonatomic)NSString *dataSource;
@property (nonatomic, assign) NSInteger recipeRow;
- (void) setRecipeWithImageContents:(NSInteger)recipeIndexPath;


@end
