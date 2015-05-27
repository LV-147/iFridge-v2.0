//
//  Ingrediente+Cat.m
//  iFridge
//
//  Created by Vladius on 5/15/15.
//  Copyright (c) 2015 Vladius. All rights reserved.
//

#import "Ingredient+Cat.h"

@implementation Ingredient (Cat)

+ (Ingredient *)addIngredientForRecipe:(Recipe *)recipe
                                withInfo:(NSDictionary *)ingredienteDict
                  inManagedObiectContext:(NSManagedObjectContext *)context{
    
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
        ingredient.label = [ingredienteDict valueForKey:@"label"];
        ingredient.quantity = [ingredienteDict valueForKey:@"quantity"];
        ingredient.forRecipe = recipe;
        [context save:NULL];
    }
    
    return ingredient;
}

@end
