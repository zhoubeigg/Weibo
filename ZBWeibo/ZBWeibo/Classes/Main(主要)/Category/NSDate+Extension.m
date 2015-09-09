//
//  NSDate+Extension.m
//  ZBWeibo
//
//  Created by macAir on 15/8/15.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)
- (BOOL)isThisYear
{
    NSCalendarUnit unit = NSCalendarUnitYear;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 获得某个时间的年月日时分秒
    NSDateComponents *dateCmps = [calendar components:unit fromDate:self];
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    return dateCmps.year == nowCmps.year;
}

- (BOOL)isYesterday
{
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:now];
    
    NSDate *date = [fmt dateFromString:dateStr];
    now = [fmt dateFromString:nowStr];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:now options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}

- (BOOL)isToday
{
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [fmt stringFromDate:self];
    NSString *nowStr = [fmt stringFromDate:now];
    
    return [dateStr isEqualToString:nowStr];
}
@end
