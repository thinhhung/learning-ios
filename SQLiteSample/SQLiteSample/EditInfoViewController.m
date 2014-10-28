//
//  EditInfoViewController.m
//  SQLiteSample
//
//  Created by Thinh Hung on 10/25/14.
//  Copyright (c) 2014 Thinh Hung. All rights reserved.
//

#import "EditInfoViewController.h"
#import "DBManager.h"


@interface EditInfoViewController ()

@property (nonatomic, strong) DBManager *dbManager;

-(void)loadInfoToEdit;

@end


@implementation EditInfoViewController

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
    
    // Initialize some delegates
    self.firstnameTextField.delegate = self;
    self.lastnameTextField.delegate = self;
    self.ageTextField.delegate = self;
    
    // Set the navigation bar tint color.
    self.navigationController.navigationBar.tintColor = self.navigationItem.rightBarButtonItem.tintColor;
    
    // Initialize the dbManager object.
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sampledb.sql"];
    
    // If record id is not -1, load data info to edit
    if (self.recordIDToEdit != -1) {
        [self loadInfoToEdit];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}




#pragma mark - UITextFieldDelegate method implementation

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - IBAction method implementation

- (IBAction)saveInfo:(id)sender {
    NSString *query;
    if (self.recordIDToEdit == -1) {
        // If record id is -1, add a new
        query = [NSString stringWithFormat:@"INSERT INTO peopleInfo VALUES(null, '%@', '%@', %d)", self.firstnameTextField.text, self.lastnameTextField.text, [self.ageTextField.text intValue]];
    } else {
        // If record id is not -1, update the record
        query = [NSString stringWithFormat:@"UPDATE peopleInfo SET firstname = '%@', lastname = '%@', age = %d WHERE peopleInfoID = %d", self.firstnameTextField.text, self.lastnameTextField.text, self.ageTextField.text.intValue, self.recordIDToEdit];
    }
    
    
    // Execute the query
    [self.dbManager executeQuery:query];
    
    // If the query was successfully executed then pop the view controller
    if (self.dbManager.affectedRows != 0) {
        NSLog(@"Query was executed successfully. Affected rows = %d", self.dbManager.affectedRows);
        
        // Inform the delegate that the editing was finished
        [self.delegate editingInfoWasFinished];
        
        // Pop the view controller.
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        NSLog(@"Could not execute the query");
    }
}


#pragma mark - Private method implementation

-(void)loadInfoToEdit{
    // Select a person data by id query
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM peopleInfo WHERE peopleInfoID = %d", self.recordIDToEdit];
    
    // Load data from database
    NSArray *results = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Set the loaded data to the text fields
    self.firstnameTextField.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.columnNamesArray indexOfObject:@"firstname"]];
    self.lastnameTextField.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.columnNamesArray indexOfObject:@"lastname"]];
    self.ageTextField.text = [[results objectAtIndex:0] objectAtIndex:[self.dbManager.columnNamesArray indexOfObject:@"age"]];
}

@end
