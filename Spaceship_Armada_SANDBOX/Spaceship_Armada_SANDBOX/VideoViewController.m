//
//  VideoViewController.m
//  Spaceship_Armada_SANDBOX
//
//  Created by A01175659 on 12/1/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "VideoViewController.h"

@interface VideoViewController ()

@end

@implementation VideoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)playVideo:(id)sender {
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(110, 420, 550, 550)];
    
    NSString *embedHTML = [NSString stringWithFormat:@"\
                           <html>\
                           <body style='margin:0px;padding;0px'>\
                           <script type='text/javascript' src='http://www.youtube.com/iframe_api'> </script>\
                           <script type='text/javascript'>\
                           function onYouTubeIframeAPIReady()\
                           {\
                           ytplayer=new YT.Player('playerId', {events:{onReady:onPlayerReady}})\
                           }\
                           function onPlayerRead(a)\
                           {\
                           a.target.playVideo();\
                           }\
                           </script>\
                           <iframe id='playerId' type='text/html' width='%d' height='%d' src='http://www.youtube.com/embed/%@?enablejspai=1&rel=0&playsinline=1&autoplay=1' frameborder='0'>\
                           </body>\
                           </html>", 1000, 1000, @"Lb5zFZtv95g"];
    
    [webView setAllowsInlineMediaPlayback:YES];
    [webView setMediaPlaybackRequiresUserAction:NO];
    [webView loadHTMLString:embedHTML baseURL:nil];
    webView.scalesPageToFit = YES;
    [self.view addSubview:webView];
}
@end
