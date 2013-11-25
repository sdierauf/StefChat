//
//  ImageViewController.h
//  StefChat
//
//  Created by Stefan Dierauf on 11/24/13.
//  Copyright (c) 2013 Stefan Dierauf. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageViewController : UIViewController
@property (nonatomic, strong)PFObject *message;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *secretMessageDisplay;

@end
