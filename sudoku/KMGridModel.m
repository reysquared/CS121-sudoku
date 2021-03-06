//
//  KMGridModel.m
//  sudoku
//
//  Created by jarthurcs on 9/19/14.
//  Copyright (c) 2014 Kevin McSwiggen. All rights reserved.
//

#import "KMGridModel.h"
#import "KMGridGenerator.h"


@implementation KMGridModel
{
    KMGridGenerator* _gridGenerator;
    int _initialGrid[9][9];
    int _currentGrid[9][9];
}

- (id)init
{
    self = [super init];
    if (self) {
        _gridGenerator = [[KMGridGenerator alloc] init];
    }
    return self;
}

// For unit testing purposes
- (id) initWithStringEasy:(NSString*)easyGrid Hard:(NSString*)hardGrid
{
    self = [super init];
    if (self) {
        _gridGenerator = [[KMGridGenerator alloc] initWithStringEasy:easyGrid Hard:hardGrid];
    }
    return self;
}

// Get a new grid of the selected difficulty
- (void)newGridMode:(BOOL)easyMode
{
    NSMutableArray* grid = [_gridGenerator getNewGridMode:easyMode];
    
    for (int row = 0 ;  row < 9 ; row++) {
        for (int col = 0 ; col < 9; col++) {
            _initialGrid[row][col] = [[[grid objectAtIndex:row] objectAtIndex:col] intValue];
            _currentGrid[row][col] = [[[grid objectAtIndex:row] objectAtIndex:col] intValue];
        }
    }
}

// Check validity of placing val at (row, col)
- (BOOL)checkGridRow:(int)row Column:(int)col Value:(int)val
{
    NSAssert(row >= 0 && row < 9 && col >= 0 && col < 9 && val >= 0 && val < 10, @"checkGrid: invalid input");
    if (_initialGrid[row][col] != 0) {
        return NO;
    }
    return (val == 0) ||
        ([self checkRow:row Value:val] &&
        [self checkColumn:col Value:val] &&
        [self checkSubgridRow:row Column:col Value:val]);
}

// Attempt to insert a value in the grid; if valid, updates the model and returns YES.
- (BOOL)updateGridRow:(int)row Column:(int)col Value:(int)val
{
    if ([self checkGridRow:(int)row Column:(int)col Value:(int)val]) {
        _currentGrid[row][col] = val;
        return YES;
    }
    return NO;
}

// Helper method for checkGridRow:Column:Value:
- (BOOL)checkRow:(int)row Value:(int)val
{
    NSAssert(row >= 0 && row < 9 && val > 0 && val < 10, @"checkRow: invalid input");
    for (int i = 0; i < 9; i++) {
        if (_currentGrid[row][i] == val) {
            return NO;
        }
    }
    return YES;
}

// Helper method for checkGridRow:Column:Value:
- (BOOL)checkColumn:(int)col Value:(int)val
{
    NSAssert(col >= 0 && col < 9 && val > 0 && val < 10, @"checkColumn: invalid input");
    for (int i = 0; i < 9; i++) {
        if (_currentGrid[i][col] == val) {
            return NO;
        }
    }
    return YES;
}

// Helper method for checkGridRow:Column:Value:
- (BOOL)checkSubgridRow:(int)row Column:(int)col Value:(int)val
{
    NSAssert(row >= 0 && row < 9 && col >= 0 && col < 9 && val > 0 && val < 10, @"checkSubgrid: invalid input");
    int startRow = (row / 3) * 3;
    int startCol = (col / 3) * 3;
    for (int i = startRow; i < startRow + 3; i++) {
        for (int j = startCol; j < startCol + 3; j++) {
            if (_currentGrid[i][j] == val) {
                return NO;
            }
        }
    }
    return YES;
}

// Returns the value in the current grid located at (row, col)
- (int)getGridValueRow:(int)row Column:(int)col
{
    NSAssert(row >= 0 && row < 9 && col >= 0 && col < 9, @"getGridValue: out of bounds");
    return _currentGrid[row][col];
}

// Resets the current grid to the initial grid
- (void)resetGrid
{
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++){
            _currentGrid[row][col] = _initialGrid[row][col];
        }
    }
}

// Verify that there are no empty spaces in the sudoku grid
- (BOOL)gridComplete
{
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++){
            if (_currentGrid[row][col] == 0) {
                return NO;
            }
        }
    }
    return YES;
}

@end
