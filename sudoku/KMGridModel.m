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

- (id)init
{
    return self;
}

- (BOOL)checkGridRow:(int)row Column:(int)col Value:(int)val
{
    return [self checkRow:row Value:val] &&
        [self checkColumn:col Value:val] &&
        [self checkSubgridRow:row Column:col Value:val];
}

- (BOOL)updateGridRow:(int)row Column:(int)col Value:(int)val
{
    // TODO ensure not modifying initial grid cells
    if ([self checkGridRow:(int)row Column:(int)col Value:(int)val] || val == 0) {
        _currentGrid[row][col] = val;
        return YES;
    }
    return NO; // TODO
}

- (BOOL)checkRow:(int)row Value:(int)val
{
    for (int i = 0; i < 10; i++) {
        if (_currentGrid[row][i] == val) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)checkColumn:(int)col Value:(int)val
{
    for (int i = 0; i < 10; i++) {
        if (_currentGrid[i][col] == val) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)checkSubgridRow:(int)row Column:(int)col Value:(int)val
{
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
    return _initialGrid[row][col];
}


@end
