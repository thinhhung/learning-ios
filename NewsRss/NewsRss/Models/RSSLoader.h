//
//  RSSLoader.h
//  NewsRss
//
//  Created by Thinh Hung on 9/27/14.
//  Copyright (c) 2014 Thinh Hung. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^RSSLoaderCompleteBlock)(NSString* title, NSArray* results);

@interface RSSLoader : NSObject

-(void)fetchRssWithURL:(NSURL*)url complete:(RSSLoaderCompleteBlock)c;

@end
