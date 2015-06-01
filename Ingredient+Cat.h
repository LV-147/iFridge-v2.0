//
//  Ingrediente+Cat.h
//  iFridge
//
//  Created by Vladius on 5/15/15.
//  Copyright (c) 2015 Vladius. All rights reserved.
//

#import "Ingredient.h"
#import "Recipe.h"

@interface Ingredient (Cat)
+ (Ingredient *)addIngredientForRecipe:(Recipe *)recipe
                                withInfo:(NSDictionary *)ingredienteDict
                  inManagedObiectContext:(NSManagedObjectContext *)context;

@end
