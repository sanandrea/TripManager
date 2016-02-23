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
    [self switchAction:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)goAction:(id)sender {
    LBRESTAdapter *adapter = [[APConstants sharedInstance] getCurrentAdapter];
    CustomerRepository *crepo = (CustomerRepository*) [adapter repositoryWithClass:[CustomerRepository class]];
    
    NSString *username = [APConstants randomUsername];
    NSString *password = @"test";
    
    Customer __block *customer = (Customer*)[crepo createUserWithUserName:username password:password];
    
    [customer saveWithSuccess:^{
        [crepo userByLoginWithUserName:username password:password success:^(LBUser *user) {
            ALog("Here %@", user);
        } failure:CALLBACK_FAILURE_BLOCK];
    } failure:CALLBACK_FAILURE_BLOCK];

    
    
    
    [self.delegate loginCompletedSuccesfully];
}
- (IBAction)switchAction:(id)sender {
    if (self.registerSwitch.isOn) {
        [self.goButton setTitle:@"Register" forState:UIControlStateNormal];
    }else{
        [self.goButton setTitle:@"Login" forState:UIControlStateNormal];
    }
}
@end
