//
//  SearchViewController.h
//  iFridge
//
//  Created by Alexey Pelekh on 5/15/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import <GooglePlus/GPPSignIn.h>

@class GPPSignInButton;

@interface SearchViewController : UIViewController <GPPSignInDelegate>

@property(strong, nonatomic) IBOutlet UITextField *searchTextField;
@property(retain, nonatomic) IBOutlet GPPSignInButton *googlePlusSignInButton;
@property(strong, nonatomic) IBOutlet UIButton *facebookSignInButton;

@property(strong, nonatomic) NSString *userEmail;
@property(strong, nonatomic) NSString *userId;
@property(strong, nonatomic) NSString *userName;
@property(strong, nonatomic) NSString *userSocialNetwork;

- (IBAction)searchButton:(id)sender;
- (IBAction)signOutButton:(id)sender;
- (IBAction)getUserInformationButton:(id)sender;
- (IBAction)goToVkGroup:(id)sender;
- (IBAction)goToFacebookGroup:(id)sender;
- (IBAction)goToGooglePlusGroup:(id)sender;
- (IBAction)goToOurWebSite:(id)sender;
- (IBAction)emailUsButton:(id)sender;
// fucking changes

@end
