//
//  Department.h
//  CoreData
//
//  Created by Bipin Gohel on 17/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class Employee;

@interface Department :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * HoD;
@property (nonatomic, retain) NSString * DepartmentName;
@property (nonatomic, retain) NSSet* Employee;

@end


@interface Department (CoreDataGeneratedAccessors)
- (void)addEmployeeObject:(Employee *)value;
- (void)removeEmployeeObject:(Employee *)value;
- (void)addEmployee:(NSSet *)value;
- (void)removeEmployee:(NSSet *)value;

@end

