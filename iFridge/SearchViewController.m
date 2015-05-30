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
#import <GoogleOpenSource/GTLQueryPlus.h>
#import <GooglePlus/GPPSignIn.h>
#import <GooglePlus/GPPURLHandler.h>
#import <FacebookSDK/FacebookSDK.h>
#import "PushAnimator.h"
#import "PopAnimator.h"

static NSString * const kClientID = @"479226462698-nuoqkaoi6c79be4ghh4he3ov05bb1kpc.apps.googleusercontent.com";

@interface SearchViewController () <UINavigationControllerDelegate>

@end

@implementation SearchViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn = [GPPSignIn sharedInstance];
    signIn.clientID= kClientID;
    signIn.scopes= [NSArray arrayWithObjects:kGTLAuthScopePlusLogin, nil];
    signIn.shouldFetchGoogleUserID=YES;
    signIn.shouldFetchGoogleUserEmail=YES;
    signIn.shouldFetchGooglePlusUser=YES;
    signIn.delegate=self;
    
    self.navigationController.view.backgroundColor =
    [UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.delegate = self;
    
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
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
//
//- (void)signOut {
//    [[GPPSignIn sharedInstance] signOut];
//}

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
    [[GPPSignIn sharedInstance] signOut];
    [[GPPSignIn sharedInstance] disconnect];
    
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
    RecipesTVC *newController = segue.destinationViewController;
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
}

@end