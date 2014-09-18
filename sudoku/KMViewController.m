//
//  KMViewController.m
//  sudoku
//
//  Created by Kevin McSwiggen on 9/15/14.
//  Copyright (c) 2014 Kevin McSwiggen. All rights reserved.
//

#import "KMViewController.h"
#import "KMGridView.h"

int initialGrid[9][9] = {
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

@interface KMViewController ()
{
    KMGridView* _gridView;
}

@end

@implementation KMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    CGRect frame = self.view.frame;
    CGFloat x = CGRectGetWidth(frame)*.1;
    CGFloat y = CGRectGetHeight(frame)*.1;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame))*.80;
    
    CGRect gridFrame = CGRectMake(x, y, size, size);
    
    _gridView = [[KMGridView alloc] initWithFrame:gridFrame];
    _gridView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_gridView];
    
    [self initializeGrid];
}

- (void)initializeGrid
{
    for (int row = 0; row < 9; row++)
    {
        for (int col = 0; col < 9; col++)
        {
            int val = initialGrid[row][col];
            if (val > 0) {
                [_gridView setInitialValueRow:row Column:col Value:val];
            }
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
