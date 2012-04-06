//
//  Created by kaibazawa.dai on 12/03/23.
//

#import "ToDoListViewController.h"
#import "DBAccess.h"

@implementation ToDoListViewController {
    DBAccess* dbAccess;
    NSArray* todoList;
    ToDo * targetTodo;
}
@synthesize rightBarButton;

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    dbAccess = [DBAccess instance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillDisappear:animated];
    todoList = [dbAccess selectTodo];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return todoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    ToDo *todo = [todoList objectAtIndex:(NSUInteger) indexPath.row];
    cell.textLabel.text = todo.todo;
    cell.detailTextLabel.text = [todo dateAsString];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    UIAlertView *alertView = [[UIAlertView alloc]
            initWithTitle:nil message:NSLocalizedString(@"ToDoを削除しますか？", nil) delegate:self
        cancelButtonTitle:NSLocalizedString(@"キャンセル", nil) otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    [alertView show];
    targetTodo = [todoList objectAtIndex:(NSUInteger) indexPath.row];
}

#pragma mark - UIAlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.cancelButtonIndex == buttonIndex) {
        targetTodo = nil;
        return;
    }
    if (targetTodo != nil) {
        [dbAccess deleteTodo:targetTodo]; // エラー処理は省略
        targetTodo = nil;
        // 再描画
        todoList = [dbAccess selectTodo];
        [self.tableView reloadData];
    }
}

@end
