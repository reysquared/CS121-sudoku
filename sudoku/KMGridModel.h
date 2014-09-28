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
- (void)resetGrid;
- (BOOL)gridComplete;
- (void)newGridMode:(BOOL)easyMode;
// Added below methods for unit testing purposes
- (BOOL)checkGridRow:(int)row Column:(int)col Value:(int)val;
- (BOOL)checkRow:(int)row Value:(int)val;
- (BOOL)checkColumn:(int)col Value:(int)val;
- (BOOL)checkSubgridRow:(int)row Column:(int)col Value:(int)val;

@end
