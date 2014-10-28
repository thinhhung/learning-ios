//
//  ViewController.h
//  SQLiteSample
//
//  Created by Thinh Hung on 10/18/14.
//  Copyright (c) 2014 Thinh Hung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditInfoViewController.h"

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, EditInfoViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *peopleTable;

- (IBAction)addNewRecord:(id)sender;

@end
