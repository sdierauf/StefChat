//
//  CameraViewController.h
//  StefChat
//
//  Created by Stefan Dierauf on 11/24/13.
//  Copyright (c) 2013 Stefan Dierauf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CameraViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong)UIImagePickerController *imagePicker;
@property (nonatomic, strong)UIImage *image;
@property (nonatomic, strong)NSString *videoFilePath;

@property (weak, nonatomic) IBOutlet UITextField *messageField;

@property (nonatomic, strong)PFUser *currentUser;
@property (nonatomic, strong)PFRelation *friendsRelation;
@property (nonatomic, strong)NSArray *friends;
@property (strong, nonatomic) IBOutlet UITableView *secretMessageView;

@property (nonatomic, strong)NSMutableArray *recipients;

- (IBAction)cancel:(id)sender;
- (IBAction)send:(id)sender;
- (void)uploadMessage;
- (UIImage*)resizeImage:(UIImage*)original toWidth:(float)width andHeight:(float)height;

@end
