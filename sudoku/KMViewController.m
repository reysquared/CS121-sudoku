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

#import <QuartzCore/QuartzCore.h>

CGFloat GRID_INSET_RATIO = 0.1;



@interface KMViewController ()
{
    KMGridView* _gridView;
    KMNumPadView* _numPadView;
    KMGridModel* _gridModel;
    UIButton* _resetButton;
    UIButton* _newGameButton;
}

@end

@implementation KMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _gridModel = [[KMGridModel alloc] init];
    
    [self createGridView];
    [self createNumPadView];
    [self createMenuButtons];
    
    [self initializeGrid];
}

- (void)createGridView
{
    CGRect frame = self.view.frame;
    CGFloat x = CGRectGetWidth(frame)*GRID_INSET_RATIO;
    CGFloat y = CGRectGetHeight(frame)*GRID_INSET_RATIO;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame))*(1 - 2 * GRID_INSET_RATIO);
    
    CGRect gridFrame = CGRectMake(x, y, size, size);
    
    _gridView = [[KMGridView alloc] initWithFrame:gridFrame];
    _gridView.backgroundColor = [UIColor blackColor];
    [_gridView addTarget:self action:@selector(gridPressedRow:Column:)];
    
    [self.view addSubview:_gridView];
}

- (void)createNumPadView
{
    CGRect frame = self.view.frame;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame))*(1 - 2 * GRID_INSET_RATIO);
    
    CGFloat numPadX = CGRectGetWidth(frame)*GRID_INSET_RATIO;
    CGFloat numPadY = CGRectGetHeight(frame) - size / 2.5; //TODO
    CGFloat numPadWidth = size / 10;
    CGFloat numPadLength = size;
    CGRect numPadFrame = CGRectMake(numPadX, numPadY, numPadLength, numPadWidth);
    
    _numPadView = [[KMNumPadView alloc] initWithFrame:numPadFrame];
    _numPadView.backgroundColor = [UIColor blackColor];

    [self.view addSubview:_numPadView];
}

- (void)createMenuButtons
{
    CGRect frame = self.view.frame;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame))*(1 - 2 * GRID_INSET_RATIO);
    
    
    CGFloat resetButtonX = CGRectGetWidth(frame)*GRID_INSET_RATIO;
    CGFloat resetButtonY = CGRectGetHeight(frame) - size / 4.5; //TODO
    CGFloat buttonWidth = size / 10;
    CGFloat buttonLength = size / 5;
    CGRect resetButtonFrame = CGRectMake(resetButtonX, resetButtonY, buttonLength, buttonWidth);
    
    _resetButton = [[UIButton alloc] initWithFrame:resetButtonFrame];
    _resetButton.backgroundColor = [UIColor whiteColor];
    _resetButton.showsTouchWhenHighlighted = YES;
    [[_resetButton layer] setBorderWidth:3.0f];
    [[_resetButton layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [_resetButton setTitle:@"Restart" forState:UIControlStateNormal];
    [_resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

    
    [_resetButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    [_resetButton addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];

    
    [self.view addSubview:_resetButton];
    
    
    
    CGFloat newGameButtonX = CGRectGetWidth(frame) * GRID_INSET_RATIO + (0.2 * 0.8 / 3) * CGRectGetWidth(frame)  + size / 5;
    CGFloat newGameButtonY = CGRectGetHeight(frame) - size / 4.5; //TODO
    CGRect newGameButtonFrame = CGRectMake(newGameButtonX, newGameButtonY, buttonLength, buttonWidth);
    
    _newGameButton = [[UIButton alloc] initWithFrame:newGameButtonFrame];
    _newGameButton.backgroundColor = [UIColor whiteColor];
    _newGameButton.showsTouchWhenHighlighted = YES;
    [[_newGameButton layer] setBorderWidth:3.0f];
    [[_newGameButton layer] setBorderColor:[UIColor blackColor].CGColor];
    
    [_newGameButton setTitle:@"New Game" forState:UIControlStateNormal];
    [_newGameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_newGameButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    [_newGameButton addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];

    
    [self.view addSubview:_newGameButton];
 
}

- (void)gridPressedRow:(NSNumber*)row Column:(NSNumber*)col
{
    int val = [_numPadView currentNumber];
    BOOL changed = [_gridModel updateGridRow:[row intValue] Column:[col intValue] Value:val];
    
    if (changed) {
        [_gridView changeValueRow:[row intValue] Column:[col intValue] Value:val];
        if ([_gridModel gridComplete]) {
            // TODO
        }
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
            else {
                [_gridView changeValueRow:row Column:col Value:val];
            }
        }
    }
}



- (void)resetGame
{
    [_gridModel resetGrid];
    [self initializeGrid];
}

- (void)startNewGame
{
    BOOL easyMode = YES;
    
    [_gridModel newGrid:easyMode];
    [self initializeGrid];
}

- (void)buttonPressed:(id)sender
{
    if (sender == _newGameButton) {
        [self startNewGame];
    }
    else if (sender == _resetButton) {
        [self resetGame];
    }
    
    [sender setBackgroundColor:[UIColor magentaColor]];
}

- (void)buttonReleased:(id)sender
{
    [sender setBackgroundColor:[UIColor whiteColor]];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // TODO Dispose of any resources that can be recreated.
}

@end
