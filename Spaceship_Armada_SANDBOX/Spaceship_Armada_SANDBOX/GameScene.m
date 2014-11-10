//
//  GameScene.m
//  Spaceship_Armada_SANDBOX
//
//  Created by Sofia Bonilla on 10/22/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    [self setContainer:[ContenedorBala getSharedInstance]];
    /* Setup your scene here */
    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    myLabel.text = @"Hello, World!";
    myLabel.fontSize = 65;
    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                   CGRectGetMidY(self.frame));
    
    [self addChild:myLabel];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
        
        sprite.xScale = 0.5;
        sprite.yScale = 0.5;
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
    }
}
-(void)checkCollision{
    int h1=16, h2=64, w1=16, w2=64;
    CGRect rectJugador = CGRectMake(*(CGFloat*)_jugador.posX, *(CGFloat*)_jugador.posY, *(CGFloat*)h2, *(CGFloat*)w2);
    for(int i=0; i<[_container.arregloBalas count]; i++){
        Bala *b = [_container.arregloBalas objectAtIndex:i];
        CGRect rectBala = CGRectMake((CGFloat)b.posX, (CGFloat)b.posY, (CGFloat)h1, (CGFloat)w1);
        if(b.sp>0){
            //bala enemiga
            if(CGRectIntersectsRect(rectBala, rectJugador)){
                //se intersectaron
                //borrar bala
                //gameover
            }
        }
        if(b.sp<0){
            //bala usuario
            for(int j=0; j<_enemigos.count; j++){
                NaveEnemiga *e = [_enemigos objectAtIndex:j];
                CGRect rectEnemy = CGRectMake((CGFloat)e.posX, (CGFloat)e.posY, (CGFloat)h2, (CGFloat)w2);
                if(CGRectIntersectsRect(rectBala, rectEnemy)){
                    //se intesectaron
                    //borrar bala
                    //reducir vida enemigo
                    //revisar si murio enemigo
                }
            }
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    [self checkCollision];
    //mover objetos
    for(int i=0; i<_enemigos.count; i++){
        NSInteger change = [[_enemigos objectAtIndex:i] posY];
        change+=[[_enemigos objectAtIndex:i] sp];
        [[_enemigos objectAtIndex:i] setPosY:change];
    }
    for(int i=0; i<[_container.arregloBalas count]; i++){
        NSInteger change = [[_container.arregloBalas objectAtIndex:i] posY];
        change+=[[_container.arregloBalas objectAtIndex:i] sp];
        [[_enemigos objectAtIndex:i]setPosY:change];
    }
    /* Called before each frame is rendered */
}

@end
