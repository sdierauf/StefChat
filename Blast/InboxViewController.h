//
//  InboxViewController.h
//  Blast
//
//  Created by Stefan Dierauf on 11/22/13.
//  Copyright (c) 2013 Stefan Dierauf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface InboxViewController : UITableViewController
- (IBAction)logout:(id)sender;
@property (nonatomic, strong)PFUser *currentUser;

@property (nonatomic, strong)NSArray *messages;
@property (nonatomic, strong)PFObject *messageToPass;

@end
