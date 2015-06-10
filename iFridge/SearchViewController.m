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
#import "RecipesTVC.h"
#import "DataDownloader.h"

static NSString * const kClientID = @"479226462698-nuoqkaoi6c79be4ghh4he3ov05bb1kpc.apps.googleusercontent.com";

@interface SearchViewController () <UINavigationControllerDelegate, UITextFieldDelegate>
@property (nonatomic, strong) NSString* googlePlusUserInfromation;
@property (nonatomic, strong) NSString* facebookUserInfromation;
@property (strong, nonatomic) IBOutlet UIButton *signOutButton;
@property (strong, nonatomic) IBOutlet UIButton *userInformationButton;
////SEARCH
//@property (nonatomic, strong) UISearchController *searchController;
//// our secondary search results table view
//@property (nonatomic, strong) RecipesTVC *resultsController;
////SEARCH

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshInterfaceBasedOnSignIn];
    self.navigationController.delegate = self;
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    self.navigationController.navigationBar.tintColor = [UIColor redColor];
    self.navigationController.view.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"image.jpg"]];
    self.view.backgroundColor = [UIColor clearColor];
    self.searchTextField.delegate = self;
    UIImage *buttonImageForGooglePlusSignInButton = [UIImage imageNamed:@"gplus-128.png"];
    UIImage *buttonImageForGooglePlusSignInButtonWhenPressed = [UIImage imageNamed:@"gplus-120.png"];
    [self.googlePlusSignInButton setImage:buttonImageForGooglePlusSignInButton forState:UIControlStateNormal];
    [self.googlePlusSignInButton setImage:buttonImageForGooglePlusSignInButtonWhenPressed forState:UIControlStateHighlighted];

    [self.view addSubview:self.googlePlusSignInButton];
    
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
    
//    //SEARCH
////    self.resultsController = [[RecipesTVC  alloc] init];
//    self.searchTextField.delegate = self;
//    UIStoryboard *s = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    self.resultsController = [s instantiateViewControllerWithIdentifier:@"RecipesTVC"];
//    
//    self.resultsController.dataSource = @"Search results";
//    self.searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultsController];
//    self.searchController.searchResultsUpdater = self;
//    //config view of search bar
//    self.searchController.searchBar.delegate = self;
//    self.searchController.searchBar.tintColor = [UIColor redColor];
//    self.searchController.searchBar.barTintColor = [UIColor colorWithRed:1 green:0.6 blue:0.6 alpha:0.5];
//    [self.searchController.searchBar sizeToFit];
////    self.searchController.searchBar.frame = CGRectMake(220, 40, 100,44);
////    [self.view addSubview:self.searchController.searchBar];
//    
//    // we want to be the delegate for our filtered table so didSelectRowAtIndexPath is called for both tables
//    self.searchController.delegate = self;
//    self.searchController.dimsBackgroundDuringPresentation = YES; // default is YES
//    
//    // Search is now just presenting a view controller. As such, normal view controller
//    // presentation semantics apply. Namely that presentation will walk up the view controller
//    // hierarchy until it finds the root view controller or one that defines a presentation context.
//    //
//    self.definesPresentationContext = YES;  // know where you want UISearchController to be displayed
//    //SEARCH
    
}

//#pragma mark - search bar delegate
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    DataDownloader *downloadManager = [[DataDownloader alloc]init];
//    [downloadManager downloadRecipesForQuery:self.searchController.searchBar.text
//                      withCompletionHandler:^(NSArray *filteredRecipes) {
//                          self.resultsController.recipes = filteredRecipes;
//                          [self.resultsController.tableView reloadData];
//                      }];
//}
//#pragma mark - UISearchResultsUpdating
//
//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
//{
//    
//}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self performSegueWithIdentifier:@"SegueToRecipesTVC" sender:nil];
    return YES;
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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)disconnect {
    [[GPPSignIn sharedInstance] disconnect];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshInterfaceBasedOnSignIn];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self refreshInterfaceBasedOnSignIn];
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self refreshInterfaceBasedOnSignIn];
}

-(void) viewWillDissapear:(BOOL)animated {
    [self refreshInterfaceBasedOnSignIn];
}


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

        NSString *googleUserInformation = [NSString stringWithFormat:@"User name: %@\r User e-mail: %@\r User id: %@\r", userName, [GPPSignIn sharedInstance].userEmail, [GPPSignIn sharedInstance].userID];

                UIAlertView *userInfo = [[UIAlertView alloc] initWithTitle:@"Current user information" message:googleUserInformation delegate:self cancelButtonTitle:@"Ok!" otherButtonTitles:nil];
        
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

- (IBAction)emailUsButton:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:info@ifridge.tk"]]];
}

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
    if ([segue.identifier isEqualToString:@"SegueToRecipesTVC"]){
        RecipesTVC *newController = segue.destinationViewController;
        newController.query = [self.searchTextField.text stringByReplacingOccurrencesOfString: @" " withString:@"+"];
        newController.dataSource = @"Search results";
    }
    if ([segue.identifier isEqualToString:@"SegueToMyRecipes"]){
        RecipesTVC *newController = segue.destinationViewController;
        newController.dataSource = @"My recipes";
        
    }
}


@end