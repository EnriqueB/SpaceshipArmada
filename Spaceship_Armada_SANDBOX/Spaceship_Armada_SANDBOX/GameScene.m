//
//  GameScene.m
//  Spaceship_Armada_SANDBOX
//
//  Created by Sofia Bonilla on 10/22/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "GameScene.h"

@interface GameScene()
@end
static const uint32_t playerCategory = 0x1<<0;
static const uint32_t enemyCategory = 0x1<<1;
static const uint32_t bulletPlayerCategory = 0x1<<2;
static const uint32_t enemyBulletCategory = 0x1<<3;
CGMutablePathRef path1;
CGMutablePathRef path2;
CMMotionManager *motionManager;
@implementation GameScene
#define playerSpeed 80;

-(void)didMoveToView:(SKView *)view {
    //self.physics
    if(!_contentCreated){
        [self createSceneContents];
        
        _contentCreated=TRUE;
    }
}
-(void)createSceneContents{
    [self createPaths];
    srand([[NSDate date] timeIntervalSince1970]);
    _score = 0;
    _counter=0;
    _counterPlayer=0;
    _spawnRate=100;
    _enemyShootRate=2000; //2000
    _playerShootRate=300;
    _time=0;
    _gameOver = FALSE;
    _song = [SKSpriteNode spriteNodeWithImageNamed:@"bullet2."];
    _song.position = CGPointMake(-100, -100);
    SKAction *music = [SKAction repeatActionForever:[SKAction playSoundFileNamed:@"music.mp3" waitForCompletion:YES]];
    [_song runAction:music];
    [self addChild:_song];
    
    SKSpriteNode *sn = [SKSpriteNode spriteNodeWithImageNamed:@"backgroundJuego.png"];
    sn.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
    sn.name = @"background";
    sn.zPosition = -1;
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
    SKTexture *texture = [SKTexture textureWithImageNamed:@"navePrincipal2.png"];
    texture.filteringMode = SKTextureFilteringNearest;
    
    SKTexture *texture2 = [SKTexture textureWithImageNamed:@"Pause.png"];
    texture2.filteringMode=SKTextureFilteringNearest;
    
    SKSpriteNode *pausa = [SKSpriteNode spriteNodeWithTexture:texture2];
    pausa.position = CGPointMake(20, self.size.height-20);
    pausa.name = @"pause";
    [pausa setScale:0.4];
    [self addChild:pausa];
    
    
    SKSpriteNode *jugador = [SKSpriteNode spriteNodeWithTexture:texture];
    jugador.name = @"jugador";
    jugador.position = CGPointMake(300, 100);
    jugador.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(20, 20)];
    jugador.physicsBody.categoryBitMask = playerCategory;
    jugador.physicsBody.collisionBitMask = enemyCategory;
    jugador.physicsBody.contactTestBitMask = enemyCategory;
    
    motionManager = [[CMMotionManager alloc]init];
    if([motionManager isAccelerometerAvailable] ==YES){
        [motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMAccelerometerData *data, NSError *error)
        {
            float destX, destY;
            float currentX = jugador.position.x;
            float currentY = jugador.position.y;
            destX = currentX;
            destY = currentY;
            BOOL shouldMove = NO;
            if(data.acceleration.x<-0.15){ //tilted to the right
                destX=currentX -  playerSpeed;
                shouldMove = YES;
            }
            if(data.acceleration.x > 0.15){ //tilted to the left
                destX = currentX +  playerSpeed;
                shouldMove = YES;
            }
            if(data.acceleration.y<-0.60){ //tilted to the right
                destY=currentY -  playerSpeed;
                shouldMove = YES;
            }
            if(data.acceleration.y > -0.50){ //tilted to the left
                destY = currentY +  playerSpeed;
                shouldMove = YES;
            }
            if(shouldMove){
                if(destY>40 && destY < self.size.height-40 && destX > 40 && destX <self.size.width-40){
                    SKAction *action = [SKAction moveTo:CGPointMake(destX, destY) duration:.5];
                    [jugador runAction:action];
                }
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
    CGPathAddLineToPoint(path2, NULL, 0, -200);
    
}
static inline CGFloat skRandf(){
    return rand()/(CGFloat) RAND_MAX;
}

static inline CGFloat skRand(CGFloat low, CGFloat high){
    return skRandf()*(high-low)+low;
}
-(void)didSimulatePhysics{
    [self enumerateChildNodesWithName:@"enemigo" usingBlock:^(SKNode *node, BOOL *stop){
        CGFloat x =skRand(0, _enemyShootRate/4);
        if(x<2){
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
    [self enumerateChildNodesWithName:@"jugador" usingBlock:^(SKNode *node, BOOL *stop){
        _counterPlayer++;
        if(_counterPlayer==30){
            SKAction *shoot = [self shootMethod:YES posX:node.position.x posY:node.position.y+32];
            [node runAction:shoot];
            _counterPlayer=0;
        }

    }];
}
-(void) gameOverMethod{
    _spawnRate = 0;
    [_song removeAllActions];
    [self removeAllActions];
    [self removeAllChildren];
    _gameOver = TRUE;
    SKNode *message = [SKNode node];
    SKLabelNode *a = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    SKLabelNode *b = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    SKLabelNode *c = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    SKLabelNode *d = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    a.fontSize = 50;
    b.fontSize = 50;
    c.fontSize = 50;
    d.fontSize = 50;
    a.text = [NSString stringWithFormat:@"Game over!"];
    b.text = [NSString stringWithFormat:@"Your score was:"];
    c.text = [NSString stringWithFormat:@"%ld", (long)_score];
    d.text = [NSString stringWithFormat:@"Touch anywhere to return"];
    //a.position = CGPointMake(self.size.width/2, self.size.width/2+200);
    b.position = CGPointMake(b.position.x , b.position.y-100);
    c.position = CGPointMake(c.position.x, c.position.y-200);
    d.position = CGPointMake(d.position.x, d.position.y-300);
    [message addChild:a];
    [message addChild:b];
    [message addChild:c];
    [message addChild:d];
    message.position = CGPointMake(self.size.width/2, self.size.height/2+200);
    [self addChild:message];
    sleep(1);
}
-(void)didBeginContact:(SKPhysicsContact*)contact{
    uint32_t bitMaskA = contact.bodyA.categoryBitMask;
    uint32_t bitMaskB = contact.bodyB.categoryBitMask;
    
    //Check if player contacted with an enemy
    
    if(([contact.bodyA.node.name isEqualToString:@"jugador"] && bitMaskB == enemyCategory) || ([contact.bodyB.node.name isEqualToString:@"jugador"] && bitMaskA == enemyCategory)){
        
        //game over
        [self gameOverMethod];
    }
    
    if(([contact.bodyA.node.name isEqualToString:@"jugador"] && bitMaskB == enemyBulletCategory) || ([contact.bodyB.node.name isEqualToString:@"jugador"] && bitMaskA == enemyBulletCategory)){
        
        //game over
        [self gameOverMethod];
    }
    
    if(([contact.bodyA.node.name isEqualToString:@"balaJugador"] && bitMaskB == enemyCategory) || ([contact.bodyB.node.name isEqualToString:@"balaJugador"] && bitMaskA == enemyCategory)){
        SKNode *A = contact.bodyA.node;
        SKNode *B = contact.bodyB.node;
        [A removeFromParent];
        [B removeFromParent];
        _score+=100;
    }
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if(_gameOver){
        for (UITouch *touch in touches) {
            CGPoint location = [touch locationInNode:self];
            self.gameOverBlock(_score, _time);
        }
    }
    for( UITouch *touch in touches) {
        SKSpriteNode *pause = (SKSpriteNode*)[self childNodeWithName:@"pause"];
        CGPoint location = [touch locationInNode:self];
        if([pause containsPoint:location])
        {
            self.scene.view.paused = !self.scene.view.paused;
        }
    }
    
     
}
-(SKAction *)shootMethod:(BOOL )player posX:(float)X posY:(float)Y{
    SKAction *shoot = [SKAction runBlock:^{
        SKTexture *text;
        SKAction *move;
        if(!player){
            if(skRand(0, 2)<1)
                text = [SKTexture textureWithImageNamed:@"bullet1.png"];
            else
                text = [SKTexture textureWithImageNamed:@"green_bullet.png"];
        }
        else
            text=[SKTexture textureWithImageNamed:@"bullet2_red.png"];
        text.filteringMode = SKTextureFilteringNearest;
        SKSpriteNode *bala = [SKSpriteNode spriteNodeWithTexture:text];
        bala.position = CGPointMake(X, Y);
        if(!player){
            CGFloat mov = skRand(0, 2);
            if(mov<1)
                move = [SKAction followPath:path1 asOffset:YES orientToPath:NO duration:5];
            else
                move =  [SKAction moveByX:0 y:-70 duration:1];
        }
        else
            move = [SKAction moveByX:0 y:60 duration:.5];
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
    CGFloat type = skRand(0, 2);
    SKSpriteNode *enemigo;
    if(type<1){
        SKTexture *texture = [SKTexture textureWithImageNamed:@"naveEnemiga.png"];
        texture.filteringMode = SKTextureFilteringNearest;
        enemigo = [SKSpriteNode spriteNodeWithTexture:texture];
        enemigo.position = CGPointMake(skRand(40, self.size.width-150), self.size.height);
        enemigo.name = @"enemigo";
    }
    else{
        SKTexture *texture = [SKTexture textureWithImageNamed:@"naveEnemiga2.png"];
        texture.filteringMode = SKTextureFilteringNearest;
        enemigo = [SKSpriteNode spriteNodeWithTexture:texture];
        enemigo.position = CGPointMake(skRand(40, self.size.width-150), self.size.height);
        enemigo.name = @"enemigo";
    }
    
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
    if(!_gameOver){
        _counter++;
        _timeCounter++;
        if(_timeCounter==60){ //60
            _time++;
            if(_time%60==0){//60
                if(_spawnRate>15)
                    _spawnRate-=5;
                if(_enemyShootRate>500)
                    _enemyShootRate-=20;
            }
            _timeCounter=0;
        }

        if(_counter%5==0)
            _score++;
        _scoreNode.text=[NSString stringWithFormat:@"Score: %ld",(long)_score];
        if(_counter>=_spawnRate){
            [self spawn];
            _counter=0;
        }
    }
}

@end
