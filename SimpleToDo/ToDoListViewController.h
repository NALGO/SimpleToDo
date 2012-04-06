//
//  Created by kaibazawa.dai on 12/03/23.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface ToDoListViewController : UITableViewController <UIAlertViewDelegate, MBProgressHUDDelegate> {
    UIBarButtonItem* rightBarButton;
}
@property (nonatomic, strong) IBOutlet UIBarButtonItem* rightBarButton;

@end
