//
//  KMNumPadView.m
//  sudoku
//
//  Created by jarthurcs on 9/19/14.
//  Copyright (c) 2014 Kevin McSwiggen. All rights reserved.
//

#import "KMNumPadView.h"
#import <QuartzCore/QuartzCore.h>

CGFloat NUMPAD_PADDING_RATIO = 0.1;

@implementation KMNumPadView
{
    NSMutableArray* _buttons;
    int _currentNumber;
}

- (id)initWithFrame:(CGRect)frame
{
    _currentNumber = 0;
    self = [super initWithFrame:frame];
    if (self) {
        _buttons = [[NSMutableArray alloc] initWithCapacity:9];
        CGFloat height = CGRectGetHeight(frame);
        CGFloat paddingSize = height*NUMPAD_PADDING_RATIO;
        
        CGFloat width = CGRectGetWidth(frame);
        
        
        CGFloat buttonHeight = height - (2.0 * paddingSize);
        CGFloat buttonWidth = (width - (11.0 * paddingSize)) / 10.0;
        
        for (int i = 0; i < 10; i++) {
            CGFloat inset = (i + 1) * paddingSize + i * buttonWidth;
            
            CGRect buttonFrame = CGRectMake(inset, paddingSize, buttonWidth, buttonHeight);
            UIButton* currentButton = [[UIButton alloc] initWithFrame:buttonFrame];
            currentButton.backgroundColor = [UIColor clearColor];
            [[currentButton layer] setBorderColor:[UIColor blackColor].CGColor];
            [[currentButton layer] setBorderWidth:2.5f];
            [[currentButton layer] setCornerRadius:8.0f];
            [currentButton.titleLabel setFont: [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f]];
            if (i > 0) {
                [currentButton setTitle:[NSString stringWithFormat:@"%d", i] forState:UIControlStateNormal];
                [currentButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            else {
                [currentButton setTitle:@"X" forState:UIControlStateNormal];
                [currentButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [currentButton setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.5f]];
            }
            [self addSubview:currentButton];
            [_buttons addObject:currentButton];
            
            currentButton.tag = i;
            
            [currentButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return self;
}

- (int)currentNumber
{
    return _currentNumber;
}

- (void)buttonPressed:(id)sender
{
    [_buttons[_currentNumber] setBackgroundColor:[UIColor clearColor]];
    _currentNumber = (int)[sender tag];
    [(id)sender setBackgroundColor:[UIColor colorWithWhite:1.0f alpha:0.5f]];
}

@end
