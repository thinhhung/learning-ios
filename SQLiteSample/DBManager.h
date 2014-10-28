//
//  DBManager.h
//  SQLiteSample
//
//  Created by Thinh Hung on 10/18/14.
//  Copyright (c) 2014 Thinh Hung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

@property (nonatomic, strong) NSMutableArray *columnNamesArray;

@property (nonatomic) int affectedRows;

@property (nonatomic) long long lastInsertedRowID;



-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

-(NSArray *)loadDataFromDB:(NSString *)query;

-(void)executeQuery:(NSString *)query;

@end
