//
//  KMViewController.h
//  sudoku
//
//  Created by Kevin McSwiggen on 9/15/14.
//  Copyright (c) 2014 Kevin McSwiggen. All rights reserved.
//

#import <UIKit/UIKit.h>

@import AVFoundation;

@interface KMViewController : UIViewController<UIAlertViewDelegate>
@property (strong, nonatomic) AVAudioPlayer* backgroundMusicPlayer;
- (void)resetGame;

@end
