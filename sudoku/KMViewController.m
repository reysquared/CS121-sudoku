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

@interface KMViewController ()
{
    KMGridView* _gridView;
    KMNumPadView* _numPadView;
    KMGridModel* _gridModel;
    UIButton* _resetButton;
    UIButton* _newGameButton;
    UIButton* _infoButton;
    UIButton* _muteButton;
    BOOL _easyMode;
    UILabel* _difficultyLabel;
    UILabel* _difficultyValueLabel;
    UILabel* _timerLabel;
    NSDate* _startTime;
    BOOL _timerActive;
    BOOL _musicActive;
    NSInteger _totalScore;
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
    
    [self initializeSounds];
                                  
    [self.view setBackgroundColor:[[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"parchment2.jpg"]]];
    
    // Fade-in transition for game screen
    CATransition* transition = [CATransition animation];
    transition.type = kCATransitionFade;
    transition.duration = 2;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
}

// Initialization code for background music
- (void)initializeSounds
{
    NSString* musicPath = [[NSBundle mainBundle] pathForResource:@"bgm" ofType:@"aiff"];
    NSURL* musicURL = [NSURL fileURLWithPath:musicPath];
    self.backgroundMusicPlayer = [[AVAudioPlayer alloc]
                                  initWithContentsOfURL:musicURL error:nil];
    self.backgroundMusicPlayer.numberOfLoops = -1; // Loop indefinitely
    [self.backgroundMusicPlayer prepareToPlay];
    [self.backgroundMusicPlayer play];
    
    _musicActive = YES;
}

// Update the timer label
- (void)updateTimer:(id)sender
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

// Create the view that represents the current state of the sudoku grid
- (void)createGridView
{
    CGRect frame = self.view.frame;
    CGFloat x = CGRectGetWidth(frame)*GRID_INSET_RATIO;
    CGFloat y = CGRectGetHeight(frame)*GRID_INSET_RATIO;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame))*(1 - 2 * GRID_INSET_RATIO);
    
    CGRect gridFrame = CGRectMake(x, y, size, size);

    _gridView = [[KMGridView alloc] initWithFrame:gridFrame];
    _gridView.backgroundColor = [UIColor clearColor];
    [[_gridView layer] setBorderColor:[UIColor blackColor].CGColor];
    [[_gridView layer] setBorderWidth:3.0f];
    [_gridView addTarget:self action:@selector(gridPressedRow:Column:)];
    
    [self.view addSubview:_gridView];
}

// Create the numpad buttons
- (void)createNumPadView
{
    CGRect frame = self.view.frame;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame))*(1 - 2 * GRID_INSET_RATIO);
    
    CGFloat numPadX = CGRectGetWidth(frame)*GRID_INSET_RATIO;
    CGFloat numPadY = CGRectGetHeight(frame) - size / 2.3; //TODO
    CGFloat numPadWidth = size / 10;
    CGFloat numPadLength = size;
    CGRect numPadFrame = CGRectMake(numPadX, numPadY, numPadLength, numPadWidth);
    
    _numPadView = [[KMNumPadView alloc] initWithFrame:numPadFrame];
    _numPadView.backgroundColor = [UIColor clearColor];

    [self.view addSubview:_numPadView];
}

// Create buttons for the sudoku menu that aren't part of the numpad
- (void)createMenuButtons
{
    CGRect frame = self.view.frame;
    CGFloat size = MIN(CGRectGetWidth(frame), CGRectGetHeight(frame))*(1 - 2 * GRID_INSET_RATIO);
    
    CGFloat buttonWidth = size / 10;
    CGFloat buttonLength = size / 5;
    CGFloat newGameButtonX = CGRectGetWidth(frame)*GRID_INSET_RATIO;
    CGFloat buttonY = CGRectGetHeight(frame) - size / 3.5; //TODO
    CGRect newGameButtonFrame = CGRectMake(newGameButtonX, buttonY, buttonLength, buttonWidth);
    
    _newGameButton = [[UIButton alloc] initWithFrame:newGameButtonFrame];
    _newGameButton.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    _newGameButton.showsTouchWhenHighlighted = YES;
    [[_newGameButton layer] setBorderWidth:2.5f];
    [[_newGameButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[_newGameButton layer] setCornerRadius:12.0f];
    
    [_newGameButton setTitle:@"New Game" forState:UIControlStateNormal];
    [_newGameButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_newGameButton.titleLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]];
    [_newGameButton addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];

    [self.view addSubview:_newGameButton];
    
    CGFloat resetButtonX = CGRectGetWidth(frame) * GRID_INSET_RATIO + (0.2 * 0.8 / 3) * CGRectGetWidth(frame)  + size / 5;

    CGRect resetButtonFrame = CGRectMake(resetButtonX, buttonY, buttonLength, buttonWidth);
    
    _resetButton = [[UIButton alloc] initWithFrame:resetButtonFrame];
    _resetButton.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    _resetButton.showsTouchWhenHighlighted = YES;
    [[_resetButton layer] setBorderWidth:2.5f];
    [[_resetButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[_resetButton layer] setCornerRadius:12.0f];
    
    [_resetButton setTitle:@"Restart" forState:UIControlStateNormal];
    [_resetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_resetButton.titleLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]];
    [_resetButton addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    [self.view addSubview:_resetButton];
    
    CGFloat infoButtonX = CGRectGetWidth(frame) * GRID_INSET_RATIO + (2 * 0.2 * 0.8 / 3) * CGRectGetWidth(frame)  + 2 * size / 5;
    
    CGRect infoButtonFrame = CGRectMake(infoButtonX, buttonY, buttonLength, buttonWidth);
    
    _infoButton = [[UIButton alloc] initWithFrame:infoButtonFrame];
    _infoButton.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    _infoButton.showsTouchWhenHighlighted = YES;
    [[_infoButton layer] setBorderWidth:2.5f];
    [[_infoButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[_infoButton layer] setCornerRadius:12.0f];
    
    [_infoButton setTitle:@"Info" forState:UIControlStateNormal];
    [_infoButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_infoButton.titleLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]];
    [_infoButton addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    [self.view addSubview:_infoButton];
    
    CGFloat muteButtonX = CGRectGetWidth(frame) * GRID_INSET_RATIO + (0.2 * 0.8) * CGRectGetWidth(frame)  + 3 * size / 5;
    
    CGRect muteButtonFrame = CGRectMake(muteButtonX, buttonY, buttonLength, buttonWidth);
    
    _muteButton = [[UIButton alloc] initWithFrame:muteButtonFrame];
    _muteButton.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.5f];
    _muteButton.showsTouchWhenHighlighted = YES;
    [[_muteButton layer] setBorderWidth:2.5f];
    [[_muteButton layer] setBorderColor:[UIColor blackColor].CGColor];
    [[_muteButton layer] setCornerRadius:12.0f];
    
    [_muteButton setTitle:@"Mute" forState:UIControlStateNormal];
    [_muteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_muteButton.titleLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f]];
    [_muteButton addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
    [self.view addSubview:_muteButton];
}

// Generate non-button text labels
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
    
    [_difficultyLabel setTextColor:[UIColor blackColor]];
    [_difficultyLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:16.0f]];
    
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
    
    CGFloat titleLabelX = CGRectGetWidth(frame) * GRID_INSET_RATIO + 2.9 * labelLength;
    CGFloat titleLabelY = CGRectGetHeight(frame) * GRID_INSET_RATIO /2 ;
    CGRect titleLabelFrame = CGRectMake(titleLabelX, titleLabelY, labelLength * 3, labelWidth);
    
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:titleLabelFrame];
    titleLabel.backgroundColor = [UIColor clearColor];
    
    [titleLabel setTextColor:[UIColor blackColor]];
    [titleLabel setText:@"S U D O K U"];
    [titleLabel setFont: [UIFont fontWithName:@"Papyrus" size:30.0f]];
    
    [self.view addSubview:titleLabel];
}

