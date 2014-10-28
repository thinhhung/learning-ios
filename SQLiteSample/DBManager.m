//
//  DBManager.m
//  SQLiteSample
//
//  Created by Thinh Hung on 10/18/14.
//  Copyright (c) 2014 Thinh Hung. All rights reserved.
//

#import "DBManager.h"

#import "DBManager.h"
#import <sqlite3.h>


@interface DBManager()

@property (nonatomic, strong) NSString *documentsDirectory;

@property (nonatomic, strong) NSString *databaseFilename;

@property (nonatomic, strong) NSMutableArray *resultsArray;


-(void)copyDatabaseIntoDocumentsDirectory;

-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

@end


@implementation DBManager

#pragma mark - Initialization

-(instancetype)initWithDatabaseFilename: (NSString *)dbFilename {
    self = [super init];
    if (self) {
        // Set the documents directory path
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        // Keep the database filename.
        self.databaseFilename = dbFilename;
        
        // Copy the database file into the documents directory if necessary.
        [self copyDatabaseIntoDocumentsDirectory];
    }
    return self;
}


#pragma mark - Private method implementation

-(void)copyDatabaseIntoDocumentsDirectory {
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    // If the database file does not exist in the documents directory
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) {
        // Copy it
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        
        // If any errors occurred, write log message
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
    }
}



-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable{
	// sqlite3 object
	sqlite3 *sqlite3Database;
	
    // Set the database file path
	NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename];
    
    // Reset results array
    if (self.resultsArray != nil) {
        [self.resultsArray removeAllObjects];
        self.resultsArray = nil;
    }
	self.resultsArray = [[NSMutableArray alloc] init];
    
    // Reset column names array
    if (self.columnNamesArray != nil) {
        [self.columnNamesArray removeAllObjects];
        self.columnNamesArray = nil;
    }
    self.columnNamesArray = [[NSMutableArray alloc] init];
    
    
	// Open the database
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
	if(openDatabaseResult == SQLITE_OK) {
		// Will be stored the query after having been compiled into a SQLite statement
		sqlite3_stmt *compiledStatement;
		
        // Load all data from database to memory
        BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
		if(prepareStatementResult == SQLITE_OK) {
			// If the query is non-executable.
			if (!queryExecutable){
                
                // Keep the data for each fetched row
                NSMutableArray *dataRowArray;
                
				// Loop through the results and add them to the results array
				while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
					// Contain the data of a fetched row.
                    dataRowArray = [[NSMutableArray alloc] init];
                    
                    // Total number of columns
                    int totalColumns = sqlite3_column_count(compiledStatement);
                    
                    // Loop through all columns and fetch each column data
					for (int i = 0; i < totalColumns; i++){
                        // Convert the column data to characters
						char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                        
                        // If data is not null
						if (dbDataAsChars != NULL) {
                            // Convert the characters to string, add to the current row array
							[dataRowArray addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
						}
                        
                        // Keep the current column name
                        if (self.columnNamesArray.count != totalColumns) {
                            dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                            [self.columnNamesArray addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                        }
                    }
					
					// If has data, stores the data row in the results array
					if (dataRowArray.count > 0) {
                        [self.resultsArray addObject:dataRowArray];
					}
				}
			} else {
                // There are used for an executable query (insert, update, delete)
                
				// Execute the query.
                BOOL executeQueryResults = sqlite3_step(compiledStatement);
                if (executeQueryResults == SQLITE_DONE) {
                    // Keep the affected rows.
                    self.affectedRows = sqlite3_changes(sqlite3Database);
                    
                    // Keep the last inserted row ID.
                    self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
				} else {
					// If could not execute the query, write log message
                    NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
				}
			}
		} else {
            // In the database cannot be opened, write log message
			NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
		}
		
		// Release the compiled statement from memory.
		sqlite3_finalize(compiledStatement);
		
	}
    
    // Close the database.
	sqlite3_close(sqlite3Database);
}


#pragma mark - Public method implementation

-(NSArray *)loadDataFromDB:(NSString *)query{
    // Run not executable query
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    // Returns loaded results
    return (NSArray *)self.resultsArray;
}


-(void)executeQuery:(NSString *)query{
    // Run executable query
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}

@end
