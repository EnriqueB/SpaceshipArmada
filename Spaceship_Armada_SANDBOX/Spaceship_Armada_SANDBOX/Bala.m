//
//  Bala.m
//  Spaceship_Armada_SANDBOX
//
//  Created by Sofia Bonilla on 11/6/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "Bala.h"

@implementation Bala
-(id)initWithData:(NSInteger)X posY:(NSInteger)Y Sprite:(NSString *)sprite Speed:(NSInteger)sp{
    _posX = X;
    _posY = Y;
    _spriteName = sprite;
    _sp = sp;
    return self;
}
@end
