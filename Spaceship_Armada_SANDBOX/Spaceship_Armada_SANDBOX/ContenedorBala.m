//
//  ContenedorBala.m
//  Spaceship_Armada_SANDBOX
//
//  Created by Sofia Bonilla on 11/6/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "ContenedorBala.h"

@implementation ContenedorBala

+(ContenedorBala*)getSharedInstance{
    static ContenedorBala *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        
        _sharedInstance = [[ContenedorBala alloc] init];
    });
    return _sharedInstance;
}
@end
