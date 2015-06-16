//
//  Ingrediente+Cat.m
//  iFridge
//
//  Created by Vladius on 5/15/15.
//  Copyright (c) 2015 Vladius. All rights reserved.
//

#import "Ingredient+Cat.h"
#import "Fridge.h"

@implementation Ingredient (Cat)

+ (Ingredient *)addIngredientForRecipe:(Recipe *)recipe
                              withInfo:(NSDictionary *)ingredienteDict
                              toFridge:(Fridge *)fridge
                inManagedObiectContext:(NSManagedObjectContext *)context
{
    
    Ingredient *ingredient = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Ingredient"];
    request.predicate = [NSPredicate predicateWithFormat:@"label = %@", [ingredienteDict valueForKey:@"label"]];
    
    NSError *error;
    NSArray *mathes = [context executeFetchRequest:request error:&error];
    
    if (!mathes || error || mathes.count > 1) {
        NSLog(@"matches %@ /n error %@", mathes, error);
    }else if (mathes.count){
        ingredient = mathes.firstObject;
    }else{
        ingredient = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
        ingredient.label = [ingredienteDict valueForKeyPath:@"label"];
        ingredient.quantity = [ingredienteDict valueForKey:@"quantity"];
        if (recipe) ingredient.forRecipe = recipe;
        if (fridge) {
            ingredient.fromFridge = fridge;
        }
        [context save:NULL];
    }
    
    return ingredient;
}

+ (void)deleteIngredient:(Ingredient *)ingredient
              fromFridge:(Fridge *)fridge
  inManagedObjectContext:(NSManagedObjectContext *)context
{
    if (ingredient.fromFridge == fridge) {
        [context deleteObject:ingredient];
    }
}
@end
