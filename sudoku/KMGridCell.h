//
//  KMGridCell.h
//  sudoku
//
//  Created by Kevin McSwiggen on 9/15/14.
//  Copyright (c) 2014 Kevin McSwiggen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMGridCell : UIView
- (id)initWithFrame:(CGRect)frame Row:(int)row Column:(int)col;
- (void)setInitialValue:(int)val;
- (void)changeValue:(int)val;
- (void)addTarget:(id)target action:(SEL)action;
@end
