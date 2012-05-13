//
//  Created by kaibazawa.dai on 12/03/23.
//

#import "ToDo.h"
#define DATE_FORMAT @"yyyy-MM-dd HH:mm:ss"

@implementation ToDo {

}
@synthesize todoID;
@synthesize addDate;
@synthesize todo;

// UNIX timeからNSDateへ変換して設定する
- (void)setDateFromUnixTime:(long long int)unixTime {
    addDate = [NSDate dateWithTimeIntervalSince1970:unixTime];
}

- (NSString *)dateAsString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = DATE_FORMAT;
    return [dateFormatter stringFromDate:addDate];
}

@end