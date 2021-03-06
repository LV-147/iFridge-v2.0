//
//  KeychainWrapper.h
//  iFridge
//
//  Created by apple on 02.07.15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeychainWrapper : NSObject

- (void)mySetObject:(id)inObject forKey:(id)key;
- (id)myObjectForKey:(id)key;
- (void)writeToKeychain;

@end