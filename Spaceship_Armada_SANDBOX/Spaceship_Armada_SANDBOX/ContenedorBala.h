//
//  ContenedorBala.h
//  Spaceship_Armada_SANDBOX
//
//  Created by Sofia Bonilla on 11/6/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bala.h"
@interface ContenedorBala : NSObject
@property (strong, nonatomic) NSMutableArray *arregloBalas;

+(ContenedorBala*)getSharedInstance;
@end
