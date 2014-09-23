//
//  sudokuTests.m
//  sudokuTests
//
//  Created by Kevin McSwiggen on 9/15/14.
//  Copyright (c) 2014 Kevin McSwiggen. All rights reserved.
//

#import "KMGridModel.h"
#import <XCTest/XCTest.h>

@interface sudokuTests : XCTestCase
{
    KMGridModel* _model;
}

@end

@implementation sudokuTests

- (void)setUp
{
    [super setUp];
    
    _model = [[KMGridModel alloc] init];

// The starting grid looks like this:
//    {7,0,0,4,2,0,0,0,9},
//    {0,0,9,5,0,0,0,0,4},
//    {0,2,0,6,9,0,5,0,0},
//    {6,5,0,0,0,0,4,3,0},
//    {0,8,0,0,0,6,0,0,7},
//    {0,1,0,0,4,5,6,0,0},
//    {0,0,0,8,6,0,0,0,2},
//    {3,4,0,9,0,0,1,0,0},
//    {8,0,0,3,0,2,7,4,0},
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testGetGridValue
{
    XCTAssertTrue([_model getGridValueRow:0 Column:0] == 7, @"Retrieving (0,0) -- initial value.");
    XCTAssertTrue([_model getGridValueRow:1 Column:5] == 0, @"Retrieving (1,5) -- empty cell.");
    [_model updateGridRow:0 Column:1 Value:3];
    XCTAssertTrue([_model getGridValueRow:0 Column:1] == 3, @"Retrieving (0,1) after updating");
}

- (void)testCheckRow
{
    XCTAssertTrue([_model checkRow:0 Value:3], @"Insert valid number");
    XCTAssertFalse([_model checkRow:4 Value:6], @"Insert inconsistent number");
    XCTAssertThrowsSpecific([_model checkRow:2 Value:0], NSException, @"checkRow should not receive 0 values");
    XCTAssertThrowsSpecific([_model checkRow:2 Value:11], NSException, @"checkRow value too big");
    XCTAssertThrowsSpecific([_model checkRow:9 Value:3], NSException, @"Row out of bounds");
    XCTAssertThrowsSpecific([_model checkRow:-1 Value:6], NSException, @"Negative row value");
}

- (void)testCheckColumn
{
    XCTAssertTrue([_model checkColumn:0 Value:4], @"Insert valid number");
    XCTAssertFalse([_model checkColumn:2 Value:9], @"Insert inconsistent number");
    XCTAssertThrowsSpecific([_model checkColumn:2 Value:0], NSException, @"checkColumn should not receive 0 values");
    XCTAssertThrowsSpecific([_model checkColumn:2 Value:11], NSException, @"checkColumn value too big");
    XCTAssertThrowsSpecific([_model checkColumn:9 Value:3], NSException, @"Column out of bounds");
    XCTAssertThrowsSpecific([_model checkColumn:-1 Value:6], NSException, @"Negative column value");
}

- (void)testCheckSubgrid
{
    XCTAssertTrue([_model checkSubgridRow:0 Column:0 Value:4], @"Insert valid number");
    XCTAssertFalse([_model checkSubgridRow:4 Column:6 Value:7], @"Insert inconsistent number");
    XCTAssertThrowsSpecific([_model checkSubgridRow:0 Column:2 Value:0], NSException, @"checkSubgrid should not receive 0 values");
    XCTAssertThrowsSpecific([_model checkSubgridRow:0 Column:2 Value:11], NSException, @"checkSubgrid value too big");
    XCTAssertThrowsSpecific([_model checkSubgridRow:0 Column:9 Value:3], NSException, @"Subgrid column out of bounds");
    XCTAssertThrowsSpecific([_model checkSubgridRow:0 Column:-1 Value:6], NSException, @"Negative Subgrid column value");
    XCTAssertThrowsSpecific([_model checkSubgridRow:9 Column:3 Value:3], NSException, @"Subgrid row out of bounds");
    XCTAssertThrowsSpecific([_model checkSubgridRow:-1 Column:5 Value:6], NSException, @"Negative Subgrid row value");
}

- (void)testCheckGrid
{
    XCTAssertFalse([_model checkGridRow:0 Column:0 Value:3], @"Cannot modify initial values");
    XCTAssertTrue([_model checkGridRow:0 Column:1 Value:3], @"Insert valid number");
    XCTAssertThrowsSpecific([_model checkGridRow:-1 Column:1 Value:3], NSException, @"Checking out of bounds row");
}

- (void)testUpdateGrid
{
    XCTAssertFalse([_model updateGridRow:0 Column:2 Value:7], @"Attempting to make inconsistent update");
    XCTAssertTrue([_model updateGridRow:6 Column:1 Value:7], @"Making valid assignment");
    XCTAssertTrue([_model getGridValueRow:6 Column:1] == 7, @"Checking persistence of changes");
}

@end
