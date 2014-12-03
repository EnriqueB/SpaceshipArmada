//
//  GameViewController.m
//  Spaceship_Armada_SANDBOX
//
//  Created by Sofia Bonilla on 10/22/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden= YES;
    
    // Configure the view.
    _skView = (SKView *)self.view;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    _skView.ignoresSiblingOrder = YES;
    _skView.autoresizesSubviews = YES;
    
    // Create and configure the scene.
    GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    __weak GameViewController *weakSelf = self;
    scene.gameOverBlock = ^(NSInteger score, NSInteger game_time){
        [weakSelf gameOverWithScore:score time:game_time];
    };
    // Present the scene.
    [_skView presentScene:scene];
}

-(void)gameOverWithScore:(NSInteger)score time:(NSInteger)t{
    [_skView removeFromSuperview];
    _lastGameScore = score;
    [self setHighscores:[HighscoreList getSharedInstance]];
    [_highscores agregar:_highscores.playerName score:_lastGameScore time:t foto:_highscores.foto];
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController popToRootViewControllerAnimated:NO];
}
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)transitionToOtherViewController{
    
}

@end
