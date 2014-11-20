//
//  NombreViewController.m
//  Spaceship_Armada_SANDBOX
//
//  Created by Sofia Bonilla on 11/18/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "NombreViewController.h"

@interface NombreViewController ()

@end

@implementation NombreViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setHighscores:[HighscoreList getSharedInstance]];
    [_highscores initStuff];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)save:(id)sender {
    if(![_nombre.text  isEqual: @""]){
        _highscores.playerName = _nombre.text;
    }
    else{
        _highscores.playerName = @"Commander";
    }
}
@end
