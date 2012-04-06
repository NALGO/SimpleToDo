//
//  Created by kaibazawadai on 12/03/23.
//


#import "InfoViewController.h"
#define NALGO_URL @"http://www.nalgo.co.jp"
#define SRC_URL @"https://kaibadash.github.com/SimpleTodo"
#define LIB_URL0 @"https://github.com/jdg/MBProgressHUD"
@implementation InfoViewController {

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    NSString *appName;
    NSString *version;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    switch (indexPath.section) {
        case 0:
            appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
            version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", appName, version];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"NIPPON ALGORITHM CO,LTD";
                    cell.detailTextLabel.text = NALGO_URL;
                    break;
                case 1:
                    cell.textLabel.text = @"ソースコード";
                    cell.detailTextLabel.text = SRC_URL;
                    break;
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"MBProgressHUD";
                    cell.detailTextLabel.text = LIB_URL0;
                    break;
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            break;
        default:
            break;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
            case 0:
                return NSLocalizedString(@"Version", nil);
                break;
            case 1:
                return NSLocalizedString(@"Information", nil);
                break;
            case 2:
                return NSLocalizedString(@"Library", nil);
                break;
            default:
                break;
        }
    return @"";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 1:
            switch (indexPath.row) {
                case 0:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:NALGO_URL]];
                    break;
                case 1:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SRC_URL]];
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:LIB_URL0]];
                    break;
            }
            break;
    }
}

- (IBAction)close {
    [self dismissModalViewControllerAnimated:YES];
}

@end