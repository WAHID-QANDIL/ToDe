//
//  DataSource.h
//  ToDe
//
//  Created by Wahid Ali Wahid on 07/04/2026.
//

#import <Foundation/Foundation.h>
#import "DataSource.h"
#import <CoreData/NSManagedObject.h>
#import <CoreData/NSEntityDescription.h>
#import "ToDe-Swift.h"
#import "periority.h"
NS_ASSUME_NONNULL_BEGIN

@interface DataSource : NSObject
@property NSManagedObjectContext *context;


-(void) insert:(Task*) object;
-(void) update:(Task*) object;
-(void) remove:(NSInteger) identifier;
-(NSArray*)getAllTasks;
-(Task*)getATaskbyId:(NSInteger)identifier;
- (NSArray *)getTasksByPeriority:(Periority)periority;
- (NSArray *)getTasksByStatus:(Status)status;
- (void)removeAllTasks;
- (void)logAllTasks;
- (void)insertWithId:(NSInteger)taskId
               title:(NSString *)title
             details:(NSString *)details
              status:(Status)status
           periority:(Periority)periority;
@end

NS_ASSUME_NONNULL_END
