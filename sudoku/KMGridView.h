//
//  KMGridView.h
//  sudoku
//
//  Created by Kevin McSwiggen on 9/15/14.
//  Copyright (c) 2014 Kevin McSwiggen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMGridView : UIView
- (void)setInitialValueRow:(int)row Column:(int)col Value:(int)val;
- (void)changeValueRow:(int)row Column:(int)col Value:(int)val;
- (void)addTarget:(id)target action:(SEL)action;
@end
