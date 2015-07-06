//
//  AddProductViewController.m
//  iFridge
//
//  Created by Pavlo Bardar on 6/17/15.
//  Copyright (c) 2015 Alexey Pelekh. All rights reserved.
//

#import "AddProductViewController.h"


@interface AddProductViewController () <UITextFieldDelegate, UIAlertViewDelegate>

@end

@implementation AddProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)cancel
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}



@end
