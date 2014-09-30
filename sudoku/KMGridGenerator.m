//
//  KMGridGenerator.m
//  sudoku
//
//  Created by jarthurcs on 9/26/14.
//  Copyright (c) 2014 Kevin McSwiggen. All rights reserved.
//

#import "KMGridGenerator.h"

@implementation KMGridGenerator
{
    NSString* _easyGrids;
    NSString* _hardGrids;
}

- (id) init
{
    NSString* path1 = [[NSBundle mainBundle] pathForResource:@"grid1" ofType:@"txt"];
    NSString* path2 = [[NSBundle mainBundle] pathForResource:@"grid2" ofType:@"txt"];
    
    NSError* error1;
    NSError* error2;
    
    _easyGrids = [[NSString alloc] initWithContentsOfFile:path1 encoding:NSUTF8StringEncoding error:&error1];
    _hardGrids = [[NSString alloc] initWithContentsOfFile:path2 encoding:NSUTF8StringEncoding error:&error2];
    
    return self;
}

// For unit testing purposes
- (id) initWithStringEasy:(NSString*)easyGrid Hard:(NSString*)hardGrid
{
    _easyGrids = easyGrid;
    _hardGrids = hardGrid;
    
    return self;
}

// Generate new grid of the selected difficulty
- (NSMutableArray*) getNewGridMode:(BOOL)easyMode
{
    NSString* readString;
    if (easyMode) {
        readString = _easyGrids;
    }
    else {
        readString = _hardGrids;
    }
    
    int randNum = arc4random_uniform((int)[readString length]/82);
    
    NSString* subString = [readString substringWithRange:NSMakeRange(82*randNum, 81)];
    
    NSMutableArray* grid = [[NSMutableArray alloc] initWithCapacity:9];
    
    for (int i = 0 ; i < 9; i++) {
        NSMutableArray* row = [[NSMutableArray alloc] initWithCapacity:9];
        for (int j = 0 ; j < 9; j++) {
            NSInteger val = [[subString substringWithRange:NSMakeRange((i * 9 + j), 1)] integerValue];
            NSNumber* currentNumber = [NSNumber numberWithInteger:val];
            [row addObject:currentNumber];
        }
        [grid addObject:row];
    }
    return grid;
}

@end
