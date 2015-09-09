//
//  AppDelegate.m
//  ZBWeibo
//
//  Created by macAir on 15/7/29.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarViewController.h"
#import "NewfeatureViewController.h"
#import "OAuthViewController.h"
#import "SDWebImageManager.h"
#import "AccountTool.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //1.创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    //2.设置跟控制器
    // 从沙盒获取账号
    Account *account = [AccountTool account];
    
    if (account) { //之前登陆成功过
        [self.window switchRootViewController];
    } else {
        self.window.rootViewController = [[OAuthViewController alloc] init];
    }
    //3.显示窗口
    [self.window makeKeyAndVisible];
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // 向操作系统申请后台运行资格,能维持多长时间不能确定
    __block UIBackgroundTaskIdentifier task = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:task];
    }];

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    // 1.取消下载
    [mgr cancelAll];
    
    // 2.清除内存中的所有图片
    [mgr.imageCache clearMemory];
}

@end
