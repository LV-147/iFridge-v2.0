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
>>>>>>> b8563adc2d5babcbdf973b81b0746a3fb1d9df67

@property (strong, nonatomic) IBOutlet UITextField *searchTextField;
@property (retain, nonatomic) IBOutlet GPPSignInButton *signInButton;

- (IBAction)searchButton:(id)sender;
<<<<<<< HEAD
- (IBAction)signOutButton:(id)sender;
- (IBAction)getUserInformationButton:(id)sender;
- (IBAction)goToVkGroup:(id)sender;
- (IBAction)goToFacebookGroup:(id)sender;
- (IBAction)goToGooglePlusGroup:(id)sender;
- (IBAction)goToOurWebSite:(id)sender;
- (IBAction)writeAnEmailButton:(id)sender;
- (IBAction)googleButtton:(id)sender;


=======
>>>>>>> b8563adc2d5babcbdf973b81b0746a3fb1d9df67

@end
