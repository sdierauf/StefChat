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
    NSString *secretMessage = [self.message objectForKey:@"secretMessage"];
    if (secretMessage != nil) {
        self.secretMessageDisplay.text = secretMessage;
    } else {
        [self.secretMessageDisplay setHidden:true];
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
