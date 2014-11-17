//
//  GameScene.h
//  Spaceship_Armada_SANDBOX
//

//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "HighscoreList.h"
#import "GameViewController.h"

@interface GameScene : SKScene <SKPhysicsContactDelegate>
@property (assign, nonatomic) NSInteger spawnRate;
@property (assign, nonatomic) NSInteger counter;
@property (assign, nonatomic) NSInteger enemyShootRate;
@property (assign, nonatomic) NSInteger playerShootRate;
@property (assign, nonatomic) NSInteger score;
@property (strong, nonatomic) SKLabelNode *scoreNode;
@property (nonatomic, copy) void(^gameOverBlock)(NSInteger score);



@end
