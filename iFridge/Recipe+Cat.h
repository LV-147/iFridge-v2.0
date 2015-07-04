//
//  Recipe+Cat.h
//  iFridge
//
//  Created by Vladius on 5/15/15.
//  Copyright (c) 2015 Vladius. All rights reserved.
//

#import "Recipe.h"

#define RECIPE_LABEL_KEYPATH @"recipe.label"
#define RECIPE_IMAGE_KEYPATH @"recipe.image"
#define RECIPE_COOKING_TIME_KEYPATH @"recipe.cookingTime"
#define RECIPE_WEIGHT_KEYPATH @"recipe.totalWeight"
#define RECIPE_CALORIES_KEYPATH @"recipe.calories"
#define RECIPE_INGREDIENTS_KEYPATH @"recipe.ingredients"

@interface Recipe (Cat)

+ (Recipe *)createRecipeWithInfo:(NSDictionary *)recipeDict
          inManagedObiectContext:(NSManagedObjectContext *)context;

+ (void)deleteRecipe:(Recipe *)recipe fromManagedObjectContext:(NSManagedObjectContext *)context;

@end
