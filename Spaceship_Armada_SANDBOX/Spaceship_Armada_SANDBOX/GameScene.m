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
CMMotionManager *motionManager;
@implementation GameScene
#define playerSpeed 250;

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
    _time=0;
    
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
    
    motionManager = [[CMMotionManager alloc]init];
    if([motionManager isAccelerometerAvailable] ==YES){
        [motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMAccelerometerData *data, NSError *error)
        {
            float destX, destY;
            float currentX = jugador.position.x;
            float currentY = jugador.position.y;
            BOOL shouldMove = NO;
            if(data.acceleration.y<-0.25){ //tilted to the right
                destX=currentX + data.acceleration.y * playerSpeed;
                destY = currentY;
                shouldMove = YES;
            }
            else if(data.acceleration.y > 0.25){ //tilted to the left
                destX = currentX+ data.acceleration.y * playerSpeed;
                destY = currentY;
                shouldMove = YES;
            }
            if(shouldMove){
                SKAction *action = [SKAction moveTo:CGPointMake(destX, destY) duration:1];
                [jugador runAction:action];
            }
        }];
    }
    
    [self addChild: jugador];
}
-(void)createPaths{
    path1=CGPathCreateMutable();
    CGPathMoveToPoint(path1, NULL, 0, 0);
    CGPathAddArc(path1, NULL, 100, 0, 100, M_PI, -M_PI_2, FALSE);
    CGPathAddArc(path1, NULL, 100, -200, 100, M_PI_2, -M_PI_2, TRUE);
    CGPathAddArc(path1, NULL, 100, -400, 100, M_PI_2, M_PI, FALSE);
    path2=CGPathCreateMutable();
    CGPathMoveToPoint(path2, NULL, 0, 0);
    CGPathAddLineToPoint(path2, NULL, 0, -100);
    CGPathAddLineToPoint(path2, NULL, 150, -100);
    CGPathAddLineToPoint(path2, NULL, 150, -200);
    CGPathAddLineToPoint(path2, NULL, 5, -200);
    
}
static inline CGFloat skRandf(){
    return rand()/(CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high){
    return skRandf()*(high-low)+low;
}
-(void)didSimulatePhysics{
    [self enumerateChildNodesWithName:@"enemigo" usingBlock:^(SKNode *node, BOOL *stop){
        if(skRand(0, _enemyShootRate/10)<2){
            SKAction *shoot = [self shootMethod:NO posX:node.position.x posY:node.position.y-15];
            [node runAction:shoot];
        }
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
    
    self.gameOverBlock(_score, _time);
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
        if(!player){
            CGFloat mov = skRand(0, 2);
            if(mov<1)
                move = [SKAction followPath:path1 asOffset:YES orientToPath:NO duration:5];
            else
                move =  [SKAction moveByX:0 y:-70 duration:1];
        }
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
    enemigo.position = CGPointMake(skRand(40, self.size.width-150), self.size.height);
    enemigo.name = @"enemigo";
    
    enemigo.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:enemigo.size];
    enemigo.physicsBody.dynamic = NO;
    enemigo.physicsBody.categoryBitMask = enemyCategory;
    enemigo.physicsBody.collisionBitMask = playerCategory | bulletPlayerCategory;
    enemigo.physicsBody.contactTestBitMask = playerCategory | bulletPlayerCategory;
    
    //SKAction *movement = [SKAction moveByX:0 y:-15 duration:1];
    CGFloat mov= skRand(0, 3);
    SKAction *movement;
    if(mov<1)
        movement= [SKAction followPath:path1 asOffset:YES orientToPath:NO duration:10];
    else if(mov<2)
        movement = [SKAction followPath:path2 asOffset:YES orientToPath:NO duration:8];
    else
        movement = [SKAction moveByX:0 y:-35 duration:1];
    SKAction *shoot = [self shootMethod:NO posX:enemigo.position.x posY:enemigo.position.y-enemigo.size.height/2-5];
    SKAction *repeatMove = [SKAction repeatActionForever:movement];
    SKAction *group = [SKAction group:@[repeatMove, shoot]];
    [enemigo runAction:group];
    [self addChild:enemigo];
    
}
-(void)update:(CFTimeInterval)currentTime {
    _counter++;
    _timeCounter++;
    
    if(_timeCounter==60){
        _time++;
        if(_time%50==0){
            if(_spawnRate>25)
                _spawnRate-=5;
            if(_enemyShootRate>200)
                _enemyShootRate-=20;
        }
        _timeCounter=0;
    }

    if(_counter%5==0)
        _score++;
    _scoreNode.text=[NSString stringWithFormat:@"Score: %ld",(long)_score];
    if(_counter==_spawnRate){
        [self spawn];
        _counter=0;
    }
}

@end
