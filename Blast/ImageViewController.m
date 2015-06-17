//
//  ImageViewController.m
//  StefChat
//
//  Created by Stefan Dierauf on 11/24/13.
//  Copyright (c) 2013 Stefan Dierauf. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

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
    //[self.navigationController setNavigationBarHidden:true animated:true];
    NSString *secretMessage = [self.message objectForKey:@"secretMessage"];
    //NSLog(secretMessage);
    self.secretMessageDisplay.hidden = true;
    NSLog(@"%lu", (unsigned long)secretMessage.length);
    if (secretMessage != nil && secretMessage.length > 0) {
        //show the message on the message display
        self.secretMessageDisplay.hidden = false;
        self.secretMessageDisplay.text = secretMessage;

    }
    PFFile *imageFile = [self.message objectForKey:@"file"];
    NSURL *imageURL = [[NSURL alloc] initWithString:imageFile.url];
    NSData * imageData = [NSData dataWithContentsOfURL:imageURL];
    self.imageView.image = [UIImage imageWithData:imageData];
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

@end
