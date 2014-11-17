//
//  GameViewController.h
//  Spaceship_Armada_SANDBOX
//

//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "HighscoreList.h"

@interface GameViewController : UIViewController
@property (strong, nonatomic) HighscoreList *highscores;
@property (strong, nonatomic) UITextField *nameField;
@property (assign, nonatomic) NSInteger lastGameScore;
@property (strong, nonatomic) SKView *skView;

-(void) transitionToOtherViewController;

@end
