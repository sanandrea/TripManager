//
//  LoginViewController.h
//  Trip Manager
//
//  Created by Andi Palo on 22/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginDelegate <NSObject>

- (void) loginCompletedSuccesfully;

@end

@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *repeatTextField;

@property (weak, nonatomic) IBOutlet UIButton *goButton;
@property (weak, nonatomic) IBOutlet UISwitch *registerSwitch;
@property (weak, nonatomic) IBOutlet UILabel *errorMessage;


- (IBAction)goAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *registerInfo;
- (IBAction)switchAction:(id)sender;

@property (strong, nonatomic) id<LoginDelegate> delegate;

@end
