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
@property (nonatomic) NSInteger moveOffset;
@property (nonatomic) BOOL userTapped;

@property (strong, nonatomic) UITextField *activeField;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.registerSwitch setOn:false];

    if (self.isManager) {
        self.title = @"Create";
        [self.goButton setTitle:@"Create user" forState:UIControlStateNormal];
        self.registerInfo.text = NSLocalizedString(@"Add user", nil);
        [self.registerSwitch setOn:true];
        self.registerSwitch.hidden = YES;
    }else{
        self.registerInfo.text = NSLocalizedString(@"New user", @"New user label");
        
        [self switchAction:self];
    }
    
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    
    self.userNameTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.repeatTextField.delegate = self;
    
    
    [self.userNameTextField addTarget:self
                               action:@selector(dummy)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passwordTextField addTarget:self
                               action:@selector(dummy)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.repeatTextField addTarget:self
                               action:@selector(dummy)
                     forControlEvents:UIControlEventEditingDidEndOnExit];
}

-(void)dummy{}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated {
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    [super viewWillDisappear:animated];
}


- (void) dismissKeyboard
{
    self.userTapped = YES;
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.repeatTextField resignFirstResponder];
}
#pragma mark - text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _activeField = textField;
    self.userTapped = NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.userNameTextField) {

        [textField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
        
    }else if (textField == self.passwordTextField){
        [textField resignFirstResponder];
        if ([self.registerSwitch isOn]) {
            [self.repeatTextField becomeFirstResponder];
        }else{
            [self goAction:self];
        }
    }else if (textField == self.repeatTextField){
        [textField resignFirstResponder];
        [self goAction:self];
    }
    textField.layer.borderColor = [[UIColor clearColor] CGColor];
    
    return NO;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
}

#pragma mark - Keayboard Management
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
    
}


-(void)keyboardWillShow:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, _activeField.frame.origin) ) {
        self.moveOffset = fabs(aRect.size.height - _activeField.frame.origin.y - _activeField.frame.size.height);
        [self setViewMovedUp:YES];
    }
    
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
    }
    else if (self.view.frame.origin.y < 0)
    {
        //        [self setViewMovedUp:NO];
    }
    
}

-(void)keyboardWillHide:(NSNotification*)aNotification {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= self.moveOffset;
        rect.size.height += self.moveOffset;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += self.moveOffset;
        rect.size.height -= self.moveOffset;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
    if (!movedUp) {
        self.moveOffset = 0;
    }
}

#pragma mark - IB Actions

- (IBAction)goAction:(id)sender {
    //some checks
    if ([self.userNameTextField.text length] == 0) {
        self.userNameTextField.layer.borderColor = [[UIColor redColor] CGColor];
        self.userNameTextField.layer.borderWidth = 3.0;
        
        [self displayErrorWithMessage:@"Username required"];
        
        return;
    }
    if ([self.passwordTextField.text length] == 0) {
        self.passwordTextField.layer.borderColor = [[UIColor redColor] CGColor];
        self.passwordTextField.layer.borderWidth = 3.0;
        [self displayErrorWithMessage:@"Password required"];
        return;
    }
    if ([self.registerSwitch isOn] && [self.passwordTextField.text length] == 0) {
        self.repeatTextField.layer.borderColor = [[UIColor redColor] CGColor];
        self.repeatTextField.layer.borderWidth = 3.0;
        [self displayErrorWithMessage:@"Please repeat password"];
        return;
    }

    
    CustomerRepository *crepo = (CustomerRepository*)[[APConstants sharedInstance] getCustomerRepository];
    
#ifdef TEST_MODE
    NSString *username = @"admin";
    NSString *password = @"test";
#else
    NSString *username = self.userNameTextField.text;
    NSString *password = self.passwordTextField.text;
#endif

    Customer *customer = (Customer*)[crepo createUserWithUserName:username password:password];
    if (![self.registerSwitch isOn]) {
        [crepo userByLoginWithUserName:username password:password success:^(LBUser *user) {
            ALog("Here %@", user);
            [[APConstants sharedInstance] updateRoleWithUser:user on:^{
                [self.delegate loginCompletedSuccesfully];
            } when:CALLBACK_FAILURE_BLOCK];
        } failure:^(NSError *error){
            [self displayErrorWithMessage:[error localizedDescription]];
        }];
    }else{
        if (![self.passwordTextField.text isEqualToString:self.repeatTextField.text]) {
            [self displayErrorWithMessage:@"Passwords do not match"];
            return;
        }
        [customer saveWithSuccess:^{
            if (self.isManager) {
                [self performSegueWithIdentifier:@"unwindToUserController" sender:self];
                return;
            }
            [crepo userByLoginWithUserName:username password:password success:^(LBUser *user) {
                ALog("Here %@", user);
                [[APConstants sharedInstance] updateRoleWithUser:user on:^{
                    [self.delegate loginCompletedSuccesfully];
                } when:CALLBACK_FAILURE_BLOCK];
            } failure:CALLBACK_FAILURE_BLOCK];
        } failure:CALLBACK_FAILURE_BLOCK];
    }
}

- (void)displayErrorWithMessage:(NSString*)msg{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Login error"
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)switchAction:(id)sender {
    if (self.registerSwitch.isOn) {
        [self.goButton setTitle:@"Register" forState:UIControlStateNormal];
        self.passwordTextField.returnKeyType = UIReturnKeyNext;
        self.repeatTextField.hidden = NO;
    }else{
        self.passwordTextField.returnKeyType = UIReturnKeyDone;
        self.repeatTextField.hidden = YES;
        [self.goButton setTitle:@"Login" forState:UIControlStateNormal];
    }
    
    if ([self.passwordTextField isFirstResponder]) {
        [self.passwordTextField resignFirstResponder];
        [self.passwordTextField becomeFirstResponder];
    }
    if ([self.repeatTextField isFirstResponder]) {
        [self.repeatTextField resignFirstResponder];
    }

}
@end
