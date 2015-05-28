//
//  Fridge+Cat.m
//  iFridge
//
//  Created by Vladius on 5/18/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import "Fridge+Cat.h"
#import "Ingredient.h"

@implementation Fridge (Cat)

+ (Ingredient *)addIngredientWithInfo:(NSDictionary *)ingredientDict
                             toFridge:(Fridge *)fridge
               inManagedObjectContext:(NSManagedObjectContext *)context{
    
    Ingredient *ingredient = nil;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Ingredient"];
    request.predicate = [NSPredicate predicateWithFormat:@"label = %@", [ingredientDict valueForKey:@"label"]];
    
    NSError *error;
    NSArray *mathes = [context executeFetchRequest:request error:&error];
    
    if (!mathes || error || mathes.count > 1) {
        NSLog(@"matches %@ /n error %@", mathes, error);
    }else if (mathes.count){
        ingredient = mathes.firstObject;
    }else{
        ingredient = [NSEntityDescription insertNewObjectForEntityForName:@"Ingredient" inManagedObjectContext:context];
        ingredient.label = [ingredientDict valueForKey:@"label"];
        ingredient.quantity = [ingredientDict valueForKey:@"quantity"];
        ingredient.storagePer = [ingredientDict valueForKey:@"storagePer"];
        ingredient.fromFridge = fridge;
        [context save:NULL];
    }
    
    return ingredient;
}
@end
