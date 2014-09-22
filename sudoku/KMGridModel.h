//
//  KMGridModel.h
//  sudoku
//
//  Created by jarthurcs on 9/19/14.
//  Copyright (c) 2014 Kevin McSwiggen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMGridModel : NSObject

- (int)getGridValueRow:(int)row Column:(int)col;
- (BOOL)updateGridRow:(int)row Column:(int)col Value:(int)val;

@end
