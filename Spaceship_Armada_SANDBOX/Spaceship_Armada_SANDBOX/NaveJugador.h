//
//  NaveJugador.h
//  Spaceship_Armada_SANDBOX
//
//  Created by Sofia Bonilla on 11/6/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "ContenedorBala.h"

@interface NaveJugador : SKScene
@property(assign, nonatomic) NSInteger posX;
@property(assign, nonatomic) NSInteger posY;
@property(strong, nonatomic) NSString *spriteName;
@property(assign, nonatomic) NSInteger sp;
@property(strong, nonatomic) ContenedorBala *container;

-(id)initWithData:(NSInteger)X posY:(NSInteger)Y Sprite:(NSString*)sprite Speed:(NSInteger)sp;
-(void)shoot;
-(void)move;
@end
