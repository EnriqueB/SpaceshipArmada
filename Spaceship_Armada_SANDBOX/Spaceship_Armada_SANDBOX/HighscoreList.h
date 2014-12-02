//
//  ContenedorBala.h
//  Spaceship_Armada_SANDBOX
//
//  Created by Sofia Bonilla on 11/6/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Bala.h"
@interface HighscoreList : NSObject
@property (strong, nonatomic) NSMutableArray *arregloHighscores;
@property (strong, nonatomic) NSString *playerName;
@property (strong, nonatomic) UIImage *foto;
@property (strong, nonatomic) NSData *imagenBytes;
@property (assign, nonatomic) BOOL initialized;

@property (nonatomic) sqlite3 *lHighscoresDB;

@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;
@property (nonatomic, strong) NSString *databasePath;
@property (assign, nonatomic) BOOL contentCreated;
@property (nonatomic, strong) NSString *status;

-(void) initWithDatabaseFilename:(NSString*)dbFilename;
-(BOOL) crearDB;

+(HighscoreList*)getSharedInstance;
-(void) agregar:(NSString*)nombre score:(NSInteger)sc time:(NSInteger)t foto:(UIImage *) foto;
-(void) initStuff;
@end
