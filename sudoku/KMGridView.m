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
    NSMutableArray* _cells;
    id _target;
    SEL _action;
}

- (void)setInitialValueRow:(int)row Column:(int)col Value:(int)val
{
    [_cells[row][col] setInitialValue:val];
}

- (void)changeValueRow:(int)row Column:(int)col Value:(int)val
{
    [_cells[row][col] changeValue:val];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat size = CGRectGetWidth(frame);
        _paddingSize = size * PADDING_RATIO;
        _cellSize = (size - (_paddingSize * PADDING_COUNT)) / GRID_SIZE;
        
        _cells = [[NSMutableArray alloc] initWithCapacity:GRID_SIZE];
        
        for (int row = 0; row < GRID_SIZE; row++) {
            NSMutableArray* currRow = [[NSMutableArray alloc] initWithCapacity:GRID_SIZE];
            
            for (int col = 0; col < GRID_SIZE; col++) {
                KMGridCell* newCell = [self createCellRow:row Column:col];
                [currRow addObject:newCell];
                
                [newCell addTarget:self action:@selector(cellPressedRow:Column:)];
            }
            [_cells addObject:currRow];
        }
    }
    return self;
}

-(void) addTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)cellPressedRow:(NSNumber*)row Column:(NSNumber*)col
{
    [_target performSelector:_action withObject:row withObject:col];
}

// This method will assume row and column to be 0-indexed, not 1-indexed.
- (KMGridCell*)createCellRow:(int)row Column:(int)col
{
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
    
    CGRect cellFrame = CGRectMake(x, y, _cellSize, _cellSize);
    
    KMGridCell* newCell = [[KMGridCell alloc] initWithFrame:cellFrame Row:row Column:col];
    
    [self addSubview:newCell];
    
    return newCell;
}

@end
