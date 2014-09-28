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

#define newGameAlertTag 1
#define resetAlertTag 2
#define optionsAlertTag 3
// TODO?

@interface KMViewController ()
{
    KMGridView* _gridView;
    KMNumPadView* _numPadView;
    KMGridModel* _gridModel;
    UIButton* _resetButton;
    UIButton* _newGameButton;
    // NSString* _easyModeProgress;
    // NSString* _hardModeProgress;
    BOOL _easyMode;
    UILabel* _difficultyLabel;
    UILabel* _difficultyValueLabel;
    UILabel* _timerLabel;
    NSDate* _startTime;
    BOOL _timerActive;
    NSInteger _totalScore;
    // NSInteger _currentGridIndex;
}

@end

@implementation KMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _totalScore = 0;
    
    _gridModel = [[KMGridModel alloc] init];
    
    [self createGridView];
    [self createNumPadView];
    [self createMenuButtons];
    [self createTitle];
    
    [_resetButton setEnabled:NO];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(updateTimer:)
                                   userInfo:nil
                                    repeats:YES];
    
    _timerActive = NO;
    
//    NSString* path1 = [[NSBundle mainBundle] pathForResource:@"progress1" ofType:@"txt"];
//    NSString* path2 = [[NSBundle mainBundle] pathForResource:@"progress2" ofType:@"txt"];
//    
//    NSError* error1;
//    NSError* error2;
//    
//    _easyModeProgress = [[NSString alloc] initWithContentsOfFile:path1 encoding:NSUTF8StringEncoding error:&error1];
//    _hardModeProgress = [[NSString alloc] initWithContentsOfFile:path2 encoding:NSUTF8StringEncoding error:&error2];

}

-(void)updateTimer:(id)sender
{
    if (_timerActive) {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle: NSDateFormatterShortStyle];
        
        
        
        NSTimeInterval secondsElapsed = [[NSDate date] timeIntervalSinceDate:_startTime];
        
        
        
        NSString* timeElapsed = [NSString stringWithFormat:@"%li:%02li:%02li", lround(floor(secondsElapsed /3600.)),
                                 lround(floor(secondsElapsed /60.)) % 60,
                                 lround(floor(secondsElapsed)) % 60];
        [_timerLabel setText:timeElapsed];
    }
    
}

- (void)createGridView
{
    CGRect frame = self.view.frame;
    CGFloat x = CGRectGetWidth(frame)*GRID_INSET_RATIO;
    CGFloat y = CGRectGetHeight(frame)*GRID_INSET_RATIO;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame))*(1 - 2 * GRID_INSET_RATIO);
    
    CGRect gridFrame = CGRectMake(x, y, size, size);

    
    _gridView = [[KMGridView alloc] initWithFrame:gridFrame];
    _gridView.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"parchment.jpg"]];
    [[_gridView layer] setBorderColor:[UIColor blackColor].CGColor];
    [[_gridView layer] setBorderWidth:3.0f];
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
    
    CGFloat buttonWidth = size / 10;
    CGFloat buttonLength = size / 5;
    CGFloat newGameButtonX = CGRectGetWidth(frame)*GRID_INSET_RATIO;
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
    
    CGFloat resetButtonX = CGRectGetWidth(frame) * GRID_INSET_RATIO + (0.2 * 0.8 / 3) * CGRectGetWidth(frame)  + size / 5;
    CGFloat resetButtonY = CGRectGetHeight(frame) - size / 4.5; //TODO

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
 
}

- (void)createTitle
{
    CGRect frame = self.view.frame;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame))*(1 - 2 * GRID_INSET_RATIO);
    
    CGFloat labelWidth = size / 12;
    CGFloat labelLength = size / 8;
    CGFloat difficultyLabelX = CGRectGetWidth(frame)*GRID_INSET_RATIO;
    CGFloat difficultyLabelY = CGRectGetHeight(frame)*GRID_INSET_RATIO /2;
    CGRect difficultyLabelFrame = CGRectMake(difficultyLabelX, difficultyLabelY, labelLength, labelWidth);
    
    _difficultyLabel = [[UILabel alloc] initWithFrame:difficultyLabelFrame];
    _difficultyLabel.backgroundColor = [UIColor clearColor];
    
    [_difficultyLabel setText:@"Difficulty:"];
    [_difficultyLabel setTextColor:[UIColor blackColor]];
    [_difficultyLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f] ];
    
    [self.view addSubview:_difficultyLabel];
    
    CGFloat difficultyValueLabelX = CGRectGetWidth(frame) * GRID_INSET_RATIO + labelLength;
    CGFloat difficultyValueLabelY = CGRectGetHeight(frame)*GRID_INSET_RATIO / 2;
    CGRect difficultyValueLabelFrame = CGRectMake(difficultyValueLabelX, difficultyValueLabelY, labelLength, labelWidth);
    
    _difficultyValueLabel = [[UILabel alloc] initWithFrame:difficultyValueLabelFrame];
    _difficultyValueLabel.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:_difficultyValueLabel];
    
    CGFloat timerLabelX = size;
    CGFloat timerLabelY = CGRectGetHeight(frame) * GRID_INSET_RATIO /2;
    CGRect timerLabelFrame = CGRectMake(timerLabelX, timerLabelY, labelLength, labelWidth);
    
    _timerLabel = [[UILabel alloc] initWithFrame:timerLabelFrame];
    _timerLabel.backgroundColor = [UIColor clearColor];
    
    [_timerLabel setTextColor:[UIColor blackColor]];
    
    [self.view addSubview:_timerLabel];

}



