//
//  DetailViewController.h
//  NewsRss
//
//  Created by Thinh Hung on 9/28/14.
//  Copyright (c) 2014 Thinh Hung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
