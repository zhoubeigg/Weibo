//
//  UIWindow+Extension.m
//  ZBWeibo
//
//  Created by macAir on 15/8/7.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "UIWindow+Extension.h"
#import "TabBarViewController.h"
#import "NewfeatureViewController.h"

@implementation UIWindow (Extension)
- (void)switchRootViewController
{
    // 切换窗口的根控制器
    NSString *key = @"CFBundleVersion";
    // 上一次的使用版本(存储在沙盒中得版本号)
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    // 当前的软件的版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
 
    if ([currentVersion isEqualToString:lastVersion]) { // 版本号相同：和上次打开的是同一个版本
       self.rootViewController = [[TabBarViewController alloc] init];
    } else { // 这次打开得版本号和上次不一样，显示新特性
        self.rootViewController = [[NewfeatureViewController alloc] init];
        
        //将当前的版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

}
@end
