//
//  DagolfLaUITests.m
//  DagolfLaUITests
//
//  Created by SHL on 2017/4/24.
//  Copyright © 2017年 bhxx. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface DagolfLaUITests : XCTestCase

@end

@implementation DagolfLaUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *tablesQuery = app.tables;
    [[[[tablesQuery.otherElements containingType:XCUIElementTypeButton identifier:@"kaiju"] childrenMatchingType:XCUIElementTypeButton] elementBoundByIndex:0] tap];
    [app.alerts[@"\u541b\u9ad8\u9ad8\u5c14\u592b"].buttons[@"\u786e\u5b9a"] tap];
    [tablesQuery.buttons[@"date close"] tap];
    
    
    
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
