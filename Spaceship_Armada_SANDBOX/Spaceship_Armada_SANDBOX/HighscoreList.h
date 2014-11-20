//
//  ContenedorBala.h
//  Spaceship_Armada_SANDBOX
//
//  Created by Sofia Bonilla on 11/6/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bala.h"
@interface HighscoreList : NSObject
@property (strong, nonatomic) NSMutableArray *arregloHighscores;
@property (strong, nonatomic) NSString *playerName;
@property (assign, nonatomic) BOOL initialized;

+(HighscoreList*)getSharedInstance;
-(void) agregar:(NSString*)nombre score:(NSInteger)sc time:(NSInteger)t;
-(void) initStuff;
@end
