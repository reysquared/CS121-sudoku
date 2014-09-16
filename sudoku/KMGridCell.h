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
- (id)initWithFrame:(CGRect)frame atRow:(int)row atColumn:(int)col withValue:(int)val;
@end