- (void)gridPressedRow:(NSNumber*)row Column:(NSNumber*)col
{
    int val = [_numPadView currentNumber];
    BOOL changed = [_gridModel updateGridRow:[row intValue] Column:[col intValue] Value:val];
    
    if (changed) {
        [_gridView changeValueRow:[row intValue] Column:[col intValue] Value:val];
        if ([_gridModel gridComplete]) {
            [self victoryAchieved];
        }
    }
}

- (void)victoryAchieved
{
    _timerActive = NO;
    
    NSInteger score = 1000;
    
    NSTimeInterval secondsElapsed = [[NSDate date] timeIntervalSinceDate:_startTime];
    if (secondsElapsed < 2000) {
        score += 2000 - secondsElapsed;
    }
    
    _totalScore += score;
    
    UIAlertView* victoryAlert = [[UIAlertView alloc] initWithTitle:@"You Win!"
                                                           message:[NSString stringWithFormat:@"You solved the puzzle in %@ for a score of %ld.\nRunning score: %ld", [_timerLabel text], score, _totalScore]
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
    
    [victoryAlert show];
    //[self updateProgress];

}

//- (void)updateProgress
//{
//    NSLog(@"asdf");
//    NSString* path1 = [[NSBundle mainBundle] pathForResource:@"progress1" ofType:@"txt"];
//    NSString* path2 = [[NSBundle mainBundle] pathForResource:@"progress2" ofType:@"txt"];
//    
//    NSError* error1;
//    NSError* error2;
//    
//    if (_easyMode){
//        NSLog(@"asdasdfasdf");
//        [_easyModeProgress stringByReplacingCharactersInRange:NSMakeRange(_currentGridIndex, 1) withString:@"1"];
//        [_easyModeProgress writeToFile:path1 atomically:YES encoding:NSUTF8StringEncoding error:&error1];
//        NSLog(@"af");
//        
//    }
//    else {
//        [_hardModeProgress stringByReplacingCharactersInRange:NSMakeRange(_currentGridIndex, 1) withString:@"1"];
//        [_hardModeProgress writeToFile:path2 atomically:YES encoding:NSUTF8StringEncoding error:&error2];
//    }
//}
//
//- (void)updateCurrentGridIndex
//{
//    if (_easyMode){
//        _currentGridIndex = [_easyModeProgress rangeOfString:@"0"].location;
//
//    }
//    else {
//        _currentGridIndex = [_hardModeProgress rangeOfString:@"0"].location;
//    }
//}

- (void)initializeGrid
{
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            int val = [_gridModel getGridValueRow:row Column:col];
            [_gridView setInitialValueRow:row Column:col Value:val];
        }
    }
}

- (void)resetGame
{

    UIAlertView* resetAlert = [[UIAlertView alloc] initWithTitle:@"Reset game?"
                                                           message:@"You will lose all progress!"
                                                          delegate:self
                                                 cancelButtonTitle:@"Cancel"
                                                 otherButtonTitles:nil];
    resetAlert.tag = resetAlertTag;
    [resetAlert addButtonWithTitle:@"OK"];
    [resetAlert show];
}

- (void)startNewGame
{
    UIAlertView* newGameAlert = [[UIAlertView alloc] initWithTitle:@"New Game"
                                                    message:@"Select difficulty:"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:nil];
    newGameAlert.tag = newGameAlertTag;
    [newGameAlert addButtonWithTitle:@"Easy"];
    [newGameAlert addButtonWithTitle:@"HARD!"];
    [newGameAlert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == newGameAlertTag) {
        
        if (buttonIndex == 1) {
            _easyMode = YES;
            [_difficultyValueLabel setText: @"Easy"];
            [_difficultyValueLabel setTextColor:[UIColor blackColor]];
        }
        else if(buttonIndex == 2) {
            _easyMode = NO;
            [_difficultyValueLabel setText: @"Hard"];
            [_difficultyValueLabel setTextColor:[UIColor redColor]];
        }
        else {
            return;
        }
        
//        [self updateCurrentGridIndex];
//        
//        if (_currentGridIndex == NSNotFound) {
//            [self outOfPuzzles];
//            return;
//        }
//
        [_gridModel newGridMode:_easyMode];
        
        _startTime = [NSDate date];
        _timerActive = YES;
        
        [self initializeGrid];
        [_resetButton setEnabled:YES];
    }
    else if (alertView.tag == resetAlertTag) {
        if (buttonIndex == 1) {
            [_gridModel resetGrid];
            _startTime = [NSDate date];
            [self initializeGrid];
        }
    }
    
    
}

- (void)outOfPuzzles
{
    
}

- (void)buttonPressed:(id)sender
{
    [sender setBackgroundColor:[UIColor magentaColor]];
}

- (void)buttonReleased:(id)sender
{
    [sender setBackgroundColor:[UIColor whiteColor]];
    
    if (sender == _newGameButton) {
        [self startNewGame];
    }
    else if (sender == _resetButton) {
        [self resetGame];
    }
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // TODO Dispose of any resources that can be recreated.
}

@end
