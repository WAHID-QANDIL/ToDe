//
//  ViewController.m
//  ToDe
//
//  Created by Wahid Ali Wahid on 07/04/2026.
//
#import "ViewController.h"
#import "DataSource.h"
#import "ToDe-Swift.h"
#import "SDWebImage/SDWebImage.h"
#import "AddNewTaskViewController.h"
#import "EditViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentsBar;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong) NSMutableArray<Task *> *filteredTasks;
@property (nonatomic) BOOL isSearching;
@property UIView *emptyView;
@property UIImageView *emptyImageView;
@property UILabel *emptyLabel;


@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        _dataSource = [[DataSource alloc] init];
        
        _allTasks = [NSMutableArray new];
        _inProgressTasks = [NSMutableArray new];
        _doneTasks = [NSMutableArray new];
        _todoTasks = [NSMutableArray new];
        
        _highPriorityTasks = [NSMutableArray new];
        _mediumPriorityTasks = [NSMutableArray new];
        _lowPriorityTasks = [NSMutableArray new];
    }
    return self;
}
- (IBAction)onAddButtonClick:(id)sender {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    AddNewTaskViewController *vc =
    [storyboard instantiateViewControllerWithIdentifier:@"AddNewTaskVC"];
    
    vc.dataSource = self.dataSource;
    
    vc.modalPresentationStyle = UIModalPresentationPageSheet;
    
    [self presentViewController:vc animated:YES completion:nil];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupEmptyView];
    self.searchBar.delegate = self;
    self.filteredTasks = [NSMutableArray new];
    
    [self.table registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    self.segmentsBar.selectedSegmentTintColor = [UIColor systemBlueColor];
    [self.segmentsBar setTitleTextAttributes:@{
        NSForegroundColorAttributeName: [UIColor whiteColor]
    } forState:UIControlStateSelected];
    
    
    self.table.backgroundColor = [UIColor systemGroupedBackgroundColor];
    self.table.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.table.rowHeight = 80;
    
    
    self.segmentsBar.selectedSegmentIndex = 0;
    
    self.table.dataSource = self;
    self.table.delegate = self;
    [self reloadTasks];
    [self.table reloadData];
}

- (void)setupEmptyView {
    
    self.emptyView = [[UIView alloc] initWithFrame:self.table.bounds];
    self.emptyView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.emptyImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 150)];
    self.emptyImageView.center = CGPointMake(self.table.center.x, self.table.center.y - 40);
    self.emptyImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.emptyImageView.image = [UIImage imageNamed:@"empty_state"];
    
    self.emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.emptyImageView.frame) + 10, self.table.bounds.size.width - 40, 30)];
    self.emptyLabel.textAlignment = NSTextAlignmentCenter;
    self.emptyLabel.textColor = [UIColor grayColor];
    self.emptyLabel.font = [UIFont systemFontOfSize:14];
    
    [self.emptyView addSubview:self.emptyImageView];
    [self.emptyView addSubview:self.emptyLabel];
    
    self.emptyView.hidden = YES;
    
    [self.table addSubview:self.emptyView];
}
- (void)updateEmptyState {
    
    NSInteger count = 0;

    if (self.isSearching) {
        count = self.filteredTasks.count;
        self.emptyLabel.text = @"No matching results";
    } else {
        NSInteger sections = [self numberOfSectionsInTableView:self.table];
        
        for (NSInteger i = 0; i < sections; i++) {
            count += [self tableView:self.table numberOfRowsInSection:i];
        }
        
        self.emptyLabel.text = @"No tasks available";
    }
    
    self.emptyView.hidden = (count > 0);
}




#pragma mark - Data

- (void)reloadTasks {
    [self.allTasks removeAllObjects];
    [self.inProgressTasks removeAllObjects];
    [self.doneTasks removeAllObjects];
    [self.todoTasks removeAllObjects];
    [self.highPriorityTasks removeAllObjects];
    [self.mediumPriorityTasks removeAllObjects];
    [self.lowPriorityTasks removeAllObjects];
    
    [self.allTasks addObjectsFromArray:[self.dataSource getAllTasks]];
    [self.inProgressTasks addObjectsFromArray:[self.dataSource getTasksByStatus:IN_PROGRESS]];
    [self.doneTasks addObjectsFromArray:[self.dataSource getTasksByStatus:DONE]];
    [self.todoTasks addObjectsFromArray:[self.dataSource getTasksByStatus:TODO]];
    
    [self.lowPriorityTasks addObjectsFromArray:[self.dataSource getTasksByPeriority:LOW]];
    [self.mediumPriorityTasks addObjectsFromArray:[self.dataSource getTasksByPeriority:MEDIUM]];
    [self.highPriorityTasks addObjectsFromArray:[self.dataSource getTasksByPeriority:HIGH]];
}

