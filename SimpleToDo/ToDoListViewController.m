//
//  Created by kaibazawa.dai on 12/03/23.
//

#import "ToDoListViewController.h"
#import "DBAccess.h"
#import "MBProgressHUD.h"

#define BG_COLOR_PRIORITY3 [UIColor colorWithRed:255.0/255.0 green:175.0/255.0 blue:175.0/255.0 alpha:1];
#define BG_COLOR_PRIORITY2 [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:118.0/255.0 alpha:1];
#define BG_COLOR_PRIORITY1 [UIColor whiteColor];

@interface ToDoListViewController ()
- (void)requestTodo;
- (void)versionUp;
@end

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
    [super viewWillAppear:animated];
    // 長時間かかる処理は画面に制御が渡った後に行う必要がある
    if ([dbAccess needVersionUp]) {
        MBProgressHUD* progress = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        progress.delegate = self;
        progress.labelText = NSLocalizedString(@"バージョンアップ処理中", nil);
        [self.navigationController.view addSubview:progress];
        [progress showWhileExecuting:@selector(versionUp) onTarget:self withObject:nil animated:YES];
    } else {
        [self requestTodo];
    }
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

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    ToDo *todo = [todoList objectAtIndex:(NSUInteger) indexPath.row];
    switch (todo.priority) {
        case 3:
            cell.backgroundColor = BG_COLOR_PRIORITY3;
            break;
        case 2:
            cell.backgroundColor = BG_COLOR_PRIORITY2;
            break;
        default:
            cell.backgroundColor = BG_COLOR_PRIORITY1;
            break;
    }
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
        [self requestTodo];
    }
}

#pragma mark - Innre methods
- (void)requestTodo {
    todoList = [dbAccess selectTodo];
    [self.tableView reloadData];
    if (todoList == nil) {
        UIAlertView *alertView = [[UIAlertView alloc]
                initWithTitle:nil message:NSLocalizedString(@"データの読み込みに失敗しました。申し訳ございませんが、アプリを再起動しても改善しない場合はデータを初期化してください。", nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)versionUp {
    if (![dbAccess versionUp]) {
        UIAlertView *alertView = [[UIAlertView alloc]
                initWithTitle:nil
                      message:NSLocalizedString(@"バージョンアップに失敗しました。申し訳ございませんが、アプリを再起動しても改善しない場合はデータを初期化してください。", nil)
                     delegate:nil
            cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        [alertView show];
    } else {
        [self requestTodo];
    }
}

@end
