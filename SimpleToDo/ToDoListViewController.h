//
//  Created by kaibazawa.dai on 12/03/23.
//

#import <UIKit/UIKit.h>

@interface ToDoListViewController : UITableViewController <UIAlertViewDelegate> {
    UIBarButtonItem* rightBarButton;
}
@property (nonatomic, strong) IBOutlet UIBarButtonItem* rightBarButton;

@end
