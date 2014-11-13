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
@property (assign, nonatomic) NSInteger spawnRate;
@property (assign, nonatomic) NSInteger counter;
@property (assign, nonatomic) NSInteger enemyShootRate;
@property (assign, nonatomic) NSInteger playerShootRate;



@end
