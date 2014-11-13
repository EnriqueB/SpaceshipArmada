//
//  GameScene.m
//  Spaceship_Armada_SANDBOX
//
//  Created by Sofia Bonilla on 10/22/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "GameScene.h"

@interface GameScene()
@property BOOL contentCreated;

@end
static const uint32_t playerCategory = 0x1<<0;
static const uint32_t enemyCategory = 0x1<<1;
static const uint32_t bulletPlayerCategory = 0x1<<2;
static const uint32_t EDGE = 0x1<<3;
CGMutablePathRef path1;
CGMutablePathRef path2;
CGMutablePathRef path3;
@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    
    if(!self.contentCreated){
        [self createSceneContents];
        self.contentCreated=TRUE;
    }
}
-(void)createSceneContents{
    [self createPaths];
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.categoryBitMask = EDGE;;
    _counter=0;
    _spawnRate=100;
    _enemyShootRate=500;
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    SKTexture *texture = [SKTexture textureWithImageNamed:@"navePrincipal.png"];
    texture.filteringMode = SKTextureFilteringNearest;
    SKSpriteNode *jugador = [SKSpriteNode spriteNodeWithTexture:texture];
    jugador.name = @"jugador";
    jugador.position = CGPointMake(300, 100);
    jugador.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:jugador.size];
    jugador.physicsBody.dynamic = NO;
    jugador.physicsBody.categoryBitMask = playerCategory;
    jugador.physicsBody.collisionBitMask = enemyCategory | EDGE;
    jugador.physicsBody.contactTestBitMask = enemyCategory;
    SKAction *makeRocks = [SKAction sequence:@[
                                               [SKAction performSelector:@selector(addRock) onTarget:self],
                                               [SKAction waitForDuration:0.10 withRange:0.15]]];
    [self runAction:[SKAction repeatActionForever:makeRocks]];
    //add other stuff
    [self addChild: jugador];
}
-(void)createPaths{
    path1=CGPathCreateMutable();
    CGPathMoveToPoint(path1, NULL, 0, 0);
    CGPathAddArc(path1, NULL, 0, -100, 100, M_PI_2, -M_PI_2, TRUE);
    CGPathAddArc(path1, NULL, 100, -100, 100, M_PI, -M_PI_2, FALSE);
    CGPathAddArc(path1, NULL, 0, -100, 100, M_PI_2, M_PI, FALSE);
    
}
static inline CGFloat skRandf(){
    return rand()/(CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high){
    return skRandf()*(high-low)+low;
}
-(void) addRock{
    SKSpriteNode *rock = [[SKSpriteNode alloc] initWithColor:[SKColor brownColor] size:CGSizeMake(8, 8)];
    rock.position = CGPointMake(skRand(0, self.size.width), self.size.height);
    rock.name = @"rock";
    rock.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rock.size];
    rock.physicsBody.usesPreciseCollisionDetection=YES;
    //[self addChild:rock];
    
    
}
-(void)didSimulatePhysics{
    [self enumerateChildNodesWithName:@"enemigo" usingBlock:^(SKNode *node, BOOL *stop){
        if(node.position.y<0)
            [node removeFromParent];
    }];
    [self enumerateChildNodesWithName:@"bala" usingBlock:^(SKNode *node, BOOL *stop){
        if(node.position.y<0)
            [node removeFromParent];
    }];
}
-(void)didBeginContact:(SKPhysicsContact*)contact{
    uint32_t bitMaskA = contact.bodyA.categoryBitMask;
    uint32_t bitMaskB = contact.bodyB.categoryBitMask;
    
    // Check if your object have a contact
    if (((bitMaskA & playerCategory) != 0 && (bitMaskB & enemyCategory)) != 0 ||
        ((bitMaskB & playerCategory) != 0 && (bitMaskA & enemyCategory)) != 0)
    {
        SKNode *goodGuy;
        SKNode *badGuy;
        if ([contact.bodyA.node.name isEqualToString: @"goodGuy"])
        {
            goodGuy = contact.bodyA.node;
            badGuy = contact.bodyB.node;
        }
        else
        {
            badGuy = contact.bodyA.node;
            goodGuy = contact.bodyB.node;
        }
        
        // Logic for your game
        [badGuy removeFromParent];
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins*/
    
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        
        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"bullet1.png"];
        
        sprite.xScale = 1;
        sprite.yScale = 1;
        sprite.position = location;
        
        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
        
        [sprite runAction:[SKAction repeatActionForever:action]];
        
        [self addChild:sprite];
     }
     
}
-(void) spawn{
    SKTexture *texture = [SKTexture textureWithImageNamed:@"naveEnemiga.png"];
    texture.filteringMode = SKTextureFilteringNearest;
    SKSpriteNode *enemigo = [SKSpriteNode spriteNodeWithTexture:texture];
    enemigo.position = CGPointMake(skRand(140, self.size.width-140), self.size.height+100);
    enemigo.name = @"enemigo";
    
    enemigo.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:enemigo.size];
    enemigo.physicsBody.usesPreciseCollisionDetection=YES;
    enemigo.physicsBody.dynamic = NO;
    enemigo.physicsBody.allowsRotation = NO;
    
    SKAction *wait = [SKAction waitForDuration:_enemyShootRate/100+(skRand(0, 3)-3)];
    //SKAction *movement = [SKAction moveByX:0 y:-15 duration:1];
    SKAction *movement = [SKAction followPath:path1 asOffset:YES orientToPath:NO duration:10];
    SKAction *shoot = [SKAction runBlock:^{
        SKTexture *text = [SKTexture textureWithImageNamed:@"bullet1.png"];
        texture.filteringMode = SKTextureFilteringNearest;
        SKSpriteNode *bala = [SKSpriteNode spriteNodeWithTexture:text];
        bala.position = CGPointMake(enemigo.position.x-(0), enemigo.position.y-enemigo.size.height-5);
        SKAction *move = [SKAction moveByX:0 y:-30 duration:1];
        bala.name=@"bala";
        bala.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bala.size];
        bala.physicsBody.dynamic = NO;
        bala.physicsBody.usesPreciseCollisionDetection=YES;
        bala.physicsBody.categoryBitMask = enemyCategory;
        bala.physicsBody.collisionBitMask = playerCategory;
        bala.physicsBody.contactTestBitMask = playerCategory;
        
        [bala runAction:[SKAction repeatActionForever:move]];
        [self addChild:bala];
    }];
    
    enemigo.physicsBody.categoryBitMask = enemyCategory;
    enemigo.physicsBody.collisionBitMask = playerCategory | bulletPlayerCategory;
    enemigo.physicsBody.contactTestBitMask = playerCategory | bulletPlayerCategory;
    
    SKAction *seq = [SKAction sequence:@[wait, shoot]];
    SKAction *repeatShoot = [SKAction repeatActionForever:seq];
    SKAction *repeatMove = [SKAction repeatActionForever:movement];
    SKAction *group = [SKAction group:@[repeatMove, repeatShoot]];
    [enemigo runAction:group];
    [self addChild:enemigo];
    
}
-(void)update:(CFTimeInterval)currentTime {
    _counter++;
    if(_counter==_spawnRate){
        [self spawn];
        _counter=0;
    }
}

@end
