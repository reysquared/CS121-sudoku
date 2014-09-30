//
//  sudokuTests.m
//  sudokuTests
//
//  Created by Kevin McSwiggen on 9/15/14.
//  Copyright (c) 2014 Kevin McSwiggen. All rights reserved.
//

#import "KMGridModel.h"
#import "KMGridGenerator.h"
#import <XCTest/XCTest.h>

@interface sudokuTests : XCTestCase
{
    KMGridModel* _model;
    KMGridGenerator* _generator;
}

@end

@implementation sudokuTests

- (void)setUp
{
    [super setUp];
    
    NSString* easyGrid = @"11111111111111111111111111111111111111111111111111111111111111111111111111111111.";
    NSString* hardGrid = @"7..42...9..95....4.2.69.5..65....43..8...6..7.1..456.....86...234.9..1..8..3.274.";
    
    _model = [[KMGridModel alloc] initWithStringEasy:easyGrid Hard:hardGrid];
    
    [_model newGridMode:NO];
    
    _generator = [[KMGridGenerator alloc] init];
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

- (void)testResetGrid
{
    [_model updateGridRow:0 Column:2 Value:4];
    [_model updateGridRow:1 Column:0 Value:3];
    [_model resetGrid];
    
    XCTAssertTrue([_model getGridValueRow:0 Column:2] == 0, @"Retrieving (0,2) -- value reset.");
    XCTAssertTrue([_model getGridValueRow:1 Column:0] == 0, @"Retrieving (1,0) -- value reset.");
    XCTAssertTrue([_model getGridValueRow:0 Column:0] == 7, @"Retrieving (0,0) -- Initial value should be same.");
}

- (void)testModelNewGrid
{
    // Verify that we can generate a new grid for different difficulty modes
    [_model newGridMode:YES];
    XCTAssertTrue([_model getGridValueRow:0 Column:0] == 1, @"Retrieving (0,0) -- 1.");
    XCTAssertTrue([_model getGridValueRow:0 Column:1] == 1, @"Retrieving (0,1) -- 1.");
    XCTAssertTrue([_model getGridValueRow:1 Column:0] == 1, @"Retrieving (1,0) -- 1.");
    XCTAssertTrue([_model getGridValueRow:8 Column:8] == 0, @"Retrieving (8,8) -- 0.");
    
    [_model newGridMode:NO];
    XCTAssertTrue([_model getGridValueRow:0 Column:0] == 7, @"Retrieving (0,0) -- 7.");
    XCTAssertTrue([_model getGridValueRow:0 Column:1] == 0, @"Retrieving (0,1) -- 0.");
    XCTAssertTrue([_model getGridValueRow:1 Column:0] == 0, @"Retrieving (1,0) -- 0.");
    XCTAssertTrue([_model getGridValueRow:8 Column:8] == 0, @"Retrieving (8,8) -- 0.");
}

- (void)testGeneratorNewGrid
{
    NSMutableArray* grid = [_generator getNewGridMode:NO];
    // Because it is randomly generated, there is no intelligent way of anticipating the values stored in grid.
    
    XCTAssertTrue([grid count] == 9, @"Correct number of rows");
    XCTAssertTrue([[grid objectAtIndex:0] count] == 9, @"Correct number of columns");
    int valueAt00 = [[[grid objectAtIndex:0] objectAtIndex:0] intValue];
    XCTAssertTrue(valueAt00 >= 0 && valueAt00 <= 9, @"Some number between 0 and 9.");
}

- (void)testGridComplete
{
    // Use our "easy mode" grid so completion testing is simple
    [_model newGridMode:YES];
    
    XCTAssertFalse([_model gridComplete], @"Incomplete grid.");
    [_model updateGridRow:8 Column:8 Value:2];
    XCTAssertTrue([_model gridComplete], @"Complete grid.");
}

@end
