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
<<<<<<< HEAD
=======
<<<<<<< HEAD
=======
>>>>>>> 19cc4b354bb2e0b81fce5fd3619da3a2af31a787
#import <GoogleOpenSource/GTLQueryPlus.h>
#import <GooglePlus/GPPSignIn.h>
#import <GooglePlus/GPPURLHandler.h>
#import <FacebookSDK/FacebookSDK.h>
<<<<<<< HEAD
=======
>>>>>>> Taras_Hates_GitHub_branch
>>>>>>> 19cc4b354bb2e0b81fce5fd3619da3a2af31a787
#import "PushAnimator.h"
#import "PopAnimator.h"

static NSString * const kClientID = @"479226462698-nuoqkaoi6c79be4ghh4he3ov05bb1kpc.apps.googleusercontent.com";

@interface SearchViewController () <UINavigationControllerDelegate>
<<<<<<< HEAD
@property (nonatomic, strong) NSString* googlePlusUserInfromation;
@property (nonatomic, strong) NSString* facebookUserInfromation;
@property (strong, nonatomic) IBOutlet UIButton *signOutButton;
@property (strong, nonatomic) IBOutlet UIButton *userInformationButton;
=======
>>>>>>> 19cc4b354bb2e0b81fce5fd3619da3a2af31a787

@end

@implementation SearchViewController



