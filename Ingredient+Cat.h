//
//  Ingrediente+Cat.h
//  iFridge
//
//  Created by Vladius on 5/15/15.
//  Copyright (c) 2015 Vladius. All rights reserved.
//

#import "Ingredient.h"
#import "Recipe.h"

#define INGREDIENT_LABEL_KEY @"text"
#define INGREDIENT_QUANTITY_KEY @"quantity"
#define INGREDIENT_MEASURE_KEY @"measure"

@interface Ingredient (Cat)
+ (Ingredient *)addIngredientForRecipe:(Recipe *)recipe
                              withInfo:(NSDictionary *)ingredienteDict
                              toFridge:(Fridge *)fridge
                inManagedObiectContext:(NSManagedObjectContext *)context;

+ (void)deleteIngredient:(Ingredient *)ingredient
              fromFridge:(Fridge *)fridge
  inManagedObjectContext:(NSManagedObjectContext *)context;

@end
