//
//  EditUserViewController.m
//  Trip Manager
//
//  Created by Andi Palo on 25/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import "EditUserViewController.h"

@implementation EditUserViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.usernameLabel.text = NSLocalizedString(@"Username", @"username label in edit view controller");
    self.roleLabel.text = NSLocalizedString(@"Role", @"user role label in edit view controller");
    
    UIBarButtonItem *myButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveUser:)];
    
    self.navigationItem.rightBarButtonItem = myButton;

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) saveUser:(id)sender{
    
}
- (IBAction)promoteAction:(id)sender {
}
@end