- (void)viewDidLoad {
    [super viewDidLoad];
<<<<<<< HEAD
=======
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn = [GPPSignIn sharedInstance];
    signIn.clientID= kClientID;
    signIn.scopes= [NSArray arrayWithObjects:kGTLAuthScopePlusLogin, nil];
    signIn.shouldFetchGoogleUserID=YES;
    signIn.shouldFetchGoogleUserEmail=YES;
    signIn.shouldFetchGooglePlusUser=YES;
    signIn.delegate=self;
    
    self.navigationController.delegate = self;
    self.navigationController.view.backgroundColor =
    [UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
>>>>>>> 19cc4b354bb2e0b81fce5fd3619da3a2af31a787
    
    [self refreshInterfaceBasedOnSignIn];
    self.navigationController.delegate = self;
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.navigationController.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    self.view.backgroundColor = [UIColor clearColor];
<<<<<<< HEAD
    
    UIImage *buttonImageForGooglePlusSignInButton = [UIImage imageNamed:@"gplus-128.png"];
    [self.googlePlusSignInButton setImage:buttonImageForGooglePlusSignInButton forState:UIControlStateNormal];
    [self.googlePlusSignInButton setBackgroundImage:buttonImageForGooglePlusSignInButton forState:UIControlStateNormal];
    [self.view addSubview:self.googlePlusSignInButton];
=======
    self.navigationController.delegate = self;
>>>>>>> 19cc4b354bb2e0b81fce5fd3619da3a2af31a787
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn = [GPPSignIn sharedInstance];
    signIn.clientID= kClientID;
    signIn.scopes= [NSArray arrayWithObjects:kGTLAuthScopePlusLogin, nil];
    signIn.shouldFetchGoogleUserID=YES;
    signIn.shouldFetchGoogleUserEmail=YES;
    signIn.shouldFetchGooglePlusUser=YES;
    signIn.delegate=self;
    [signIn trySilentAuthentication];

    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
<<<<<<< HEAD
    
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    if (operation == UINavigationControllerOperationPush)
        return [[PushAnimator alloc] init];
    
    if (operation == UINavigationControllerOperationPop)
        return [[PopAnimator alloc] init];
    
    return nil;
}

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error
{
    self.googlePlusUserInfromation = (NSString *)([GPPSignIn sharedInstance].googlePlusUser);
    NSLog(@"user %@", self.googlePlusUserInfromation);
    
    [self refreshInterfaceBasedOnSignIn];
    
    }

- (BOOL)isSessionOpen
{
    if( (FBSession.activeSession.state == FBSessionStateOpen) || (FBSession.activeSession.state == FBSessionStateOpenTokenExtended) || (FBSession.activeSession.isOpen == YES) )
        return YES;
    else return NO;
=======
    loginButton.frame = CGRectMake(34, 611, 306, 46);

    [self.view addSubview:loginButton];
    [signIn trySilentAuthentication];
}

- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error
{
    
    NSLog(@"Received Access Token:%@",auth);
    NSLog(@"user google user email  %@",[GPPSignIn sharedInstance].userEmail); //logged in user's email id
    NSLog(@"user google user id  %@",[GPPSignIn sharedInstance].userID);
    NSLog(@"user %@", [GPPSignIn sharedInstance].googlePlusUser);
    
    
    
>>>>>>> 19cc4b354bb2e0b81fce5fd3619da3a2af31a787
}

//-(void)finishedWithAuth:(GTMOAuth2Authentication *)auth error:(NSError *)error{
//    
//    NSLog(@"Received Error %@  and auth object==%@",error,auth);
//    
//    if (error) {
//        // Do some error handling here.
//    } else {
//        [self refreshInterfaceBasedOnSignIn];
//        
//        NSLog(@"email %@ ",[NSString stringWithFormat:@"Email: %@", [[GPPSignIn sharedInstance].authentication].userEmail]);
//        NSLog(@"Received error %@ and auth object %@",error, auth);
//        
//        // 1. Create a |GTLServicePlus| instance to send a request to Google+.
//        GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
//        plusService.retryEnabled = YES;
//        
//        // 2. Set a valid |GTMOAuth2Authentication| object as the authorizer.
//        [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
//        
//        
//        GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
//        
//        // *4. Use the "v1" version of the Google+ API.*
//        plusService.apiVersion = @"v1";
//        
//        [plusService executeQuery:query
//                completionHandler:^(GTLServiceTicket *ticket,
//                                    GTLPlusPerson *person,
//                                    NSError *error) {
//                    if (error) {
//                        
//                        
//                        
//                        //Handle Error
//                        
//                    } else
//                    {
//                        
//                        
//                        NSLog(@"Email= %@",[GPPSignIn sharedInstance].authentication.userEmail);
//                        NSLog(@"GoogleID=%@",person.identifier);
//                        NSLog(@"User Name=%@",[person.name.givenName stringByAppendingFormat:@" %@",person.name.familyName]);
//                        NSLog(@"Gender=%@",person.gender);
//                        
//                    }
//                }];
//    }
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
<<<<<<< HEAD
=======
//
//- (void)signOut {
//    [[GPPSignIn sharedInstance] signOut];
//}
>>>>>>> 19cc4b354bb2e0b81fce5fd3619da3a2af31a787

- (void)disconnect {
    [[GPPSignIn sharedInstance] disconnect];
}

-(void) viewWillAppear:(BOOL)animated {
    [self refreshInterfaceBasedOnSignIn];
}

<<<<<<< HEAD
-(void) viewDidAppear:(BOOL)animated{
    [self refreshInterfaceBasedOnSignIn];
}

-(void) viewDidDisappear:(BOOL)animated{
    [self refreshInterfaceBasedOnSignIn];
}

-(void) viewWillDissapear:(BOOL)animated {
    [self refreshInterfaceBasedOnSignIn];
}


- (IBAction)searchButton:(id)sender {
=======


- (IBAction)searchButton:(id)sender {
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"me?fields=id,name"
                                  parameters:nil
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result1,
                                          NSError *error) {
        
        
        NSLog(@"id,name: %@", result1);
    }];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                      id result, NSError *error) {
             if (!error) {
                 NSLog(@"fetched user:%@", result);
                  NSLog(@"email:%@", [result objectForKey:@"email"]);
             }
         }];
    }
>>>>>>> 19cc4b354bb2e0b81fce5fd3619da3a2af31a787
    
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

