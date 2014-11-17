//
//  GameOverScene.m
//  Spaceship_Armada_SANDBOX
//
//  Created by Sofia Bonilla on 11/15/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "GameOverScene.h"

@implementation GameOverScene: SKScene

-(id)initWithSize:(CGSize)size score:(NSInteger)player_score{
    
    if(self = [super initWithSize:size]){
        SKSpriteNode *sn = [SKSpriteNode spriteNodeWithImageNamed:@"background.png"];
        sn.size = self.frame.size;
        sn.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        sn.name = @"background";
        [self addChild:sn];
        
        NSString *msg = @"Game Over";
        SKLabelNode *l = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
        l.text = msg;
        l.fontSize=40;
        l.fontColor = [SKColor whiteColor];
        l.position = CGPointMake(self.size.width/2, self.size.height/2 +70);
        [self addChild:l];
        
        UITextField *nombre = [[UITextField alloc] initWithFrame:CGRectMake(self.size.width/2, self.size.height/2+10, 200, 40)];
        nombre.center = self.view.center;
        nombre.font = [UIFont systemFontOfSize:17];
        nombre.borderStyle = UITextBorderStyleRoundedRect;
        nombre.placeholder = @"Ingresa tu nombre";
        nombre.clearButtonMode = UITextFieldViewModeWhileEditing;
        //nombre.delegate = self.delegate;
        [self.view addSubview:nombre];
        
         
    }
    return self;
}

@end
