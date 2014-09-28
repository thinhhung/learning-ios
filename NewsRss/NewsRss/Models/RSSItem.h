//
//  RSSItem.h
//  NewsRss
//
//  Created by Thinh Hung on 9/27/14.
//  Copyright (c) 2014 Thinh Hung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSSItem : NSObject

@property (strong, nonatomic) NSString* title;
@property (strong, nonatomic) NSString* description;
@property (strong, nonatomic) NSURL* link;
@property (strong, nonatomic) NSAttributedString* cellMessage;

@end