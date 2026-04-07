//
//  AddNewTaskViewController.m
//  ToDe
//
//  Created by Wahid Ali Wahid on 08/04/2026.
//

#import "AddNewTaskViewController.h"

@interface AddNewTaskViewController ()
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statusSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;


@end

@implementation AddNewTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_statusSegment setEnabled:NO forSegmentAtIndex:2];
    self.textField.placeholder = @"Task title";
    
    self.textField.layer.cornerRadius = 10;
    self.textField.backgroundColor = [UIColor systemGray6Color];
    
    self.textView.layer.cornerRadius = 12;
    self.textView.backgroundColor = [UIColor systemGray6Color];
    
    self.statusSegment.selectedSegmentIndex = 0;
    self.prioritySegment.selectedSegmentIndex = 0;
}

- (IBAction)tabChange:(UISegmentedControl *)sender {
    
    if (sender == self.prioritySegment) {
        self.selectedPriority = sender.selectedSegmentIndex;
    }
}

- (IBAction)saveButtonClick:(id)sender {
    
    NSString *title = self.textField.text;
    NSString *details = self.textView.text;

    
    
    if ([title isEqual:@""] || [details isEqual:@""]) {
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"Task is incomplete"
                                            message:@"You have to fill task title and details to add a new task"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *confirm =
        [UIAlertAction actionWithTitle:@"Confirm"
                                 style:UIAlertActionStyleCancel
                               handler:nil];
    
        
        [alert addAction:confirm];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    NSInteger taskId = arc4random_uniform(100000);
    
    Status status = (Status)self.statusSegment.selectedSegmentIndex;
    Periority priority = (Periority)self.prioritySegment.selectedSegmentIndex;
    
    [self.dataSource insertWithId:taskId
                            title:title
                          details:details
                           status:status
                        periority:priority];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelButtonClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
