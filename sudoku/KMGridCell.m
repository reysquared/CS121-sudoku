//
//  KMGridCell.m
//  sudoku
//
//  Created by Kevin McSwiggen on 9/15/14.
//  Copyright (c) 2014 Kevin McSwiggen. All rights reserved.
//

#import "KMGridCell.h"

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
        CGFloat inset = size*0.05;
        CGFloat buttonSize = size*0.90; // TODO Should really probably get rid of more magic values...
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

// I don't know if this is actually a good way to do this, but it's a way.
//- (id)initWithFrame:(CGRect)frame
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
