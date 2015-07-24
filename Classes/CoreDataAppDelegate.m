//
//  CoreDataAppDelegate.m
//  CoreData
//
//  Created by Bipin Gohel on 13/01/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoreDataAppDelegate.h"
#import "Employee.h"
#import "Department.h"

@implementation CoreDataAppDelegate

@synthesize window;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
    //CoreData has no of Advantages of SqLite, like, u can map rel with entities in Graphical way, 
    //it provides validation,performance , can be used as direct input to UITableView etc.
    
	NSManagedObjectContext *context = [self managedObjectContext];
	
	NSArray *name = [NSArray arrayWithObjects:@"Javal",@"Vipul",@"Chintan",@"Pratik",@"Kuldeep",nil];
	NSArray *departmentName = [NSArray arrayWithObjects:@"Mobile",@"Mobile",@"QA",@"QA",@"Mobile",nil];
	NSArray *empNo = [NSArray arrayWithObjects:[NSNumber numberWithInt:1],[NSNumber numberWithInt:2],[NSNumber numberWithInt:3],[NSNumber numberWithInt:4],[NSNumber numberWithInt:5],nil];
	NSArray *designation = [NSArray arrayWithObjects:@"Engineer",@"Engineer",@"Software",@"Software",@"Engineer",nil];
	NSArray *hod = [NSArray arrayWithObjects:@"Jigna",@"Jigna",@"Ashwin",@"Ashwin",@"Jigna",nil];

	// NSManagedObject *managedObject = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context];
    
    for (int j=0;j<5;j++) {

        // creating a managed object row-wise
        // To creat seprate class for an entity, add new coredata/managedobject file. 
        
        Department *departmentManagedObj =[NSEntityDescription insertNewObjectForEntityForName:@"Department" inManagedObjectContext:context];
        Employee *employeeManagedObj = [NSEntityDescription insertNewObjectForEntityForName:@"Employee" inManagedObjectContext:context]; 

        employeeManagedObj.Name = [name objectAtIndex:j];
        employeeManagedObj.EmployeeNo= [empNo objectAtIndex:j];
        employeeManagedObj.Designation =[designation objectAtIndex:j];
	
        departmentManagedObj.HoD =[hod objectAtIndex:j];
	
        departmentManagedObj.DepartmentName = [departmentName objectAtIndex:j];
	
        [departmentManagedObj addEmployeeObject:employeeManagedObj];        // add employee managed object to dept, for creating a join table.
                                                                            // mothed wiil automatically created by joining relationship between tables in xcdatmodel 

    }       
 
//	departmentManagedObj.Employee = employeeManagedObj;
	
//	employeeManagedObj.Department = departmentManagedObj;
/*	[managedObject setValue:@"xyz" forKey:@"Name"];
	[managedObject setValue:@"abc" forKey:@"Designation"];
	//[managedObject setValue:@"abc" forKey:@"Department"];
	
	[managedObject setValue:[NSNumber numberWithInt:123] forKey:@"EmployeeNo"];
	
	[managedObject setValue:@"XYZZZ" forKey:@"Name"];
	
	// [context deleteObject:managedObject];
	*/
    
	NSError *error;
	if (![context save:&error]) {
		NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
	}
		
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Employee" inManagedObjectContext:context];
	
//	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Department.HoD = 'Jigna' AND Name ='Vipul'"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Department.HoD = 'Jigna' "];
    
//	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name = 'Javal'"];
	
    [fetchRequest setPredicate:predicate];
	
	[fetchRequest setEntity:entity];
	
	NSArray *array = [context executeFetchRequest:fetchRequest error:&error];
	
	NSLog(@"Array......%@",[array descriptionWithLocale:name]);
	
	NSArray * optoutIDArray = [array valueForKeyPath:@"@distinctUnionOfObjects.Name"];
	
	NSLog(@"Array......%@",[optoutIDArray description]);
	
	
	
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
    [self saveContext];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
}


- (void)saveContext {
    
    NSError *error = nil;
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}    


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CoreData" withExtension:@"momd"];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CoreData.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator_;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    
    [managedObjectContext_ release];
    [managedObjectModel_ release];
    [persistentStoreCoordinator_ release];
    
    [window release];
    [super dealloc];
}


@end

