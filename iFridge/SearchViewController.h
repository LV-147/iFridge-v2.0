//
//  SearchViewController.h
//  iFridge
//
//  Created by Alexey Pelekh on 5/15/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//


#import "RecipesTVC.h"
#import <GooglePlus/GPPSignIn.h>

@class GPPSignInButton;


@interface SearchViewController : UIViewController <GPPSignInDelegate>

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;

- (IBAction)searchButton:(id)sender;

@end
