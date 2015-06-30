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

+ (Fridge *)addFridgeWithName:(NSString *)fridgeName
       inManagedObjectContext:(NSManagedObjectContext *)context{
    
    Fridge *fridge = nil;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Fridge"];
    request.predicate = [NSPredicate predicateWithFormat:@"name = %@", fridgeName];
    
    NSError *error;
    NSArray *mathes = [context executeFetchRequest:request error:&error];
    
    if (!mathes || error || mathes.count > 1) {
        NSLog(@"matches %@ /n error %@", mathes, error);
    }else if (mathes.count){
        fridge = mathes.firstObject;
    }else{
        fridge = [NSEntityDescription insertNewObjectForEntityForName:@"Fridge" inManagedObjectContext:context];
        fridge.name = fridgeName;
        [context save:NULL];
    }
    return fridge;
}
@end
