//
//  DataSource.m
//  ToDe
//
//  Created by Wahid Ali Wahid on 07/04/2026.
//

#import "DataSource.h"
#import "AppDelegate.h"
#import "ToDe-Swift.h"
@implementation DataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        self.context =
        ((AppDelegate *)UIApplication.sharedApplication.delegate)
        .persistentContainer.viewContext;
    }
    return self;
}

#pragma mark - INSERT
- (void)insert:(Task *)object {
    Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                               inManagedObjectContext:self.context];
    
    task.taskId = object.taskId;
    task.taskTitle = object.taskTitle;
    task.taskDetails = object.taskDetails;
    task.periority = object.periority;
    task.status = object.status;
    
    [self.context save:nil];
}

- (void)removeAllTasks {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    
    NSArray *results = [self.context executeFetchRequest:request error:nil];
    
    for (NSManagedObject *obj in results) {
        [self.context deleteObject:obj];
    }
    
    [self.context save:nil];
}

- (void)logAllTasks {
    NSArray *tasks = [self getAllTasks];
    
    NSLog(@"----- TASKS -----");
    
    for (Task *task in tasks) {
        NSLog(@"ID: %lld | Title: %@ | Status: %lld | Priority: %lld",
              task.taskId,
              task.taskTitle,
              task.status,
              task.periority);
    }
}

- (void)insertWithId:(NSInteger)taskId
               title:(NSString *)title
             details:(NSString *)details
              status:(Status)status
           periority:(Periority)periority {
    Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task"
                                               inManagedObjectContext:self.context];
    task.taskId = taskId;
    task.taskTitle = title;
    task.taskDetails = details;
    task.status = status;
    task.periority = periority;
    [self.context save:nil];
}

#pragma mark - DELETE
- (void)remove:(NSInteger)identifier {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"taskId == %ld", identifier];
    
    NSArray *results = [self.context executeFetchRequest:request error:nil];
    
    for (Task *task in results) {
        [self.context deleteObject:task];
    }
    
    [self.context save:nil];
}

#pragma mark - UPDATE
- (void)update:(Task *)object {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"taskId == %ld", object.taskId];
    
    Task *task = [[self.context executeFetchRequest:request error:nil] firstObject];
    
    if (task) {
        task.taskTitle = object.taskTitle;
        task.taskDetails = object.taskDetails;
        task.periority = object.periority;
        task.status = object.status;
        [self.context save:nil];
    }
}

#pragma mark - GET ALL
- (NSArray *)getAllTasks {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    return [self.context executeFetchRequest:request error:nil];
}

#pragma mark - GET BY ID
- (Task *)getATaskbyId:(NSInteger)identifier {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"taskId == %ld", identifier];
    
    return [[self.context executeFetchRequest:request error:nil] firstObject];
}

#pragma mark - FILTER BY PRIORITY
- (NSArray *)getTasksByPeriority:(Periority)periority {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"periority == %ld", periority];
    
    return [self.context executeFetchRequest:request error:nil];
}

#pragma mark - FILTER BY STATUS
- (NSArray *)getTasksByStatus:(Status)status {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"status == %ld", status];
    
    return [self.context executeFetchRequest:request error:nil];
}

@end
