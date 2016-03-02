//
//  User.m
//  Trip Manager
//
//  Created by Andi Palo on 03/03/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface UserUITests : XCTestCase{
    XCUIApplication *app;
}


@end

@implementation UserUITests

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

- (void)testShowUserList {
    XCUIElement *navbar = [app.navigationBars elementBoundByIndex:0];
    [self goToUsersView:navbar];
    XCTAssertTrue([navbar.identifier isEqualToString:@"Users"]);
}

- (void) goToUsersView:(XCUIElement*)navbar{
    //logout
    if (app.toolbars.buttons[@"\uf08b"].exists) {
        [app.toolbars.buttons[@"\uf08b"] tap];
    }
    
    //login
    XCUIElement *usernameTextField = app.textFields[@"Username"];
    [usernameTextField tap];
    [usernameTextField typeText:@"frmpf"];
    
    XCUIElement *nextButton = app.buttons[@"Next"];
    [nextButton tap];
    
    XCUIElement *passwordSecureTextField = app.secureTextFields[@"Password"];
    [passwordSecureTextField typeText:@"test"];
    [passwordSecureTextField typeText:@"\n"];
    
}

@end
