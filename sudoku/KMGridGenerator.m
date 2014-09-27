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
    int _easyModeProgress;
    int _hardModeProgress;
}

- (id) init
{
    _easyModeProgress = 0;
    _hardModeProgress = 0;
    
    return self;
}

- (NSMutableArray*) getNewGrid:(BOOL)easyMode
{
    NSString* path;
    
    if (easyMode) {
        path = [[NSBundle mainBundle] pathForResource:@"grid1" ofType:@"txt"];
    }
    else {
        path = [[NSBundle mainBundle] pathForResource:@"grid2" ofType:@"txt"];
    }
    
    NSError* error;
    
    NSString* readString = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    NSString* subString = [readString substringWithRange:NSMakeRange(0, 81)];
    
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
