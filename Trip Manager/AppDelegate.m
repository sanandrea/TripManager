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
//  AppDelegate.m
//  Trip Manager
//
//  Created by Andi Palo on 22/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import "AppDelegate.h"
#import "TripDetailViewController.h"
#import "UICKeyChainStore.h"
#import "LoginViewController.h"
#import "Customer.h"

@interface AppDelegate () <UISplitViewControllerDelegate,LoginDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    LBRESTAdapter *adapter = [[APConstants sharedInstance] getCurrentAdapter];
    
    //Clear keychain on first run in case of reinstallation
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"FirstRun"]) {
        // Delete values from keychain here
        
        //Setup KeyChain Access to store token and username in order to be accessible application wide
        UICKeyChainStore *keychain = [UICKeyChainStore keyChainStoreWithService:kKeyChainServiceURL];
        [keychain removeItemForKey:kSecurityTokenKey];
        [keychain removeItemForKey:kSecurityUserNameKey];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"1strun" forKey:@"FirstRun"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *mainNavigation = [splitViewController.viewControllers firstObject];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    
    if (adapter.accessToken == nil) {
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        loginViewController.delegate = self;
        NSArray * newViewControllers = [NSArray arrayWithObjects:loginViewController,nil];
        [mainNavigation setViewControllers:newViewControllers];
    }else{
        //left Navigation View Controller
        UserRole role = [[[NSUserDefaults standardUserDefaults] objectForKey:kLastUserRole] intValue];
        UIViewController *nextViewController;
        if (role == kUserRoleAdmin || role == kUserRoleManager) {
            nextViewController = [storyboard instantiateViewControllerWithIdentifier:@"userViewController"];
        }else{
            nextViewController = [storyboard instantiateViewControllerWithIdentifier:@"tripViewController"];
        }
        NSArray * newViewControllers = [NSArray arrayWithObjects:nextViewController,nil];
        [mainNavigation setViewControllers:newViewControllers];
        
        //right Navigation View Controller
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    }
    
    splitViewController.delegate = self;
    return YES;
}

-(void) loginCompletedSuccesfully{
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    UINavigationController *mainNavigation = [splitViewController.viewControllers firstObject];
    UIViewController *nextViewController;
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //find logged in customer from repo
    UserRole role = ((APConstants*)[APConstants sharedInstance]).currentUserRole;
    if (role == kUserRoleAdmin || role == kUserRoleManager) {
        nextViewController = [storyboard instantiateViewControllerWithIdentifier:@"userViewController"];
    }else{
        nextViewController = [storyboard instantiateViewControllerWithIdentifier:@"tripViewController"];
    }
    /*
    [mainNavigation popViewControllerAnimated:YES];
    [mainNavigation pushViewController:nextViewController animated:YES];
    */
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray: mainNavigation.viewControllers];
    [allViewControllers removeObjectAtIndex:0];
    [allViewControllers addObject:nextViewController];
    [mainNavigation setViewControllers:allViewControllers animated:YES];
}

- (void) logoutUser{
    CustomerRepository *crepo = (CustomerRepository*)[[APConstants sharedInstance] getCustomerRepository];
    if (crepo.currentUserId == nil) {return;}
    
    [crepo logoutWithSuccess:^(){
        // Override point for customization after application launch.
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *mainNavigation = [splitViewController.viewControllers firstObject];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"loginViewController"];
        loginViewController.delegate = self;
        NSArray *modifiedArray = @[loginViewController];
        [mainNavigation setViewControllers:modifiedArray animated:YES];
    } failure:CALLBACK_FAILURE_BLOCK];

}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[TripDetailViewController class]] && ([(TripDetailViewController *)[(UINavigationController *)secondaryViewController topViewController] trip] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

@end
