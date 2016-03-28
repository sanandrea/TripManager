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
//  TripUITests.m
//  Trip Manager
//
//  Created by Andi Palo on 02/03/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface TripUITests : XCTestCase{
    XCUIApplication *app;
}


@end

@implementation TripUITests

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

- (void)testAddTrip {
    XCUIElement *navbar = [app.navigationBars elementBoundByIndex:0];
    
    if (![navbar.identifier isEqualToString:@"Trips"]) {
        [self goToTripsView:navbar];
    }
    NSUInteger numOfTripsBefore = [app.cells count];
    [app.toolbars.buttons[@"\uf067"] tap];
    
    XCUIElementQuery *tablesQuery = app.tables;
    [tablesQuery.textFields[@"Type Destination"] tap];
    [[[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"Destination"] childrenMatchingType:XCUIElementTypeTextField].element typeText:@"asd"];
    
    
    XCUIElementQuery *cellsQuery = tablesQuery.cells;
    XCUIElement *startDateCell = [cellsQuery elementBoundByIndex:1];
    [startDateCell tap];
    XCUIElement *pickerDate = [app.pickerWheels elementBoundByIndex:0];
    XCTAssertTrue(pickerDate.exists);
    [pickerDate adjustToPickerWheelValue:@"Mar 4"];
    [startDateCell tap];
    
    
    XCUIElement *endDateCell = [cellsQuery elementBoundByIndex:2];
    [endDateCell tap];
    XCTAssertTrue(pickerDate.exists);
    [pickerDate adjustToPickerWheelValue:@"Mar 5"];
    [endDateCell tap];
    [tablesQuery.textFields[@"Type a comment"] tap];
    [[[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"Comment"] childrenMatchingType:XCUIElementTypeTextField].element typeText:@"wer"];
    [app.navigationBars[@"Trips"].buttons[@"Save"] tap];
    
    //check if there is a new cell
    XCTAssertEqual([app.cells count], numOfTripsBefore + 1);
}

- (void)testRemoveTrip {
    XCUIElement *navbar = [app.navigationBars elementBoundByIndex:0];
    
    if (![navbar.identifier isEqualToString:@"Trips"]) {
        [self goToTripsView:navbar];
    }
    NSUInteger numOfTripsBefore = [app.cells count];
    
    XCUIElement *tripsNavigationBar = app.navigationBars[@"Trips"];
    [tripsNavigationBar.buttons[@"Edit"] tap];
    
    XCUIElement *lastCell = [app.tables.cells elementBoundByIndex:(numOfTripsBefore -1)];
    
    NSPredicate *delete = [NSPredicate predicateWithFormat:@"label BEGINSWITH 'Delete'"];
    [[lastCell.buttons matchingPredicate:delete].element tap];
    [app.tables.buttons[@"Delete"] tap];
    [tripsNavigationBar.buttons[@"Done"] tap];
    
    XCTAssertEqual([app.cells count], numOfTripsBefore - 1);
}

- (void) goToTripsView:(XCUIElement*)navbar{
    //logout
    if (app.toolbars.buttons[@"\uf08b"].exists) {
        [app.toolbars.buttons[@"\uf08b"] tap];
    }
    XCTAssertTrue([navbar.identifier isEqualToString:@"Master"]);
    //login
    XCUIElement *usernameTextField = app.textFields[@"Username"];
    [usernameTextField tap];
    [usernameTextField typeText:@"andi"];
    
    XCUIElement *nextButton = app.buttons[@"Next"];
    [nextButton tap];
    
    XCUIElement *passwordSecureTextField = app.secureTextFields[@"Password"];
    [passwordSecureTextField typeText:@"test"];
    [passwordSecureTextField typeText:@"\n"];
    XCTAssertTrue([navbar.identifier isEqualToString:@"Trips"]);
}

@end
