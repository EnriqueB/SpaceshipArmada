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
        _arregloHighscores =[[NSMutableArray alloc] init];
        _initialized = TRUE;
    }
}
-(void)agregar:(NSString *)nombre score:(NSInteger)sc time:(NSInteger)t{
    NSDictionary *obj = [[NSDictionary alloc]initWithObjectsAndKeys:nombre, @"nombre", [NSNumber numberWithInteger:sc], @"score", [NSNumber numberWithInteger:t], @"time", nil];
    [_arregloHighscores addObject:obj];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"score" ascending:NO];
    NSArray *tempArray = [_arregloHighscores sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    _arregloHighscores = [NSMutableArray arrayWithArray:tempArray];
}
@end
