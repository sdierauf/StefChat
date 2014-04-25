//
//  CameraViewController.m
//  StefChat
// 
//  Created by Stefan Dierauf on 11/24/13.
//  Copyright (c) 2013 Stefan Dierauf. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface CameraViewController ()

@end

@implementation CameraViewController

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
    
    self.recipients = [[NSMutableArray alloc] init];


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.friendsRelation = [self.currentUser objectForKey:@"friendsRelation"];

    self.currentUser = [PFUser currentUser];
    
    NSLog(@"camera viewwillappear was called");
    
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"there was an error" delegate:nil cancelButtonTitle:@"ok?" otherButtonTitles:nil];
            [alertView show];
        } else {
            self.friends = objects;
            [self.tableView reloadData];
            NSLog(@"friends loaded: %@", self.friends);
        }
    }];
    
    if (self.image == nil && [self.videoFilePath length] == 0) {
        self.imagePicker = [[UIImagePickerController alloc] init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing = NO;
        self.imagePicker.videoMaximumDuration = 15;
        
        if ([UIImagePickerController isSourceTypeAvailable:self.imagePicker.sourceType]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //want to disable video taking image picker until it's supported.
        } else {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
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
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.friends count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cameraFriendsList";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if ([self.recipients containsObject:user.objectId]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryNone) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.recipients addObject:user.objectId];
        NSLog(@"added %@ to recip", user.username);
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [self.recipients removeObject:user.objectId];
        NSLog(@"removed %@ from recip", user.username);
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

#pragma mark - imagepickercontroller delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.tabBarController setSelectedIndex:0];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString: (NSString *)kUTTypeImage]) {
        //photo taken or selected
        self.image = [info objectForKey:UIImagePickerControllerOriginalImage];
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
    } else {
        //video taken
        self.videoFilePath = CFBridgingRelease([[info objectForKey:UIImagePickerControllerMediaURL] path]);
        if (self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath)) {
                UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);

            }
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)cancel:(id)sender {
    [self reset];
    [self.tabBarController setSelectedIndex:0]; //lel this is so hacky
    [self.tabBarController setSelectedIndex:2];
    //basically goes to inbox view and then imediately to the reset camera tab
    //wasn't putting up the camera modal before.
    //this is probably bad but yolot
}

- (IBAction)send:(id)sender {
    if (self.image == nil && [self.videoFilePath length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Whoopsie!" message:@"looks like you forgot to take a photo or a video" delegate:self cancelButtonTitle:@"Fuck!" otherButtonTitles:nil];
        [alertView show];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    } else {
        //we can send it
        [self uploadMessage];
        [self.tabBarController setSelectedIndex:0];
    }
}

- (void)reset {
    self.image = nil;
    self.videoFilePath = nil;
    self.messageField.text = nil;
    [self.recipients removeAllObjects];
}

- (void)uploadMessage {
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
    NSString *secretMessage = self.messageField.text;
    //check if image
        //shrink image
        //upload file
    if (self.image != nil) {
        UIImage *resizedImage = [self resizeImage:self.image toWidth:(self.image.size.width / 4) andHeight:(self.image.size.height / 4)];
        
        fileData = UIImageJPEGRepresentation(resizedImage, 0.50);
        fileName = @"image.png";
        fileType = @"image";
        
    } else {
        fileData = [NSData dataWithContentsOfFile:self.videoFilePath];
        fileName = @"video.mov";
        fileType = @"video";
        UIAlertView *videoNotSupport = [[UIAlertView alloc] initWithTitle:@"Oops" message:@"Video isn't supported yet!" delegate:self cancelButtonTitle:@"Fuck!" otherButtonTitles:nil];
        [videoNotSupport show];
        [self reset];
    }
    
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"AVAST!" message:@"Please try sending your message again" delegate:self cancelButtonTitle:@"AYE AYE!" otherButtonTitles: nil];
            [alertView show];
        } else {
            //TODO prompt for a message
            PFObject *message = [PFObject objectWithClassName:@"Messages"];
            [message setObject:file forKey:@"file"];
            [message setObject:fileType forKey:@"fileType"];
            [message setObject:self.recipients forKey:@"recipientIds"];
            [message setObject:[self.currentUser objectId] forKey:@"senderId"];
            [message setObject:[self.currentUser username] forKey:@"senderName"];
            [message setObject:secretMessage forKey:@"secretMessage"];
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"AVAST!" message:@"Please try sending your message again" delegate:self cancelButtonTitle:@"AYE AYE!" otherButtonTitles: nil];
                    [alertView show];
                } else {
                    //everything worked!
                    [self reset];
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"WILLIKERS!" message:@"EVERYTHING WORKED!" delegate:self cancelButtonTitle:@"Fantastic!" otherButtonTitles: nil];
                    [alertView show];
                }
            }];
        }
    }];
    
}

//Creates a resized image and returns it
- (UIImage *)resizeImage:(UIImage *)original toWidth:(float)width andHeight:(float)height {
    CGSize newSize = CGSizeMake(width, height);
    CGRect newRect = CGRectMake(0, 0, width, height);
    UIGraphicsBeginImageContext(newSize);
    [self.image drawInRect:newRect];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resizedImage;
}

//todo limit number of characters in message string. 

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return (newLength > 5) ? NO : YES;
}


@end
