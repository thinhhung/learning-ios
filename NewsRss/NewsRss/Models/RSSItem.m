//
//  RSSItem.m
//  NewsRss
//
//  Created by Thinh Hung on 9/27/14.
//  Copyright (c) 2014 Thinh Hung. All rights reserved.
//

#import "RSSItem.h"
#import "GTMNSString+HTML.h"

@implementation RSSItem

-(NSAttributedString*)cellMessage
{
    if (_cellMessage!=nil) return _cellMessage;
    
    // Format styles
    NSDictionary* boldStyle = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica-Bold" size:16.0]};
    NSDictionary* normalStyle = @{NSFontAttributeName: [UIFont fontWithName:@"Helvetica" size:16.0]};
    
    NSMutableAttributedString* articleAbstract = [[NSMutableAttributedString alloc] initWithString:self.title];
    
    [articleAbstract setAttributes:boldStyle
                             range:NSMakeRange(0, self.title.length)];
    
    [articleAbstract appendAttributedString:
     [[NSAttributedString alloc] initWithString:@"\n\n"]
     ];
    
    int startIndex = [articleAbstract length];
    
    // Description limit by 100 characters
    NSString* description = [NSString stringWithFormat:@"%@...", [self.description substringToIndex:100]];
    
    // Unescape HTML string
    description = [description gtm_stringByUnescapingFromHTML];
    
    [articleAbstract appendAttributedString:
     [[NSAttributedString alloc] initWithString: description]
     ];
    
    [articleAbstract setAttributes:normalStyle
                             range:NSMakeRange(startIndex, articleAbstract.length - startIndex)];
    
    _cellMessage = articleAbstract;
    return _cellMessage;
    
}

@end
