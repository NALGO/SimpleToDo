//
//  Created by kaibazawadai on 12/03/23.
//


#import "AddToDoViewController.h"
#import "DBAccess.h"

@implementation AddToDoViewController {
    DBAccess* dbAccess;
}
@synthesize button;
@synthesize textField;
@synthesize prioritySegmentedControl;

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    dbAccess = [DBAccess instance];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)addButtonTap {
    NSString* todoText = self.textField.text;
    if (0 < todoText.length) {
        ToDo * todo = [[ToDo alloc] init];
        todo.todo = todoText;
        todo.addDate = [NSDate date];
        todo.priority = prioritySegmentedControl.selectedSegmentIndex + 1;
        [dbAccess insertTodo:todo];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end