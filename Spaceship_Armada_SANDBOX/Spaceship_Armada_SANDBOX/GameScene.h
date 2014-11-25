//
//  GameScene.h
//  Spaceship_Armada_SANDBOX
//

//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>
#import "HighscoreList.h"
#import "GameViewController.h"

@interface GameScene : SKScene <SKPhysicsContactDelegate>
@property (assign, nonatomic) NSInteger spawnRate;
@property (assign, nonatomic) NSInteger counter;
@property (assign, nonatomic) NSInteger enemyShootRate;
@property (assign, nonatomic) NSInteger playerShootRate;
@property (assign, nonatomic) NSInteger score;
@property (assign, nonatomic) NSInteger time;
@property (assign, nonatomic) NSInteger timeCounter;
@property (assign, nonatomic) NSInteger counterPlayer;
@property (assign, nonatomic) BOOL gameOver;
@property (strong, nonatomic) SKLabelNode *scoreNode;
@property (nonatomic, copy) void(^gameOverBlock)(NSInteger score, NSInteger game_time);



@end
