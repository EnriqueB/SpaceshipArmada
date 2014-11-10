//
//  GameScene.h
//  Spaceship_Armada_SANDBOX
//

//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "NaveEnemiga.h"
#import "NaveJugador.h"
#import "Bala.h"
#import "ContenedorBala.h"

@interface GameScene : SKScene
@property (strong, nonatomic) NaveJugador *jugador;
@property (strong, nonatomic) NSMutableArray *enemigos;
@property (strong, nonatomic) ContenedorBala *container;

-(void)checkCollision;

@end
