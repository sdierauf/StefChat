//
//  InboxViewController.m
//  Blast
//
//  Created by Stefan Dierauf on 11/22/13.
//  Copyright (c) 2013 Stefan Dierauf. All rights reserved.
//

#import "InboxViewController.h"
#import <Parse/Parse.h>
#import "ImageViewController.h"

@interface InboxViewController ()
@property (weak, nonatomic) IBOutlet UINavigationItem *showLoggedInAs;

@end

@implementation InboxViewController

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
    self.currentUser = [PFUser currentUser];
    if (!self.currentUser) {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [self reload];
}
- (IBAction)refresh:(id)sender {
    [self reload];
}

- (void)reload {
    NSLog(@"reloading");
    self.currentUser = [PFUser currentUser];
    [self.showLoggedInAs setTitle:[NSString stringWithFormat:@"%@'s inbox", self.currentUser.username]];
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"recipientIds" equalTo:[self.currentUser objectId]];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Mend your nets" message:@"Could not connect to database" delegate:self cancelButtonTitle:@"Yes ma'am" otherButtonTitles: nil];
            [alertView show];
        } else {
            self.messages = objects;
            [self.tableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.messages count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    NSString *cellLabel = [message objectForKey:@"senderName"];
    NSString *secretMessage = [message objectForKey:@"secretMessage"];
    if (secretMessage != nil && secretMessage.length > 0) {
        cellLabel = [cellLabel stringByAppendingString:[NSString stringWithFormat:@": %@", secretMessage]];
    }
    
    //NSLog([message objectForKey:@"secretMessage"]);
    cell.textLabel.text = cellLabel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    NSString *fileType = [message objectForKey:@"fileType"];
    //NSString *secretMessage = [message objectForKey:@"secretMessage"];
    if ([fileType isEqualToString:@"image"]) {
        self.messageToPass = message;
        [self performSegueWithIdentifier:@"showImage" sender:self];
    } else {
        //add video handling code
    }
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:sender];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSLog(@"poop");
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:true];
    } else if ([segue.identifier isEqualToString:@"showImage"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:true];
        ImageViewController *imageViewController = (ImageViewController*)segue.destinationViewController;
        imageViewController.message = self.messageToPass;
        
    }
}
@end
