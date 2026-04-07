//
//  ViewController.m
//  ToDe
//
//  Created by Wahid Ali Wahid on 07/04/2026.
//

#import "ViewController.h"
#import "MainTableViewController.h"
#import "AppDelegate.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentsBar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *table;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _segmentsBar.selectedSegmentIndex = 0;
    self.table.dataSource = self;
    self.table.delegate = self;
    
    
    NSManagedObjectContext *context =
    ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer.viewContext;
    
    
    // Do any additional setup after loading the view.
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    return 0;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
    return 10;
}


@end
