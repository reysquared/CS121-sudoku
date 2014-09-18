//
//  KMGridCell.h
//  sudoku
//
//  Created by Kevin McSwiggen on 9/15/14.
//  Copyright (c) 2014 Kevin McSwiggen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMGridCell : UIView
/*@property (readonly) int row;
@property (readonly) int col;
@property int val;*/
- (id)initWithFrame:(CGRect)frame Row:(int)row Column:(int)col;
- (void)setInitialValue:(int)val;
@end
