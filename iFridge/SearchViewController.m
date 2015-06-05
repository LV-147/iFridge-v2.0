//
//  SearchViewController.m
//  iFridge
//
//  Created by Alexey Pelekh on 5/15/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import "SearchViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleOpenSource/GTLPlusConstants.h>
#import <GooglePlus/GPPSignInButton.h>


static NSString * const kClientID = @"479226462698-nuoqkaoi6c79be4ghh4he3ov05bb1kpc.apps.googleusercontent.com";

<<<<<<< HEAD
@interface SearchViewController () <UINavigationControllerDelegate, UISearchBarDelegate>
@property (nonatomic, strong) NSString* googlePlusUserInfromation;
@property (nonatomic, strong) NSString* facebookUserInfromation;
@property (strong, nonatomic) IBOutlet UIButton *signOutButton;
@property (strong, nonatomic) IBOutlet UIButton *userInformationButton;
=======


@interface SearchViewController ()
>>>>>>> b8563adc2d5babcbdf973b81b0746a3fb1d9df67

@end

@implementation SearchViewController

@synthesize signInButton;

- (void)viewDidLoad {
    [super viewDidLoad];
<<<<<<< HEAD
    [self refreshInterfaceBasedOnSignIn];
    self.navigationController.delegate = self;
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.navigationController.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    self.view.backgroundColor = [UIColor clearColor];
    
    UIImage *buttonImageForGooglePlusSignInButton = [UIImage imageNamed:@"gplus-128.png"];
    [self.googlePlusSignInButton setImage:buttonImageForGooglePlusSignInButton forState:UIControlStateNormal];
    [self.googlePlusSignInButton setBackgroundImage:buttonImageForGooglePlusSignInButton forState:UIControlStateNormal];
    [self.view addSubview:self.googlePlusSignInButton];
    
=======
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
>>>>>>> b8563adc2d5babcbdf973b81b0746a3fb1d9df67
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    
    self.navigationController.view.backgroundColor =
    [UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    signIn.clientID = kClientID;
    signIn.scopes = [NSArray arrayWithObjects:
                     kGTLAuthScopePlusLogin,nil];
    signIn.delegate = self;
    
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.frame = CGRectMake(34, 611, 306, 46);
    
    [self.view addSubview:loginButton];
    [signIn trySilentAuthentication];
    //[signIn signOut];
}



- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error
{
    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error) {
        // Обработка ошибок
    } else {
        [self refreshInterfaceBasedOnSignIn];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)signOut {
    [[GPPSignIn sharedInstance] signOut];
}

<<<<<<< HEAD
=======
- (void)disconnect {
    [[GPPSignIn sharedInstance] disconnect];
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        NSLog(@"Received error %@", error);
    } else {
        // Пользователь вышел и отключился.
        // Удалим данные пользователя в соответствии с Условиями использования Google+.
    }
}

>>>>>>> b8563adc2d5babcbdf973b81b0746a3fb1d9df67
- (IBAction)searchButton:(id)sender {
    UIAlertView *noText = [[UIAlertView alloc] initWithTitle:@"Table is empty because of empty request!" message:@"Please, enter some text in Search field!" delegate:self cancelButtonTitle:@"Ok!" otherButtonTitles:nil];
    
    if([self.searchTextField.text  isEqual: @""]) [noText show];
    
    UIAlertView *numericText = [[UIAlertView alloc] initWithTitle:@"Incorrect input!" message:@"Don't mind you're gonna to eat digits!" delegate:self cancelButtonTitle:@"Ok!" otherButtonTitles:nil];
    BOOL valid;
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:self.searchTextField.text];
    valid = [alphaNums isSupersetOfSet:inStringSet];
    NSUInteger length= [self.searchTextField.text length];
    if (valid) // Not numeric and more than 2 symbols
    {
        if(length > 2)
            [numericText show];
        
    }
    
}

