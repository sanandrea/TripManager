//
//  LoginViewController.m
//  Trip Manager
//
//  Created by Andi Palo on 22/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import "LoginViewController.h"

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goAction:(id)sender {
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
