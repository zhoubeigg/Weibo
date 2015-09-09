//
//  AccountTool.m
//  ZBWeibo
//
//  Created by macAir on 15/8/6.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//
#define AccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]
#import "AccountTool.h"

@implementation AccountTool

+ (void)saveAccount:(Account *)account
{
    // 归档
    [NSKeyedArchiver archiveRootObject:account toFile:AccountPath];
}
+ (Account *)account
{
    // 加载模型
    Account *account = [NSKeyedUnarchiver unarchiveObjectWithFile:AccountPath];
    // 验证账号是否过期
    // 取出过期秒数
    long long expires_in = [account.expires_in longLongValue];
    // 获得过期的时间
    NSDate *expiresTime = [account.created_time dateByAddingTimeInterval:expires_in];
    // 获得当前的时间
    NSDate *now = [NSDate date];
    // 判断是否过期
    NSComparisonResult result = [expiresTime compare:now];
    if (result != NSOrderedDescending) { //过期
        return nil;
    }
    
    return account;
    
}

@end