#pragma mark - Segments

- (IBAction)onSelectedTabChange:(UISegmentedControl *)sender {
    [self reloadTasks];
    [self.table reloadData];
    [self updateEmptyState];}

#pragma mark - Helpers

- (NSArray<Task *> *)tasksForCurrentSegmentInSection:(NSInteger)section {
    switch (self.segmentsBar.selectedSegmentIndex) {
        case 0: return self.allTasks;
        case 1: return self.inProgressTasks;
        case 2: return self.doneTasks;
        case 3: return self.todoTasks;
        case 4:
            if (section == 0) return self.highPriorityTasks;
            if (section == 1) return self.mediumPriorityTasks;
            if (section == 2) return self.lowPriorityTasks;
        default:
            return @[];
    }
}

#pragma mark - Table

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.segmentsBar.selectedSegmentIndex == 4) ? 3 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isSearching) {
            return self.filteredTasks.count;
        }
    
    return [self tasksForCurrentSegmentInSection:section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    Task *task;
    if (self.isSearching) {
        task = self.filteredTasks[indexPath.row];
    } else {
        task = [self tasksForCurrentSegmentInSection:indexPath.section][indexPath.row];
    }

    UIView *card = [cell.contentView viewWithTag:100];
    
    if (!card) {
        card = [[UIView alloc] initWithFrame:CGRectInset(cell.contentView.bounds, 12, 6)];
        card.tag = 100;
        card.backgroundColor = [UIColor whiteColor];
        card.layer.cornerRadius = 14;
        
        card.layer.shadowColor = [UIColor blueColor].CGColor;
        card.layer.shadowOpacity = 0.3;
        card.layer.shadowOffset = CGSizeMake(0, 2);
        card.layer.shadowRadius = 4;
        card.layer.shouldRasterize = YES;
        card.layer.rasterizationScale = UIScreen.mainScreen.scale;

        
        
        CGFloat paddingLeft = 60;
        CGFloat paddingRight = 110;
        CGFloat width = card.bounds.size.width - paddingLeft - paddingRight;

      
        
        
        UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(12, 18, 36, 36)];
        icon.tag = 101;
        icon.contentMode = UIViewContentModeScaleAspectFit;
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, 10, width, 22)];
        title.tag = 102;
        title.font = [UIFont boldSystemFontOfSize:16];

        UILabel *details = [[UILabel alloc] initWithFrame:CGRectMake(paddingLeft, 32, width, 18)];
        details.tag = 103;
        details.font = [UIFont systemFontOfSize:13];
        details.textColor = [UIColor grayColor];
        

        UILabel *badge = [[UILabel alloc] initWithFrame:CGRectMake(card.bounds.size.width - 110, 18, 90, 24)];
        badge.tag = 104;
        badge.textAlignment = NSTextAlignmentCenter;
        badge.layer.cornerRadius = 6;
        badge.clipsToBounds = YES;
        badge.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
        badge.textColor = [UIColor whiteColor];

        [card addSubview:icon];
        [card addSubview:title];
        [card addSubview:details];
        [card addSubview:badge];

        [cell.contentView addSubview:card];
    }


    UIImageView *icon = [card viewWithTag:101];
    UILabel *title = [card viewWithTag:102];
    UILabel *details = [card viewWithTag:103];
    UILabel *badge = [card viewWithTag:104];

    title.text = task.taskTitle;
    details.text = task.taskDetails;


    NSString *imageURL = [self imageURLForTask:task];
    [icon sd_setImageWithURL:[NSURL URLWithString:imageURL]
            placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    switch (task.status) {
        case TODO:
            badge.text = @"TODO";
            badge.backgroundColor = [UIColor lightGrayColor];
            break;
        case IN_PROGRESS:
            badge.text = @"IN PROGRESS";
            badge.backgroundColor = [UIColor systemOrangeColor];
            break;
        case DONE:
            badge.text = @"DONE";
            badge.backgroundColor = [UIColor systemGreenColor];
            break;
    }


    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.segmentsBar.selectedSegmentIndex != 4) return nil;
    
    if (section == 0) return @"High Priority";
    if (section == 1) return @"Medium Priority";
    if (section == 2) return @"Low Priority";
    
    return nil;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}


- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView
trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {

    UIContextualAction *deleteAction =
    [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive
                                            title:@"Delete"
                                          handler:^(UIContextualAction *action, UIView *sourceView, void (^completionHandler)(BOOL)) {
        
        Task *task;

        if (self.isSearching) {
            task = self.filteredTasks[indexPath.row];
        } else {
            task = [self tasksForCurrentSegmentInSection:indexPath.section][indexPath.row];
        }
        
        [self showDeleteConfirmationForTask:task indexPath:indexPath];
        
        completionHandler(NO);
    }];
    
    return [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
}




- (void)showDeleteConfirmationForTask:(Task *)task indexPath:(NSIndexPath *)indexPath {
    
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"Delete Task"
                                        message:@"Are you sure you want to delete this task?"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancel =
    [UIAlertAction actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleCancel
                           handler:nil];
    
    UIAlertAction *delete =
    [UIAlertAction actionWithTitle:@"Delete"
                             style:UIAlertActionStyleDestructive
                           handler:^(UIAlertAction * _Nonnull action) {
        
        [self.dataSource remove:task.taskId];
        
        [self reloadTasks];
        [self.table reloadData];
        [self updateEmptyState];
    }];
    
    [alert addAction:cancel];
    [alert addAction:delete];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView
leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {

    Task *task;

    if (self.isSearching) {
        task = self.filteredTasks[indexPath.row];
    } else {
        task = [self tasksForCurrentSegmentInSection:indexPath.section][indexPath.row];
    }

    if (task.status == DONE) {
        return nil;
    }

    UIContextualAction *doneAction =
    [UIContextualAction contextualActionWithStyle:UIContextualActionStyleNormal
                                            title:@"Done"
                                          handler:^(UIContextualAction *action, UIView *sourceView, void (^completionHandler)(BOOL)) {

        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"Mark as Done"
                                            message:@"Are you sure you want to mark this task as done?"
                                     preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *cancel =
        [UIAlertAction actionWithTitle:@"Cancel"
                                 style:UIAlertActionStyleCancel
                               handler:^(UIAlertAction * _Nonnull action) {
            completionHandler(NO);
        }];

        UIAlertAction *confirm =
        [UIAlertAction actionWithTitle:@"Done"
                                 style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
            
            task.status = DONE;

            NSError *error;
            [self.dataSource.context save:&error];

            if (error) {
                NSLog(@"Update error: %@", error);
            }

            [self reloadTasks];
            [self.table reloadData];

            completionHandler(YES);
        }];

        [alert addAction:cancel];
        [alert addAction:confirm];

        [self presentViewController:alert animated:YES completion:nil];
    }];

    doneAction.backgroundColor = [UIColor systemGreenColor];
    doneAction.image = [UIImage systemImageNamed:@"checkmark"];

    UISwipeActionsConfiguration *config =
    [UISwipeActionsConfiguration configurationWithActions:@[doneAction]];

    config.performsFirstActionWithFullSwipe = NO;

    return config;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    Task *task;

    if (self.isSearching) {
        task = self.filteredTasks[indexPath.row];
    } else {
        task = [self tasksForCurrentSegmentInSection:indexPath.section][indexPath.row];
    }
    
    if (task.status == DONE) {
        return;
    }

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    EditViewController *vc =
    [storyboard instantiateViewControllerWithIdentifier:@"EditViewController"];
    
    vc.task = task;
    vc.dataSource = self.dataSource;
    
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length == 0 ) {
        self.isSearching = NO;
        [self.filteredTasks removeAllObjects];
    } else {
        self.isSearching = YES;
        [self.filteredTasks removeAllObjects];
        
        NSArray *source = [self tasksForCurrentSegmentInSection:0];
        
        for (Task *task in source) {
            
            if ([task.taskTitle.lowercaseString containsString:searchText.lowercaseString] ||
                [task.taskDetails.lowercaseString containsString:searchText.lowercaseString]) {
                
                [self.filteredTasks addObject:task];
            }
        }
    }
    
    [self.table reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.isSearching = NO;
    [self.filteredTasks removeAllObjects];
    [self.table reloadData];
    [self updateEmptyState];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reloadTasks];
    [self.table reloadData];
    [self updateEmptyState];
}
- (void)viewDidAppear:(BOOL)animated{
    [self reloadTasks];
    [self.table reloadData];
    [self updateEmptyState];
}



- (NSString *)imageURLForTask:(Task *)task {
    NSString *imageURL;

    switch (task.periority) {
        case HIGH:
            imageURL = @"https://img.icons8.com/color/96/high-priority.png";
            break;
        case MEDIUM:
            imageURL = @"https://img.icons8.com/color/96/medium-priority.png";
            break;
        case LOW:
            imageURL = @"https://img.icons8.com/color/96/low-priority.png";
            break;
    }
    return imageURL;
}
@end
