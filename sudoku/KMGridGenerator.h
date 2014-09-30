//
//  KMGridGenerator.h
//  sudoku
//
//  Created by jarthurcs on 9/26/14.
//  Copyright (c) 2014 Kevin McSwiggen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KMGridGenerator : NSObject

- (NSMutableArray*) getNewGridMode:(BOOL)easyMode;

// Added method for unit testing
- (id) initWithStringEasy:(NSString*)easyGrid Hard:(NSString*)hardGrid;

@end
