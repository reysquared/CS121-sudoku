//
//  KMGridCell.m
//  sudoku
//
//  Created by Kevin McSwiggen on 9/15/14.
//  Copyright (c) 2014 Kevin McSwiggen. All rights reserved.
//

#import "KMGridCell.h"

CGFloat CELL_INSET_RATIO = 0.05;

@implementation KMGridCell
{
    UIButton* _button;
    int _row;
    int _column;
}

- (id)initWithFrame:(CGRect)frame Row:(int)row Column:(int)col
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _row = row;
        _column = col;
        
        CGFloat size = CGRectGetWidth(frame);
        CGFloat inset = size*CELL_INSET_RATIO;
        CGFloat buttonSize = size - (2 * inset);
        CGRect buttonFrame = CGRectMake(inset, inset, buttonSize, buttonSize);
        
        _button = [[UIButton alloc] initWithFrame:buttonFrame];
        _button.backgroundColor = [UIColor whiteColor];
        _button.showsTouchWhenHighlighted = YES;
        
        [_button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
        [_button addTarget:self action:@selector(buttonReleased:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        
        [self addSubview:_button];
    }
    
    return self;
}

- (void)setInitialValue:(int)val
{
    [_button setTitle:[NSString stringWithFormat:@"%d", val] forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    // TODO Disable button for initial values
}

- (void)buttonPressed:(id)sender
{
    NSLog(@"Pressed button at row: %d col: %d", _row, _column);
    [sender setBackgroundColor:[UIColor yellowColor]];
}

- (void)buttonReleased:(id)sender
{
    [sender setBackgroundColor:[UIColor whiteColor]];
}

@end
