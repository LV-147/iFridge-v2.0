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
@property (retain, nonatomic) IBOutlet GPPSignInButton *googlePlusSignInButton;
@property (strong, nonatomic) IBOutlet UIButton *facebookSignInButton;

- (IBAction)searchButton:(id)sender;
- (IBAction)signOutButton:(id)sender;
- (IBAction)getUserInformationButton:(id)sender;
- (IBAction)goToVkGroup:(id)sender;
- (IBAction)goToFacebookGroup:(id)sender;
- (IBAction)goToGooglePlusGroup:(id)sender;
- (IBAction)goToOurWebSite:(id)sender;
<<<<<<< HEAD
- (IBAction)emailUsButton:(id)sender;
=======
- (IBAction)writeAnEmailButton:(id)sender;
- (IBAction)googleButtton:(id)sender;
>>>>>>> 08ecd23b9da1d61cf3648fc291dfb732a0d47cc6



@end