<<<<<<< HEAD
- (IBAction)signOutButton:(id)sender {
    
    if ([[GPPSignIn sharedInstance] authentication] || [self isSessionOpen]) {
        [[GPPSignIn sharedInstance] signOut];
        [[GPPSignIn sharedInstance] disconnect];
        self.googlePlusSignInButton.hidden = NO;
        self.facebookSignInButton.hidden = NO;
        //self.signOutButton.hidden = YES;
        // Perform other actions here, such as showing a sign-out button
    }
    
    self.facebookSignInButton.hidden = NO;
    [[FBSDKLoginManager new] logOut];
    [FBSession.activeSession closeAndClearTokenInformation];
    [FBSession.activeSession close];
    [FBSession setActiveSession:nil];
    
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }
    
}

- (IBAction)getUserInformationButton:(id)sender {
    
    UIAlertView *userNotLoggedIn = [[UIAlertView alloc] initWithTitle:@"You are not currently logged in" message:@"Try to log in first!" delegate:self cancelButtonTitle:@"Ok!" otherButtonTitles:nil];
    
    if([[GPPSignIn sharedInstance] authentication]){
        NSString *strForJson = [NSString stringWithFormat:@"%@",[GPPSignIn sharedInstance].googlePlusUser];
        
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"displayName:\".+\"" options:NSRegularExpressionCaseInsensitive error:&error];
        
        NSRange stringRange = NSMakeRange(0, strForJson.length);
        
        NSArray *matches = [regex matchesInString:strForJson options:NSMatchingProgress range:stringRange];
        NSRange matchRange = [matches[0] rangeAtIndex:0];
        
        NSArray *testArray2 = [[strForJson substringWithRange:matchRange] componentsSeparatedByString:@"\""];
        NSString *userName = testArray2[1];
        
        NSString *googlePlusUserInfoString = [NSString stringWithFormat:@"User Name: %@\r User Email: %@\r  User ID: %@\r", userName, [GPPSignIn sharedInstance].userEmail, [GPPSignIn sharedInstance].userID];
        
        UIAlertView *userInfo = [[UIAlertView alloc] initWithTitle:@"Current user information" message:googlePlusUserInfoString delegate:self cancelButtonTitle:@"Ok!" otherButtonTitles:nil];
        
        [userInfo show];
    }else if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                      id result, NSError *error) {
             if (!error) {
                 self.facebookUserInfromation = [NSString stringWithFormat:@"%@", result];
                 UIAlertView *userInfo = [[UIAlertView alloc] initWithTitle:@"Current user information" message:self.facebookUserInfromation delegate:self cancelButtonTitle:@"Ok!" otherButtonTitles:nil];
                 [userInfo show];
             }
         }];
        
    }else [userNotLoggedIn show];
  
}

- (IBAction)goToVkGroup:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://vk.com/club95312343"]];
}

- (IBAction)goToFacebookGroup:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/groups/1599931206891002/"]];
}

- (IBAction)goToGooglePlusGroup:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://plus.google.com/u/0/communities/115640961445564991070"]];
}

- (IBAction)goToOurWebSite:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.ifridge.tk/"]];
}

- (IBAction)writeAnEmailButton:(id)sender {
    
}

- (IBAction)googleButtton:(id)sender {
    self.googlePlusSignInButton.hidden = YES;
}
=======
>>>>>>> b8563adc2d5babcbdf973b81b0746a3fb1d9df67

-(void)refreshInterfaceBasedOnSignIn
{
    if ([[GPPSignIn sharedInstance] authentication]) {
        // Пользователь вошел.
        self.signInButton.hidden = YES;
        // Прочие действия, например отображение кнопки выхода
    } else {
        self.signInButton.hidden = NO;
        // Прочие действия
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{

    if ([segue.identifier isEqualToString:@"SegueToRecipesTVC"]){
       
        RecipesTVC *newController = segue.destinationViewController;
        newController.query = [self.searchTextField.text stringByReplacingOccurrencesOfString: @" " withString:@"+"];
        newController.dataSource = @"Search results";
    }
    if ([segue.identifier isEqualToString:@"SegueToMyRecipes"]){
        RecipesTVC *newController = segue.destinationViewController;
        newController.query = [self.searchTextField.text stringByReplacingOccurrencesOfString: @" " withString:@"+"];
        newController.dataSource = @"My recipes";
        newController.selectDataSourceButton.selectedSegmentIndex = 1;
    }
}

@end