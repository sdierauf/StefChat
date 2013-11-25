//
//  FriendsTableViewController.h
//  Blast
//
//  Created by Stefan Dierauf on 11/23/13.
//  Copyright (c) 2013 Stefan Dierauf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FriendsTableViewController : UITableViewController

@property (nonatomic, strong)PFRelation *friendsRelation;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) PFUser *currentUser;

@end
