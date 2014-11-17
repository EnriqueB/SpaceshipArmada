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
static const uint32_t enemyBulletCategory = 0x1<<3;
CGMutablePathRef path1;
CGMutablePathRef path2;
CGMutablePathRef path3;
@implementation GameScene

-(void)didMoveToView:(SKView *)view {
    //self.physics
    if(!_contentCreated){
        [self createSceneContents];
        _contentCreated=TRUE;
    }
}
-(void)createSceneContents{
    [self createPaths];
    
    _score = 0;
    _counter=0;
    _spawnRate=50;
    _enemyShootRate=500;
    _playerShootRate=200;
    
    SKSpriteNode *sn = [SKSpriteNode spriteNodeWithImageNamed:@"background.png"];
    sn.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    sn.name = @"background";
    [self addChild:sn];
    
    _scoreNode = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    _scoreNode.text=[NSString stringWithFormat:@"Score: %ld",(long)_score];
    _scoreNode.fontSize = 30;
    _scoreNode.position = CGPointMake(self.size.width-140, self.size.height-30);
    [self addChild:_scoreNode];
    
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate=self;
    
    self.backgroundColor = [SKColor blackColor];
    self.scaleMode = SKSceneScaleModeAspectFit;
    SKTexture *texture = [SKTexture textureWithImageNamed:@"navePrincipal.png"];
    texture.filteringMode = SKTextureFilteringNearest;
    
    
    SKSpriteNode *jugador = [SKSpriteNode spriteNodeWithTexture:texture];
    jugador.name = @"jugador";
    jugador.position = CGPointMake(300, 100);
    jugador.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:jugador.size];
    jugador.physicsBody.categoryBitMask = playerCategory;
    jugador.physicsBody.collisionBitMask = enemyCategory;
    jugador.physicsBody.contactTestBitMask = enemyCategory;
    
    
    SKAction *wait = [SKAction waitForDuration:_playerShootRate/100];
    SKAction *shoot = [self shootMethod:YES posX:jugador.position.x posY:jugador.position.y+jugador.size.height/2+5];
    SKAction *seq = [SKAction sequence:@[wait, shoot]];
    SKAction *repeatShoot = [SKAction repeatActionForever:seq];
    [jugador runAction:repeatShoot];
    
    [self addChild: jugador];
}
-(void)createPaths{
    path1=CGPathCreateMutable();
    CGPathMoveToPoint(path1, NULL, 0, 0);
    CGPathAddArc(path1, NULL, 100, 0, 100, M_PI, -M_PI_2, FALSE);
    CGPathAddArc(path1, NULL, 100, -200, 100, M_PI_2, -M_PI_2, TRUE);
    CGPathAddArc(path1, NULL, 100, -400, 100, M_PI_2, M_PI, FALSE);
    
}
static inline CGFloat skRandf(){
    return rand()/(CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high){
    return skRandf()*(high-low)+low;
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
-(void) gameOver{
    _spawnRate = 0;
    [self enumerateChildNodesWithName:@"enemigo" usingBlock:^(SKNode *node, BOOL *stop){
        //if(node.position.y<0)
        [node removeFromParent];
    }];
    [self enumerateChildNodesWithName:@"bala" usingBlock:^(SKNode *node, BOOL *stop){
        //if(node.position.y<0)
        [node removeFromParent];
    }];
    
    self.gameOverBlock(_score);
}
-(void)didBeginContact:(SKPhysicsContact*)contact{
    uint32_t bitMaskA = contact.bodyA.categoryBitMask;
    uint32_t bitMaskB = contact.bodyB.categoryBitMask;
    
    //Check if player contacted with an enemy
    
    if(([contact.bodyA.node.name isEqualToString:@"jugador"] && bitMaskB == enemyCategory) || ([contact.bodyB.node.name isEqualToString:@"jugador"] && bitMaskA == enemyCategory)){
        
        //game over
        [self gameOver];
    }
    
    if(([contact.bodyA.node.name isEqualToString:@"jugador"] && bitMaskB == enemyBulletCategory) || ([contact.bodyB.node.name isEqualToString:@"jugador"] && bitMaskA == enemyBulletCategory)){
        
        //game over
        [self gameOver];
    }
    
    if(([contact.bodyA.node.name isEqualToString:@"balaJugador"] && bitMaskB == enemyCategory) || ([contact.bodyB.node.name isEqualToString:@"balaJugador"] && bitMaskA == enemyCategory)){
        SKNode *A = contact.bodyA.node;
        SKNode *B = contact.bodyB.node;
        [A removeFromParent];
        [B removeFromParent];
        _score+=100;
    }
    
    
    /*
    // Check if bullet has a contact
    if (((bitMaskA & playerCategory) != 0 && (bitMaskB & enemyCategory)) != 0 ||
        ((bitMaskB & playerCategory) != 0 && (bitMaskA & enemyCategory)) != 0)
    {
        SKNode *goodGuy;
        SKNode *badGuy;
        if ([contact.bodyA.node.name isEqualToString: @"jugador"])
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
     */
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins
    
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
     */
     
}
-(SKAction *)shootMethod:(BOOL )player posX:(float)X posY:(float)Y{
    SKAction *shoot = [SKAction runBlock:^{
        SKTexture *text;
        SKAction *move;
        if(!player)
            text = [SKTexture textureWithImageNamed:@"bullet1.png"];
        else
            text=[SKTexture textureWithImageNamed:@"bullet2_red.png"];
        text.filteringMode = SKTextureFilteringNearest;
        SKSpriteNode *bala = [SKSpriteNode spriteNodeWithTexture:text];
        bala.position = CGPointMake(X, Y);
        //SKAction *move = [SKAction moveByX:0 y:-55 duration:1];
        if(!player)
            move = [SKAction followPath:path1 asOffset:YES orientToPath:NO duration:5];
        else
            move = [SKAction moveByX:0 y:55 duration:.7];
        if(!player)
            bala.name=@"bala";
        else
            bala.name=@"balaJugador";
        bala.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:bala.size];
        //bala.physicsBody.dynamic = NO;
        if(!player){
            bala.physicsBody.categoryBitMask = enemyBulletCategory;
            bala.physicsBody.collisionBitMask = playerCategory;
            bala.physicsBody.contactTestBitMask = playerCategory;
        }
        else{
            bala.physicsBody.categoryBitMask = bulletPlayerCategory;
            bala.physicsBody.collisionBitMask = enemyCategory;
            bala.physicsBody.contactTestBitMask = enemyCategory;
        }
        [bala runAction:[SKAction repeatActionForever:move]];
        [self addChild:bala];
    }];
    return shoot;
}
-(void) spawn{
    SKTexture *texture = [SKTexture textureWithImageNamed:@"naveEnemiga.png"];
    texture.filteringMode = SKTextureFilteringNearest;
    SKSpriteNode *enemigo = [SKSpriteNode spriteNodeWithTexture:texture];
    enemigo.position = CGPointMake(skRand(-100, self.size.width-100), self.size.height);
    enemigo.name = @"enemigo";
    
    enemigo.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:enemigo.size];
    enemigo.physicsBody.dynamic = NO;
    enemigo.physicsBody.categoryBitMask = enemyCategory;
    enemigo.physicsBody.collisionBitMask = playerCategory | bulletPlayerCategory;
    enemigo.physicsBody.contactTestBitMask = playerCategory | bulletPlayerCategory;
    
    //SKAction *movement = [SKAction moveByX:0 y:-15 duration:1];
    SKAction *movement = [SKAction followPath:path1 asOffset:YES orientToPath:NO duration:10];
    SKAction *wait = [SKAction waitForDuration:_enemyShootRate/100+(skRand(0, 3)-3)];
    SKAction *shoot = [self shootMethod:NO posX:enemigo.position.x posY:enemigo.position.y-enemigo.size.height/2-5];
    
    SKAction *seq = [SKAction sequence:@[wait, shoot]];
    SKAction *repeatShoot = [SKAction repeatActionForever:seq];
    SKAction *repeatMove = [SKAction repeatActionForever:movement];
    SKAction *group = [SKAction group:@[repeatMove, repeatShoot]];
    [enemigo runAction:group];
    [self addChild:enemigo];
    
}
-(void)update:(CFTimeInterval)currentTime {
    _counter++;

    if(_counter%5==0)
        _score++;
    _scoreNode.text=[NSString stringWithFormat:@"Score: %d",_score];
    if(_counter==_spawnRate){
        [self spawn];
        _counter=0;
    }
}

@end
