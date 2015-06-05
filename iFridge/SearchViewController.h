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

<<<<<<< HEAD

@interface SearchViewController : UIViewController <GPPSignInDelegate, UITextFieldDelegate>
=======
@interface SearchViewController : UIViewController <GPPSignInDelegate>
>>>>>>> fb2a596d08adff39858c46a8aae7f5a006f90f05

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (retain, nonatomic) IBOutlet GPPSignInButton *googlePlusSignInButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookSignInButton;

- (IBAction)searchButton:(id)sender;
- (IBAction)signOutButton:(id)sender;
- (IBAction)getUserInformationButton:(id)sender;
- (IBAction)goToVkGroup:(id)sender;
- (IBAction)goToFacebookGroup:(id)sender;
- (IBAction)goToGooglePlusGroup:(id)sender;
- (IBAction)goToOurWebSite:(id)sender;
- (IBAction)emailUsButton:(id)sender;



@end
