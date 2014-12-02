//
//  GlobalHighscoresController.h
//  Spaceship_Armada_SANDBOX
//
//  Created by A01175659 on 12/1/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalCell.h"

@interface GlobalHighscoresController : UITableViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, nonatomic) NSMutableData *responseData;

@end
