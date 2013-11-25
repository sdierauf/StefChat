//
//  EditFriendsViewControllerTableViewController.h
//  Blast
//
//  Created by Stefan Dierauf on 11/23/13.
//  Copyright (c) 2013 Stefan Dierauf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EditFriendsViewController : UITableViewController

@property (nonatomic, strong) NSArray *allUsers;
@property (nonatomic, strong) PFUser *currentUser;
@property (nonatomic, strong) NSMutableArray *friends;

-(BOOL)isFriend:(PFUser *)user;

@end

