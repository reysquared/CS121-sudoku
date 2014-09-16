//
//  KMGridView.m
//  sudoku
//
//  Created by Kevin McSwiggen on 9/15/14.
//  Copyright (c) 2014 Kevin McSwiggen. All rights reserved.
//

#import "KMGridView.h"
#import "KMGridCell.h"

int GRID_SIZE = 9; // Assuming all square
int SUBGRID_SIZE = 3;
int PADDING_COUNT = 4; // (GRID_SIZE / SUBGRID_SIZE) + 1
CGFloat PADDING_RATIO = 0.01;


@implementation KMGridView
{
    CGFloat _paddingSize;
    CGFloat _cellSize;
}

- (void)initializeGrid:(int[9][9])grid
{
    for (int row = 0; row < 9; row++)
    {
        for (int col = 0; col < 9; col++)
        {
            [self createCellAtRow:row andColumn:col withValue:grid[row][col]];
        }
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat size = CGRectGetWidth(frame);
        _paddingSize = size * PADDING_RATIO;
        _cellSize = (size - (_paddingSize * PADDING_COUNT)) / GRID_SIZE;
        
    }
    return self;
}

// This method will assume row and column to be 0-indexed, not 1-indexed.
- (void)createCellAtRow:(int)row andColumn:(int)col withValue:(int)val
{
    NSLog(@"Creating cell at %d,%d with value %d.", row, col, val);
    
    CGFloat y;
    CGFloat x;
    
    // First offset by the correct number of cells
    y = _cellSize * row;
    x = _cellSize * col;
    
    // Then correct for the desired amount of padding based on the sub-grid the cell is part of
    y += _paddingSize;
    y += (row / SUBGRID_SIZE) * _paddingSize;
        
    x += _paddingSize;
    x += (col / SUBGRID_SIZE) * _paddingSize;
    
    NSLog(@"Cell position: %1.2f, %1.2f. Width: %1.2f.", x, y, _cellSize);
    
    CGRect cellFrame = CGRectMake(x, y, _cellSize, _cellSize);
    
    KMGridCell* newCell = [[KMGridCell alloc] initWithFrame:cellFrame atRow:row atColumn:col withValue:val];
    
    [self addSubview:newCell];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
