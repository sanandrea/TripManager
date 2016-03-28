// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// 
//
//  Copyright © 2016 Andi Palo
//  This file is part of project: TripManager
//
//
//  EditUserViewController.m
//  Trip Manager
//
//  Created by Andi Palo on 25/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import "EditUserViewController.h"
#import "RoleMapping.h"

@implementation EditUserViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.usernameLabel.text = NSLocalizedString(@"Username", @"username label in edit view controller");
    self.roleLabel.text = NSLocalizedString(@"Role", @"user role label in edit view controller");
    
    self.usernameValue.text = self.customer.username;
    self.promote.hidden = YES;
    [self.promote setTitle:NSLocalizedString(@"Promote", @"Promote button title") forState:UIControlStateNormal];
    
    [self updateRoleLabel];
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveUser:)];
    
    self.navigationItem.rightBarButtonItem = myButton;

    
}

- (void) updateRoleLabel{
    NSDictionary *filter = @{@"include":@"role",@"where":@{@"principalId":[self.customer valueForKey:@"id"]}};
    LBRESTAdapter *adapter = (LBRESTAdapter*)[[APConstants sharedInstance] adapter];
    RoleMappingRepository *repo=  (RoleMappingRepository*)[adapter repositoryWithClass:[RoleMappingRepository class]];
    
    [repo findWithFilter:filter success:^(NSArray *roleMappings){
        if ([roleMappings count] == 0) {
            self.roleValue.text = NSLocalizedString(@"Customer", @"customer role label");
            self.promote.hidden = NO;
            return;
        }
        RoleMapping *rm = [roleMappings objectAtIndex:0];
        self.roleValue.text = [rm[@"role"][@"name"] capitalizedString];
        
        if ([rm[@"role"][@"name"] isEqualToString:@"admin"]) {
            self.promote.hidden = YES;
            return;
        }
        self.promote.hidden = NO;
        
    }failure:CALLBACK_FAILURE_BLOCK];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) saveUser:(id)sender{
    self.customer.username = self.usernameValue.text;
    [self.customer saveWithSuccess:^(){
        [self.navigationController popViewControllerAnimated:YES];
    } failure:CALLBACK_FAILURE_BLOCK];
    
}
- (IBAction)promoteAction:(id)sender {
    
    CustomerRepository *crepo = (CustomerRepository*)[[APConstants sharedInstance] getCustomerRepository];

    NSDictionary *parameters = @{@"id" : self.customer[@"id"]};
    
    [crepo invokeStaticMethod:@"promote-user" parameters:parameters success:^(id value){
        [self updateRoleLabel];
    }failure:CALLBACK_FAILURE_BLOCK];
}
@end
