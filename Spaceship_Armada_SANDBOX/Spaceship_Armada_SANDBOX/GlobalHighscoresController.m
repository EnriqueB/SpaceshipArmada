//
//  GlobalHighscoresController.m
//  Spaceship_Armada_SANDBOX
//
//  Created by A01175659 on 12/1/14.
//  Copyright (c) 2014 ITESM. All rights reserved.
//

#import "GlobalHighscoresController.h"

@interface GlobalHighscoresController (){
    NSMutableArray *scores;
    NSDictionary *libro;
}

@end

@implementation GlobalHighscoresController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self cargaDatos];
}
-(void)cargaDatos{
    NSString *miUrl = [[NSString alloc] initWithFormat:@"http://www.pastebin.com/raw.php?i=rKN7dfpX"];
    NSURL *url = [[NSURL alloc]initWithString: miUrl];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:60];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    self.responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    self.responseData=nil;
    self.connection=nil;
    
    UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error en la conexion" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alerta show];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    int statusCode = [httpResponse statusCode];
    NSLog(@"status de conexion %i", statusCode);
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSError *error;
    NSDictionary *datos = [NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&error];
    scores = [datos objectForKey:@"Highscores"];
    if(scores.count == 0){
    }
    else {
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [scores count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GlobalCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell2" forIndexPath:indexPath];
    NSDictionary *object = [scores [indexPath.row] objectForKey:@"Player"];
    cell.nombreLabel.text = [object objectForKey:@"Nombre"];
    cell.scoreLabel.text = [object objectForKey:@"Score"];
    cell.timeLabel.text =[object objectForKey:@"Time"];
    
    
    // Configure the cell...
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
