//
//  EditInfoViewController.h
//  SQLiteSample
//
//  Created by Thinh Hung on 10/25/14.
//  Copyright (c) 2014 Thinh Hung. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditInfoViewControllerDelegate

-(void)editingInfoWasFinished;

@end


@interface EditInfoViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) id<EditInfoViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *firstnameTextField;

@property (weak, nonatomic) IBOutlet UITextField *lastnameTextField;

@property (weak, nonatomic) IBOutlet UITextField *ageTextField;

@property (nonatomic) int recordIDToEdit;


- (IBAction)saveInfo:(id)sender;

@end
