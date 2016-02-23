//
//  LoginViewController.m
//  Trip Manager
//
//  Created by Andi Palo on 22/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import "LoginViewController.h"
#import "APConstants.h"
#import "UICKeyChainStore.h"
#import "Customer.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.registerInfo.text = NSLocalizedString(@"New user", @"New user label");
    [self.registerSwitch setOn:false];
    [self switchAction:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)goAction:(id)sender {
    CustomerRepository *crepo = (CustomerRepository*)[[APConstants sharedInstance] getCustomerRepository];
#warning TODO
    NSString *username = @"andi";
    NSString *password = @"test";
    Customer *customer = (Customer*)[crepo createUserWithUserName:username password:password];
    if (![self.registerSwitch isOn]) {
        [crepo userByLoginWithUserName:username password:password success:^(LBUser *user) {
            ALog("Here %@", user);
            [customer findRole];
            [self.delegate loginCompletedSuccesfully];
        } failure:CALLBACK_FAILURE_BLOCK];
    }else{
        [customer saveWithSuccess:^{
            [crepo userByLoginWithUserName:username password:password success:^(LBUser *user) {
                ALog("Here %@", user);
                [self.delegate loginCompletedSuccesfully];
            } failure:CALLBACK_FAILURE_BLOCK];
        } failure:CALLBACK_FAILURE_BLOCK];
    }
}
- (IBAction)switchAction:(id)sender {
    if (self.registerSwitch.isOn) {
        [self.goButton setTitle:@"Register" forState:UIControlStateNormal];
    }else{
        [self.goButton setTitle:@"Login" forState:UIControlStateNormal];
    }
}
@end
