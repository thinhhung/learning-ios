//
//  ViewController.m
//  SocialSharing
//
//  Created by Thinh Hung on 11/27/14.
//  Copyright (c) 2014 Thinh Hung. All rights reserved.
//

#import "ViewController.h"
#import "Social/Social.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)postToTwitter:(id)sender {
    SLComposeViewController *controller = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
    [controller setInitialText:@"What on your mind?"];
    [self presentViewController:controller animated:YES completion:nil];
}
- (IBAction)postToFacebook:(id)sender {
    SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
    [controller setInitialText:@"What on your mind?"];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
