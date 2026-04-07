//
//  EditViewController.m
//  ToDe
//
//  Created by Wahid Ali Wahid on 08/04/2026.
//

#import "EditViewController.h"

#import "DataSource.h"

@interface EditViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UITextView *detailsView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *statusSegment;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySegment;


@end

@implementation EditViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_statusSegment setEnabled:NO forSegmentAtIndex:0];
    self.titleField.text = self.task.taskTitle;
      self.detailsView.text = self.task.taskDetails;
      
      self.statusSegment.selectedSegmentIndex = self.task.status;
      self.prioritySegment.selectedSegmentIndex = self.task.periority;
    
      if (self.task.status == DONE) {
          self.titleField.enabled = NO;
          self.detailsView.editable = NO;
          self.statusSegment.enabled = NO;
          self.prioritySegment.enabled = NO;
      }
    
}



- (IBAction)onSaveClick:(id)sender {


    if (self.task.status == DONE) {
        return;
    }

    Status newStatus = (Status)self.statusSegment.selectedSegmentIndex;

    if (self.task.status == IN_PROGRESS && newStatus == TODO) {
        
        UIAlertController *alert =
        [UIAlertController alertControllerWithTitle:@"Invalid Change"
                                            message:@"Task in progress cannot go back to TODO"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                  style:UIAlertActionStyleCancel
                                                handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }


    self.task.taskTitle = self.titleField.text;
    self.task.taskDetails = self.detailsView.text;
    self.task.status = newStatus;
    self.task.periority = (Periority)self.prioritySegment.selectedSegmentIndex;

    NSError *error;
    [self.dataSource.context save:&error];

    if (error) {
        NSLog(@"Update error: %@", error);
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}



- (IBAction)onCancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
