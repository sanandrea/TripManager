//
//  Trip_ManagerUITests.m
//  Trip ManagerUITests
//
//  Created by Andi Palo on 22/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import <XCTest/XCTest.h>
static NSString *letters = @"abcdefghijklmnopqrstuvwxyz";

@interface LoginUITests : XCTestCase{
    XCUIApplication *app;
}

@end

@implementation LoginUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    app = [[XCUIApplication alloc] init];
    [app launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void) testRegisterUser{
    XCUIElement *navbar = [app.navigationBars elementBoundByIndex:0];
    
    if (![navbar.identifier isEqualToString:@"Master"]) {
        [app.toolbars.buttons[@"\uf08b"] tap];
    }
    
    [app.switches[@"0"] tap];
    
    XCUIElement *usernameTextField = app.textFields[@"Username"];
    [usernameTextField tap];
    [usernameTextField typeText:[LoginUITests randomUsername]];
    
    XCUIElement *nextButton = app.buttons[@"Next"];
    [nextButton tap];
    
    XCUIElement *passwordSecureTextField = app.secureTextFields[@"Password"];
    [passwordSecureTextField typeText:@"x"];
    [passwordSecureTextField typeText:@"\n"];
    
    XCUIElement *repeatPasswordSecureTextField = app.secureTextFields[@"Repeat password"];
    [repeatPasswordSecureTextField typeText:@"x"];
    [repeatPasswordSecureTextField typeText:@"\n"];
    XCTAssertTrue([navbar.identifier isEqualToString:@"Trips"]);
}

- (void) testLoginUser{
    XCUIElement *navbar = [app.navigationBars elementBoundByIndex:0];
    
    if (![navbar.identifier isEqualToString:@"Master"]) {
        [app.toolbars.buttons[@"\uf08b"] tap];
    }
    XCUIElement *usernameTextField = app.textFields[@"Username"];
    [usernameTextField tap];
    [usernameTextField typeText:@"andi"];
    
    XCUIElement *nextButton = app.buttons[@"Next"];
    [nextButton tap];
    
    XCUIElement *passwordSecureTextField = app.secureTextFields[@"Password"];
    [passwordSecureTextField typeText:@"test"];
    [passwordSecureTextField typeText:@"\n"];
    XCTAssertTrue(![navbar.identifier isEqualToString:@"Master"]);
}


+(NSString*) randomUsername{
    NSMutableString *randomString = [NSMutableString stringWithCapacity: 6];
    
    for (int i=0; i<6; i++) {
        u_int32_t r = arc4random() % [letters length];
        unichar c = [letters characterAtIndex:r];
        [randomString appendFormat:@"%C", c];
    }
    
    return randomString;
}
@end