- (IBAction)signOutButton:(id)sender {
<<<<<<< HEAD
    
    
    if ([[GPPSignIn sharedInstance] authentication] || [self isSessionOpen]) {
        [[GPPSignIn sharedInstance] signOut];
        [[GPPSignIn sharedInstance] disconnect];
        self.googlePlusSignInButton.hidden = NO;
        self.facebookSignInButton.hidden = NO;
        //self.signOutButton.hidden = YES;
        // Perform other actions here, such as showing a sign-out button
    }
    
    self.facebookSignInButton.hidden = NO;
=======
    [[GPPSignIn sharedInstance] signOut];
    [[GPPSignIn sharedInstance] disconnect];
    
>>>>>>> 19cc4b354bb2e0b81fce5fd3619da3a2af31a787
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

<<<<<<< HEAD
- (IBAction)getUserInformationButton:(id)sender {
    
    UIAlertView *userNotLoggedIn = [[UIAlertView alloc] initWithTitle:@"You are not currently logged in" message:@"Try to log in first!" delegate:self cancelButtonTitle:@"Ok!" otherButtonTitles:nil];
    
    if([[GPPSignIn sharedInstance] authentication]){
        
    
      //  NSString * str = [dict displayName];
      //  NSLog(@"%@", (NSString*)((GTLPlusPerson*)dict[@"displayName"]);
        
      //  self.googlePlusUserInfromation
        
     
        NSString *strForJson = [NSString stringWithFormat:@"%@",[GPPSignIn sharedInstance].googlePlusUser];
        
        NSError *error = nil;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"displayName:\".+\"" options:NSRegularExpressionCaseInsensitive error:&error];

        NSRange stringRange = NSMakeRange(0, strForJson.length);

        NSArray *matches = [regex matchesInString:strForJson options:NSMatchingProgress range:stringRange];
        NSRange matchRange = [matches[0] rangeAtIndex:0];

        NSArray *testArray2 = [[strForJson substringWithRange:matchRange] componentsSeparatedByString:@"\""];
        NSString *userName = testArray2[1];

        NSLog(@"g+ %@", userName);

        //        UIAlertView *userInfo = [[UIAlertView alloc] initWithTitle:@"Current user information" message:self.googlePlusUserInfromation delegate:self cancelButtonTitle:@"Ok!" otherButtonTitles:nil];
        //
        //        [userInfo show];
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
=======
>>>>>>> 19cc4b354bb2e0b81fce5fd3619da3a2af31a787

-(void)refreshInterfaceBasedOnSignIn
{
    
    
    if ([[GPPSignIn sharedInstance] authentication] || [self isSessionOpen]) {
        // Пользователь вошел.
        self.googlePlusSignInButton.hidden = YES;
        self.facebookSignInButton.hidden = YES;
         //self.signOutButton.hidden = NO;
        // Прочие действия, например отображение кнопки выхода
    } else {
        //self.signOutButton.hidden = YES;
        self.googlePlusSignInButton.hidden = NO;
         self.facebookSignInButton.hidden = NO;
        // Прочие действия
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
<<<<<<< HEAD
    if ([segue.identifier isEqualToString:@"SegueToRecipesTVC"]){
        RecipesTVC *newController = segue.destinationViewController;
        newController.query = [self.searchTextField.text stringByReplacingOccurrencesOfString: @" " withString:@"+"];
        newController.dataSource = @"Search results";
    }
    if ([segue.identifier isEqualToString:@"SegueToMyRecipes"]){
        RecipesTVC *newController = segue.destinationViewController;
        newController.dataSource = @"My recipes";
        
=======
    RecipesTVC *newController = segue.destinationViewController;
<<<<<<< HEAD
    
    if ([segue.identifier isEqualToString:@"SegueToRecipesTVC"]){
        newController.query = [self.searchTextField.text stringByReplacingOccurrencesOfString: @" " withString:@"+"];
        newController.dataSource = @"Search results";
    }else{
        newController.dataSource = @"My recipes";
>>>>>>> 19cc4b354bb2e0b81fce5fd3619da3a2af31a787
    }
=======
    newController.query = [self.searchTextField.text stringByReplacingOccurrencesOfString: @" " withString:@"+"];
    
    ([segue.identifier isEqualToString:@"SegueToRecipesTVC"])? (newController.dataSource = @"Search results") : (newController.dataSource = @"My recipes");
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    if (operation == UINavigationControllerOperationPush)
        return [[PushAnimator alloc] init];
    
    if (operation == UINavigationControllerOperationPop)
        return [[PopAnimator alloc] init];
    
    return nil;
>>>>>>> Taras_Hates_GitHub_branch
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController*)fromVC
                                                 toViewController:(UIViewController*)toVC
{
    if (operation == UINavigationControllerOperationPush)
        return [[PushAnimator alloc] init];
    
    if (operation == UINavigationControllerOperationPop)
        return [[PopAnimator alloc] init];
    
    return nil;
}


@end