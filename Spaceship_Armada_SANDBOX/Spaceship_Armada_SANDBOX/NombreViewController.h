//
//  NombreViewController.h
//  Spaceship_Armada_SANDBOX
//
//  Created by Sofia Bonilla on 11/18/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HighscoreList.h"

@interface NombreViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *nombre;
@property (strong, nonatomic) HighscoreList *highscores;

- (IBAction)save:(id)sender;

@end
