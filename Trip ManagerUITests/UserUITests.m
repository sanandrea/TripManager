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
