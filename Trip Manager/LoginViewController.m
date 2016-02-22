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
#import "CustomerRepository.h"

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
    
    [crepo invokeStaticMethod:@"" parameters:@{@"username" : @"andi", @"password" : @"test"}
                      success:^(id data){
                          NSLog(@"We received: %@", data);
                          [self.delegate loginCompletedSuccesfully];
                          }
                      failure:^(NSError *error){
                          NSLog(@"We got error %@", error);
    }];
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
