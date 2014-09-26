//
//  KMViewController.m
//  sudoku
//
//  Created by Kevin McSwiggen on 9/15/14.
//  Copyright (c) 2014 Kevin McSwiggen. All rights reserved.
//

#import "KMViewController.h"
#import "KMGridView.h"
#import "KMNumPadView.h"
#import "KMGridModel.h"

CGFloat GRID_INSET_RATIO = 0.1;



@interface KMViewController ()
{
    KMGridView* _gridView;
    KMNumPadView* _numPadView;
    KMGridModel* _gridModel;
}

@end

@implementation KMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect frame = self.view.frame;
    CGFloat x = CGRectGetWidth(frame)*GRID_INSET_RATIO;
    CGFloat y = CGRectGetHeight(frame)*GRID_INSET_RATIO;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame))*(1 - 2 * GRID_INSET_RATIO);
    
    CGRect gridFrame = CGRectMake(x, y, size, size);
    
    _gridView = [[KMGridView alloc] initWithFrame:gridFrame];
    _gridView.backgroundColor = [UIColor blackColor];
    [_gridView addTarget:self action:@selector(gridPressedRow:Column:)];
    
    [self.view addSubview:_gridView];
    
    CGFloat numPadX = x;
    CGFloat numPadY = CGRectGetHeight(frame) - size / 3; //TODO
    CGFloat numPadWidth = size / 10;
    CGFloat numPadLength = size;
    CGRect numPadFrame = CGRectMake(numPadX, numPadY, numPadLength, numPadWidth);
    
    _numPadView = [[KMNumPadView alloc] initWithFrame:numPadFrame];
    _numPadView.backgroundColor = [UIColor blackColor];
    
    _gridModel = [[KMGridModel alloc] init];

    
    [self.view addSubview:_numPadView];
    
    [self initializeGrid];
}

- (void)gridPressedRow:(NSNumber*)row Column:(NSNumber*)col
{
    int val = [_numPadView currentNumber];
    BOOL changed = [_gridModel updateGridRow:[row intValue] Column:[col intValue] Value:val];
    
    if (changed) {
        [_gridView changeValueRow:[row intValue] Column:[col intValue] Value:val];
    }
}


- (void)initializeGrid
{
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            int val = [_gridModel getGridValueRow:row Column:col];
            if (val > 0) {
                [_gridView setInitialValueRow:row Column:col Value:val];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // TODO Dispose of any resources that can be recreated.
}

@end