// Catch grid presses for player moves
- (void)gridPressedRow:(NSNumber*)row Column:(NSNumber*)col
{
    int val = [_numPadView currentNumber];
    BOOL changed = [_gridModel updateGridRow:[row intValue] Column:[col intValue] Value:val];
    
    if (changed) {
        // TODO Play successful-move noise?
        [_gridView changeValueRow:[row intValue] Column:[col intValue] Value:val];
        if ([_gridModel gridComplete]) {
            [self victoryAchieved];
        }
    }
}

// Show victory message and score
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
                                                           message:[NSString stringWithFormat:@"You solved the puzzle in %@ for a score of %ld.\nRunning score: %ld", [_timerLabel text], (long)score, (long)_totalScore]
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
    
    [victoryAlert show];
}

// Retrieve values from the grid model and set them in the grid view
- (void)initializeGrid
{
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            int val = [_gridModel getGridValueRow:row Column:col];
            [_gridView setInitialValueRow:row Column:col Value:val];
        }
    }
}

// Clear non-initial cells
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

// Show new game prompt, generate new grid based on selected difficulty
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

// Show rules and credits in alertView
- (void)showInfo
{
    UIAlertView* infoMessage = [[UIAlertView alloc] initWithTitle:@"Sudoku!"
                                                          message:@"The objective of sudoku is to enter a digit from 1 through 9 in each cell, in such a way that each horizontal row, vertical column, and three by three subgrid region contains each number once. \n \nMade by Kevin M and Jeongwoo C \n (c) 2014\nSound credits: keinzweiter on www.freesound.org\nBackground texture: www.myfreetextures.com"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
    [infoMessage show];
}

// Mute and unmute the background music
- (void)toggleMusic
{
    if (_musicActive) {
        _musicActive = NO;
        [self.backgroundMusicPlayer pause];
        [_muteButton setTitle:@"Unmute" forState:UIControlStateNormal];
    }
    else {
        _musicActive = YES;
        [self.backgroundMusicPlayer play];
        [_muteButton setTitle:@"Mute" forState:UIControlStateNormal];
    }
}

// Handle responses to multi-button alertViews
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
        [_difficultyLabel setText:@"Difficulty:"];
        [_gridModel newGridMode:_easyMode];
        
        _startTime = [NSDate date];
        _timerActive = YES;
        
        [self initializeGrid];
        [_resetButton setEnabled:YES];
        
        CATransition* transition = [CATransition animation];
        transition.type = kCATransitionPush;
        transition.duration = 1;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        [self.view.layer addAnimation:transition forKey:nil];
    }
    else if (alertView.tag == resetAlertTag) {
        if (buttonIndex == 1) {
            [_gridModel resetGrid];
            _startTime = [NSDate date];
            [self initializeGrid];
        }
        else {
            return;
        }
        
        CATransition* transition = [CATransition animation];
        transition.type = kCATransitionFade;
        transition.duration = 1;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        
        [self.view.layer addAnimation:transition forKey:nil];
    }
}

// Catch menu button presses
- (void)buttonReleased:(id)sender
{
    if (sender == _newGameButton) {
        [self startNewGame];
    }
    else if (sender == _resetButton) {
        [self resetGame];
    }
    else if (sender == _infoButton) {
        [self showInfo];
    }
    else if (sender == _muteButton) {
        [self toggleMusic];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // TODO Dispose of any resources that can be recreated.
}

@end
