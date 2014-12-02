//
//  ContenedorBala.m
//  Spaceship_Armada_SANDBOX
//
//  Created by Sofia Bonilla on 11/6/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "HighscoreList.h"

@implementation HighscoreList

+(HighscoreList*)getSharedInstance{
    static HighscoreList *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        
        _sharedInstance = [[HighscoreList alloc] init];
    });
    return _sharedInstance;
}
-(void)initStuff{
    if(!_initialized){
        _contentCreated = FALSE;
        _arregloHighscores =[[NSMutableArray alloc] init];
        _initialized = TRUE;
        [self initWithDatabaseFilename:@"localHighscores.db"];
        [self crearDB];
        //obtain list of highscores
        
        sqlite3_stmt *statement;
        UIImage *foto;
        NSString *selectSql = @"SELECT * FROM LIMAGENES";
        sqlite3_stmt *statement2;
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM LHIGHSCORES"];
        const char *query_statement = [querySQL UTF8String];
        if(sqlite3_prepare_v2(self.lHighscoresDB, query_statement, -1, &statement, NULL) == SQLITE_OK && sqlite3_prepare_v2(self.lHighscoresDB, [selectSql UTF8String], -1, &statement2, NULL) == SQLITE_OK){
            NSLog(@"findProfile: %s", sqlite3_errmsg(self.lHighscoresDB));
            while(sqlite3_step(statement) == SQLITE_ROW && sqlite3_step(statement2) == SQLITE_ROW ) {
                char *field1 = (char *) sqlite3_column_text(statement,1);
                NSString *field1Str = [[NSString alloc] initWithUTF8String: field1];
                int field2 = (int) sqlite3_column_int(statement,2);
                //NSString *field2Str = [[NSString    alloc] initWithUTF8String: field2];
                //cargar Imagen como BLOB
                int field3 = (int) sqlite3_column_int(statement, 3);
                int length = sqlite3_column_bytes(statement2, 0);
                NSData *imageData = [NSData dataWithBytes:sqlite3_column_blob(statement2, 0 ) length:length];
                foto = [UIImage imageWithData:imageData];
                sqlite3_finalize(statement2);
                
                NSDictionary *obj = [[NSDictionary alloc]initWithObjectsAndKeys:field1Str, @"nombre", [NSNumber numberWithInteger:field2], @"score", [NSNumber numberWithInteger:field3], @"time", foto, @"foto", nil];
                
                [_arregloHighscores addObject:obj];
            }
            sqlite3_finalize(statement);
        }
        
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
        NSArray *tempArray = [_arregloHighscores sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
        _arregloHighscores = [NSMutableArray arrayWithArray:tempArray];
        
        
    }
}
-(void) initWithDatabaseFilename:(NSString *)dbFilename{
    if(self){
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        self.databaseFilename = dbFilename;
        self.databasePath = [[NSString alloc] initWithString:[self.documentsDirectory stringByAppendingPathComponent:dbFilename]];
    }
}

-(BOOL) crearDB{
    BOOL error = false;
    sqlite3 *highscoreDB_local;
    self.status=@"OK";
    NSFileManager *fileM = [NSFileManager defaultManager];
    if([fileM fileExistsAtPath:self.databasePath]== NO){
        const char *dbpath = [self.databasePath UTF8String];
        if(sqlite3_open(dbpath, &highscoreDB_local)==SQLITE_OK){
            char *msg;
            self.lHighscoresDB = highscoreDB_local;
            const char *sql_statement = "CREATE TABLE IF NOT EXISTS LHIGHSCORES(ID INTEGER PRIMARY KEY AUTOINCREMENT, NAME TEXT, SCORE INTEGER, TIME INTEGER)";
            if(sqlite3_exec(self.lHighscoresDB, sql_statement, NULL, NULL, &msg) != SQLITE_OK){
                error= true;
                self.status = @"Failed to create table";
                NSLog(@"CrearDB: %s",sqlite3_errmsg(self.lHighscoresDB));
                
            }
            const char *sql_statement2 = "CREATE TABLE IF NOT EXISTS LIMAGENES(IMAGE BLOB)";
            if(sqlite3_exec(self.lHighscoresDB, sql_statement2, NULL, NULL, &msg) != SQLITE_OK){
                error= true;
                self.status = @"Failed to create table";
                NSLog(@"CrearDB: %s",sqlite3_errmsg(self.lHighscoresDB));
                
            }
            
            return error;
        }
        else{
            error=true;
            self.status = @"Failed to open/create database";
        }
    }
    if(sqlite3_open([self.databasePath UTF8String], &highscoreDB_local) == SQLITE_OK){
        self.lHighscoresDB = highscoreDB_local;
    }
    return error;
}

-(void)agregar:(NSString *)nombre score:(NSInteger)sc time:(NSInteger)t foto:(UIImage *) foto {
    NSDictionary *obj = [[NSDictionary alloc]initWithObjectsAndKeys:nombre, @"nombre", [NSNumber numberWithInteger:sc], @"score", [NSNumber numberWithInteger:t], @"time", foto, @"foto", nil];
    [_arregloHighscores addObject:obj];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    NSArray *tempArray = [_arregloHighscores sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    _arregloHighscores = [NSMutableArray arrayWithArray:tempArray];
    NSString *givenScore = [NSString stringWithFormat:@"%ld", (long)sc];
    
    sqlite3_stmt *sql_statement;
    self.status = @"OK";
    
    NSData *imageData = UIImagePNGRepresentation(foto);
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO LHIGHSCORES (name, score, time) VALUES (\"%@\",\"%@\",\"%@\" )", nombre, givenScore, [NSString stringWithFormat:@"%ld", (long)t]];
    const char *insert_statement = [insertSQL UTF8String];
    if(sqlite3_prepare_v2(self.lHighscoresDB, insert_statement, -1, &sql_statement, NULL) == SQLITE_OK){
        NSString *insertProgrammeSql = @"INSERT INTO LIMAGENES (IMAGE) VALUES (?)";
        sqlite3_stmt *statement;
        if (sqlite3_prepare_v2(self.lHighscoresDB, [insertProgrammeSql cStringUsingEncoding:NSUTF8StringEncoding], -1, &statement, NULL) == SQLITE_OK) {
            sqlite3_bind_blob(statement, 1, [imageData bytes], [imageData length], SQLITE_STATIC);
            int res = SQLITE_ERROR;
            if((res = sqlite3_step(statement)) != SQLITE_DONE)
            {
                sqlite3_reset(statement);
            }
        }
        NSLog(@"Addprofile: %s", sqlite3_errmsg(self.lHighscoresDB));
        if(sqlite3_step(sql_statement)== SQLITE_DONE){
            self.status = @"Highscore added";
        }
        else{
            self.status = @"Failed to add highscore";
        }
        sqlite3_finalize(sql_statement);
    }
   
    for(int i=0; i<_arregloHighscores.count && i<10; i++){
        NSDictionary *obj = _arregloHighscores[i];
        NSString *theScore = [NSString stringWithFormat:@"%@", [obj objectForKey:@"score"]];
        if(([nombre isEqual:[obj objectForKey:@"nombre"]]) && ([theScore isEqual:givenScore])){
            UILocalNotification *localNotification = [[UILocalNotification  alloc] init];
            localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
            localNotification.alertBody = @"Felicidades, tu puntuacion esta dentro de las 10 mejores";
            localNotification.timeZone = [NSTimeZone defaultTimeZone];
            localNotification.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        }
    }
}


@end
