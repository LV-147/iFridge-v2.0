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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


// - (void)setImageProduct:(UIImage *)image
//{
//    self.imageOfProduct.image = image;
//}
//- (UIImage *)image
//{
//    return self.imageOfProduct.image;
//}

- (IBAction)cancel
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}



@end
