//
//  Created by kaibazawa.dai on 12/03/23.
//

#import <Foundation/Foundation.h>

@interface ToDo : NSObject {
    int todoID;
    NSString* todo;
    NSDate* addDate;
}
@property(nonatomic) int todoID;
@property(nonatomic, strong) NSDate *addDate;
@property(nonatomic, strong) NSString *todo;

- (void)setDateFromUnixTime:(long long int)unixTime;

- (NSString *)dateAsString;

@end