//
//  DetailViewController.m
//  NewsRss
//
//  Created by Thinh Hung on 9/28/14.
//  Copyright (c) 2014 Thinh Hung. All rights reserved.
//

#import "DetailViewController.h"
#import "RSSItem.h"

@interface DetailViewController ()<UIWebViewDelegate>
{
    IBOutlet UIWebView* webView;
}
@end

@implementation DetailViewController

-(void)viewDidAppear:(BOOL)animated
{
    RSSItem* item = (RSSItem*)self.detailItem;
    self.title = item.title;
    webView.delegate = self;
    NSURLRequest* articleRequest = [NSURLRequest requestWithURL: item.link];
    webView.backgroundColor = [UIColor clearColor];
    [webView loadRequest: articleRequest];
}

-(void)viewDidDisappear:(BOOL)animated
{
    webView.delegate = nil;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

@end
