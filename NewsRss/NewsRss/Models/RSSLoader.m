//
//  RSSLoader.m
//  NewsRss
//
//  Created by Thinh Hung on 9/27/14.
//  Copyright (c) 2014 Thinh Hung. All rights reserved.
//

#import "RSSLoader.h"

#import "RXMLElement.h"
#import "RSSItem.h"

@implementation RSSLoader

-(void)fetchRssWithURL:(NSURL*)url complete:(RSSLoaderCompleteBlock)callbackFunction
{
    
    // Request with the URL
    NSURLConnection *connection = [[NSURLConnection alloc] init];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    (void)[connection initWithRequest:request delegate:self];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
         if ([data length] == 0 && error == nil) {
             // Empty response
         } else if (error != nil) {
             // Has errors
             NSLog(@"Error %@", [error localizedDescription]);
         } else if ([httpResponse statusCode] == 200) {
             // XML Parser
             RXMLElement *rss = [RXMLElement elementFromXMLData:data];
             RXMLElement *rssChild = [rss child:@"channel"];
             RXMLElement* title = [rssChild child:@"title"];
             NSArray* items = [[rss child:@"channel"] children:@"item"];
             
             NSMutableArray* result = [NSMutableArray arrayWithCapacity:items.count];
             
             // Get RSSItem from XML Element
             for (RXMLElement *element in items) {
                 RSSItem* item = [[RSSItem alloc] init];
                 item.title = [[element child:@"title"] text];
                 item.description = [[element child:@"description"] text];
                 item.link = [NSURL URLWithString: [[element child:@"link"] text]];
                 if (item.link != NULL) {
                     [result addObject: item];
                 }
             }
             
             callbackFunction([title text], result);
         }
     }];
    
}

@end
