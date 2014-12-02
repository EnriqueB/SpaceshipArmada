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

- (IBAction) hideKeybooard:(id) sender {
    [sender resignFirstResponder];
}


- (IBAction)save:(id)sender {
    if(_highscores.foto ==nil) {
        UIImage *img = [UIImage imageNamed:@"unknown_user.png"];
        _highscores.foto = img;
    }
    if(![_nombre.text  isEqual: @""]){
        _highscores.playerName = _nombre.text;
    }
    else{
        _highscores.playerName = @"Commander";
    }
}

- (IBAction)tomarFoto:(id)sender {
    BOOL isCameraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    if(isCameraAvailable) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
        
    } else {
        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Error" message:@"El dispositivo no tiene camara" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alerta show];
    }
}

#pragma mark UIImagePickerControllerDelegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    if(image == nil) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
    _highscores.foto = image;
    
    if([picker sourceType] == UIImagePickerControllerSourceTypeCamera) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) image:(UIImage *) image didFinishSavingWithError:(NSError *)error contextInfo:(void *) contextInfo {
    if(error) {
        UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Saved failed" message:@"Failed to save image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alerta show];
    }
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
