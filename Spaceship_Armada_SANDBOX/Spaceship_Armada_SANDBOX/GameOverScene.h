//
//  GameOverScene.h
//  Spaceship_Armada_SANDBOX
//
//  Created by Sofia Bonilla on 11/15/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "GameViewController.h"
@interface GameOverScene : SKScene
@property (nonatomic, copy) void(^gameOverBlock);

-(id) initWithSize:(CGSize)size score:(NSInteger)player_score;
@end
