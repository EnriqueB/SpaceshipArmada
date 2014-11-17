//
//  NaveEnemiga.m
//  Spaceship_Armada_SANDBOX
//
//  Created by Sofia Bonilla on 11/6/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "NaveEnemiga.h"

@implementation NaveEnemiga
-(id)initWithData:(NSInteger)X posY:(NSInteger)Y Sprite:(NSString *)sprite Speed:(NSInteger)sp Health:(NSInteger)health{
    _posX = X;
    _posY = Y;
    _spriteName = sprite;
    _sp = sp;
    _health = health;
    [self setContainer:[HighscoreList getSharedInstance]];
    return self;
}
-(void)move{
    _posY+=_sp;
}
@end
