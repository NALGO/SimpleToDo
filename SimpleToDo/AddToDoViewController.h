//
//  Created by kaibazawadai on 12/03/23.
//


#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"


@interface AddToDoViewController : UIViewController
@property(nonatomic, strong) IBOutlet UIButton *button;
@property(nonatomic, strong) IBOutlet UITextField *textField;
@property(nonatomic, strong) IBOutlet UISegmentedControl *prioritySegmentedControl;
- (IBAction)addButtonTap;

@end