//
//  ViewController.h
//  ToDe
//
//  Created by Wahid Ali Wahid on 07/04/2026.
//

#import <UIKit/UIKit.h>
#import "DataSource.h"
#import "ToDe-Swift.h"
@interface ViewController : UIViewController
@property (nonatomic, strong) DataSource *dataSource;

@property (nonatomic, strong) NSMutableArray<Task *> *allTasks;
@property (nonatomic, strong) NSMutableArray<Task *> *inProgressTasks;
@property (nonatomic, strong) NSMutableArray<Task *> *doneTasks;
@property (nonatomic, strong) NSMutableArray<Task *> *todoTasks;

@property (nonatomic, strong) NSMutableArray<Task *> *highPriorityTasks;
@property (nonatomic, strong) NSMutableArray<Task *> *mediumPriorityTasks;
@property (nonatomic, strong) NSMutableArray<Task *> *lowPriorityTasks;




@end

