//
//  DBAccess.h
//  SimpleTodo
//
//  Created by  on 12/03/22.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToDo.h"

@interface DBAccess : NSObject
+ (id)instance;
- (BOOL)insertTodo:(ToDo *)todo;
- (NSArray *)selectTodo;
- (BOOL)deleteTodo:(ToDo *)todo;
@end
