//
//  ViewController.m
//  SQLiteSample
//
//  Created by Thinh Hung on 10/18/14.
//  Copyright (c) 2014 Thinh Hung. All rights reserved.
//

#import "ViewController.h"
#import "DBManager.h"


@interface ViewController ()

@property (nonatomic, strong) DBManager *dbManager;

@property (nonatomic, strong) NSArray *peopleInfoArray;

@property (nonatomic) int recordIDToEdit;


-(void)loadData;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialize delegate and data source
    self.peopleTable.delegate = self;
    self.peopleTable.dataSource = self;
    
    // Initialize the dbManager property
    self.dbManager = [[DBManager alloc] initWithDatabaseFilename:@"sampledb.sql"];
    
    // Load the data.
    [self loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    EditInfoViewController *editInfoViewController = [segue destinationViewController];
    editInfoViewController.delegate = self;
    editInfoViewController.recordIDToEdit = self.recordIDToEdit;
}


#pragma mark - IBAction method implementation

- (IBAction)addNewRecord:(id)sender {
    // Set the -1 value(add a new record and not to edit an existing one)
    self.recordIDToEdit = -1;
    
    // Perform the segue
    [self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
}


#pragma mark - Private method implementation

-(void)loadData{
    // Form the query
    NSString *query = @"select * from peopleInfo";
    
    // Get the results
    if (self.peopleInfoArray != nil) {
        self.peopleInfoArray = nil;
    }
    self.peopleInfoArray = [[NSArray alloc] initWithArray:[self.dbManager loadDataFromDB:query]];
    
    // Reload the table view
    [self.peopleTable reloadData];
}


#pragma mark - UITableView method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.peopleInfoArray.count;
}


-(UITableViewCell *)tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath {
    // Dequeue the cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"peopleTableCell" forIndexPath:indexPath];
    
    NSInteger indexOfFirstname = [self.dbManager.columnNamesArray indexOfObject:@"firstname"];
    NSInteger indexOfLastname = [self.dbManager.columnNamesArray indexOfObject:@"lastname"];
    NSInteger indexOfAge = [self.dbManager.columnNamesArray indexOfObject:@"age"];
    
    // Set the loaded data to the appropriate cell labels
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [[self.peopleInfoArray objectAtIndex:indexPath.row] objectAtIndex:indexOfFirstname], [[self.peopleInfoArray objectAtIndex:indexPath.row] objectAtIndex:indexOfLastname]];
    
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Age: %@", [[self.peopleInfoArray objectAtIndex:indexPath.row] objectAtIndex:indexOfAge]];
    
    return cell;
}


-(CGFloat)tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath {
    return 60.0;
}


-(void)tableView: (UITableView *)tableView accessoryButtonTappedForRowWithIndexPath: (NSIndexPath *)indexPath {
    // Get the record ID of the selected item
    self.recordIDToEdit = [[[self.peopleInfoArray objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
    
    // Perform the segue
    [self performSegueWithIdentifier:@"idSegueEditInfo" sender:self];
}


-(void)tableView: (UITableView *)tableView commitEditingStyle: (UITableViewCellEditingStyle)editingStyle forRowAtIndexPath: (NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the selected record
        
        // Find the record ID
        int recordIDToDelete = [[[self.peopleInfoArray objectAtIndex:indexPath.row] objectAtIndex:0] intValue];
        
        // Prepare the query
        NSString *query = [NSString stringWithFormat:@"DELETE FROM peopleInfo WHERE peopleInfoID = %d", recordIDToDelete];
        
        // Execute the query
        [self.dbManager executeQuery:query];
        
        // Reload the table view
        [self loadData];
    }
}


#pragma mark - EditInfoViewControllerDelegate method implementation

-(void)editingInfoWasFinished{
    // Reload the data
    [self loadData];
}

@end
