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

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    _skView = (SKView *)self.view;
    _skView.showsFPS = YES;
    _skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    _skView.ignoresSiblingOrder = YES;
    _skView.autoresizesSubviews = YES;
    
    // Create and configure the scene.
    GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    __weak GameViewController *weakSelf = self;
    scene.gameOverBlock = ^(NSInteger score){
        [weakSelf gameOverWithScore:score];
    };
    // Present the scene.
    [_skView presentScene:scene];
}

-(void)gameOverWithScore:(NSInteger)score{
    [_skView removeFromSuperview];
    _lastGameScore = score;
    [self setHighscores:[HighscoreList getSharedInstance]];
    [_highscores initStuff];
    /*
    //self.view.backgroundColor =
    _nameField = [[UITextField alloc] initWithFrame:CGRectMake(300, 300, 300, 60)];
    _nameField.font = [UIFont systemFontOfSize:17];
    _nameField.placeholder = @"Enter your name";
    //nameField.delegate = self;
    [self.view addSubview:_nameField];
    [self.view bringSubviewToFront:_nameField];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(continueMethod:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Save" forState:UIControlStateNormal];
    button.frame = CGRectMake(300, 200, 160, 40);
    [self.view addSubview:button];
    [self.view bringSubviewToFront:button];
    */
    [_highscores agregar:@".." score:_lastGameScore];
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
