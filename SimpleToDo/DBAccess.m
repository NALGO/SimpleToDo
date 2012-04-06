//
//  Created by kaibazawa.dai on 12/03/23.
//

#import "DBAccess.h"
#import <sqlite3.h>

#define VERSION 2
#define VERSION_KEY @"VERSION_KEY"
#define DB_FILE_NAME @"SimpleTodo.sqlite"
#define TABLE_TODO "todo"
#define COLUMN_TODO_ID "todo_id"
#define COLUMN_TODO_TODO "todo"
#define COLUMN_TODO_ADD_DATE "add_date"
#define COLUMN_TODO_PRIORITY "priority"
#define DEFAULT_PRIORITY "2"
#define SQL_CREATE_TABLE_TODO "create table " TABLE_TODO \
    "(" COLUMN_TODO_ID " integer primary key autoincrement," \
    COLUMN_TODO_TODO " text, " COLUMN_TODO_ADD_DATE " integer," \
    COLUMN_TODO_PRIORITY " integer default " DEFAULT_PRIORITY ")"

@implementation DBAccess {
    NSRecursiveLock *lock;
    sqlite3 *database;
}

static id _instance = nil;

// singleton
+ (id)instance {
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[DBAccess alloc] init];
        }
    }
    return _instance;
}

// データベースの保存先取得
- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:DB_FILE_NAME];
}

// DBのクローズ
- (void)close {
    [lock lock];
    if (database != NULL) {
        sqlite3_close(database);
        database = NULL;
    }
    [lock unlock];
}

- (id)init {
    if ((self = [super init]) != nil) {
        lock = [[NSRecursiveLock alloc] init];
        BOOL existsAtDBFile = NO;
        if ([[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
            existsAtDBFile = YES;
        }

        if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
            [self close];
            NSLog(@"初期化に失敗しました");
            return nil;
        }

        char *errorMsg;
        // テーブル作成
        if (existsAtDBFile == NO) {
            if (sqlite3_exec(database, SQL_CREATE_TABLE_TODO, NULL, NULL, &errorMsg) != SQLITE_OK) {
                [self close];
                NSLog(@"todoテーブル作成に失敗しました");
                return nil;
            }
            // DB VersionをNSUserDefaultsに保存
            NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
            [ud setInteger:VERSION forKey:VERSION_KEY];
            [ud synchronize];
        }
    }
    return self;
}

- (BOOL)needVersionUp {
    NSInteger beforeDBVersion = [[NSUserDefaults standardUserDefaults] integerForKey:VERSION_KEY];
    return (beforeDBVersion < VERSION);
}

- (BOOL)versionUp {
    char *errorMsg;
    char *query = "alter table " TABLE_TODO " add column " COLUMN_TODO_PRIORITY " default " DEFAULT_PRIORITY;
    if (sqlite3_exec(database, query, NULL, NULL, &errorMsg) != SQLITE_OK) {
        NSLog(@"todoテーブルのversion upに失敗");
        return NO;
    }
    // DB VersionをNSUserDefaultsに保存
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:VERSION forKey:VERSION_KEY];
    [ud synchronize];
    return YES;
}

- (BOOL)insertTodo:(ToDo *)todo {
    char *query = "insert into " TABLE_TODO "(" COLUMN_TODO_TODO "," COLUMN_TODO_ADD_DATE "," COLUMN_TODO_PRIORITY ")"
            " values (?, ?, ?) ";
    sqlite3_stmt *stmt;
    if (sqlite3_prepare_v2(database, query, -1, &stmt, nil) == SQLITE_OK) {
        int i = 1;
        sqlite3_bind_text(stmt, i++, [todo.todo UTF8String], -1, NULL);
        sqlite3_bind_int64(stmt, i++, (long long int)[todo.addDate timeIntervalSince1970]);
        sqlite3_bind_int(stmt, i++, todo.priority);
    }
    BOOL result = YES;
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        NSLog(@"todoの追加に失敗");
        result = NO;
    }
    sqlite3_finalize(stmt);
    return result;
}

- (NSArray *)selectTodo {
    sqlite3_stmt *stmt;
    char *query = "select " COLUMN_TODO_ID "," COLUMN_TODO_TODO "," COLUMN_TODO_ADD_DATE "," COLUMN_TODO_PRIORITY " from " TABLE_TODO " order by " COLUMN_TODO_PRIORITY " desc," COLUMN_TODO_ADD_DATE " desc";
    NSMutableArray *todoArr = [NSMutableArray array];
    if (sqlite3_prepare_v2(database, query, -1, &stmt, nil) == SQLITE_OK) {
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            int i = 0;
            ToDo *todo1 = [[ToDo alloc] init];
            todo1.todoID = sqlite3_column_int(stmt, i++);
            todo1.todo = [NSString stringWithUTF8String:(char *) sqlite3_column_text(stmt, i++)];
            [todo1 setDateFromUnixTime:sqlite3_column_int(stmt, i++)];
            todo1.priority = sqlite3_column_int(stmt, i++);
            [todoArr addObject:todo1];
            NSLog(@"%d %@ %@", todo1.todoID, todo1.todo, todo1.addDate);
        }
        sqlite3_finalize(stmt);
    } else {
        NSLog(@"todoの読み込みに失敗しました");
        return nil;
    }
    return todoArr;
}

- (BOOL)deleteTodo:(ToDo *)todo {
    sqlite3_stmt *stmt;
    char *query = "delete from " TABLE_TODO " where " COLUMN_TODO_ID " = ?";
    if (sqlite3_prepare_v2(database, query, -1, &stmt, NULL) == SQLITE_OK) {
        int i = 1;
        sqlite3_bind_int(stmt, i++, todo.todoID);
    }
    BOOL result = YES;
    if (sqlite3_step(stmt) != SQLITE_DONE) {
        NSLog(@"TODOの削除に失敗");
        result = NO;
    }
    sqlite3_finalize(stmt);
    return result;
}

@end
