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
    
    id _target;
    SEL _action;
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

- (void)addTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

- (void)setInitialValue:(int)val
{
    [_button setTitle:[NSString stringWithFormat:@"%d", val] forState:UIControlStateNormal];
    [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    // Cells for initial values cannot be edited, so we just prevent interacting with the button
    [_button setEnabled:NO];
}

- (void)changeValue:(int)val
{
    if (val == 0) {
        [_button setTitle:@"" forState:UIControlStateNormal];
    }
    else {
        [_button setTitle:[NSString stringWithFormat:@"%d", val] forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
}

- (void)buttonPressed:(id)sender
{
    [sender setBackgroundColor:[UIColor yellowColor]];
    [_target performSelector:_action withObject:[NSNumber numberWithInt:_row] withObject:[NSNumber numberWithInt:_column]];
}

- (void)buttonReleased:(id)sender
{
    [sender setBackgroundColor:[UIColor whiteColor]];
}

@end
