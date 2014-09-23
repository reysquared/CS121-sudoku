//
//  KMGridModel.m
//  sudoku
//
//  Created by jarthurcs on 9/19/14.
//  Copyright (c) 2014 Kevin McSwiggen. All rights reserved.
//

#import "KMGridModel.h"

int _initialGrid[9][9]  = {
    {7,0,0,4,2,0,0,0,9},
    {0,0,9,5,0,0,0,0,4},
    {0,2,0,6,9,0,5,0,0},
    {6,5,0,0,0,0,4,3,0},
    {0,8,0,0,0,6,0,0,7},
    {0,1,0,0,4,5,6,0,0},
    {0,0,0,8,6,0,0,0,2},
    {3,4,0,9,0,0,1,0,0},
    {8,0,0,3,0,2,7,4,0},
};
int _currentGrid[9][9]  = {
    {7,0,0,4,2,0,0,0,9},
    {0,0,9,5,0,0,0,0,4},
    {0,2,0,6,9,0,5,0,0},
    {6,5,0,0,0,0,4,3,0},
    {0,8,0,0,0,6,0,0,7},
    {0,1,0,0,4,5,6,0,0},
    {0,0,0,8,6,0,0,0,2},
    {3,4,0,9,0,0,1,0,0},
    {8,0,0,3,0,2,7,4,0},
};

@implementation KMGridModel

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

//
- (BOOL)updateGridRow:(int)row Column:(int)col Value:(int)val
{
    if ([self checkGridRow:(int)row Column:(int)col Value:(int)val]) {
        _currentGrid[row][col] = val;
        return YES;
    }
    return NO;
}

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

- (int)getGridValueRow:(int)row Column:(int)col
{
    NSAssert(row >= 0 && row < 9 && col >= 0 && col < 9, @"getGridValue: out of bounds");
    return _currentGrid[row][col];
}


@end
