//
//  Employee.h
//  CoreData
//
//  Created by Bipin Gohel on 17/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Department;

@interface Employee :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSNumber * EmployeeNo;
@property (nonatomic, retain) NSString * Designation;
@property (nonatomic, retain) Department * Department;

@end



