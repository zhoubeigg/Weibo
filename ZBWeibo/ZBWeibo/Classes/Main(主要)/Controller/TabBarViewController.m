//
//  TabBarViewController.m
//  ZBWeibo
//
//  Created by macAir on 15/7/29.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "TabBarViewController.h"
#import "HomeViewController.h"
#import "MessageCenterViewController.h"
#import "DiscoverViewController.h"
#import "ProfileViewController.h"
#import "ZBWNavigationController.h"
#import "ZBWTabBar.h"
#import "ComposeViewController.h"

@interface TabBarViewController () <ZBWTabBarDelegate>

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.初始化子控制器
    HomeViewController *home = [[HomeViewController alloc] init];
    [self addChildVc:home title:@"首页" image:@"tabbar_home" selectedImage:@"tabbar_home_selected"];
    
    MessageCenterViewController *messageCenter = [[MessageCenterViewController alloc] init];
    [self addChildVc:messageCenter title:@"消息" image:@"tabbar_message_center" selectedImage:@"tabbar_message_center_selected"];
    
    DiscoverViewController *discover = [[DiscoverViewController alloc] init];
    [self addChildVc:discover title:@"发现" image:@"tabbar_discover"selectedImage:@"tabbar_discover_selected"];
    
    ProfileViewController *profile = [[ProfileViewController alloc] init];
    [self addChildVc:profile title:@"我" image:@"tabbar_profile" selectedImage:@"tabbar_profile_selected"];
    
     //2.更换系统自带的tabbar
    ZBWTabBar *tabBar = [[ZBWTabBar alloc] init];
    tabBar.delegate = self; //可不需要手动设置代理，下一行代码后会自动设置
    [self setValue:tabBar forKey:@"tabBar"];


}

-(void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage
{
    //设置子控制器的文字和图片
//    childVc.tabBarItem.title = title;
//    childVc.navigationItem.title = title;
    childVc.title = title;
    
    //设置子控制器的图片
    childVc.tabBarItem.image = [UIImage imageNamed:image];
    if (iOS7) {
        childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } else {
        childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImage];
    }
    
    
    //设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = ZBColor(123, 123, 123);
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
//    childVc.view.backgroundColor = ZBRandomColor;
    
    //给外面传进来的小控制器包装一个导航控制器
    ZBWNavigationController *nav = [[ZBWNavigationController alloc] initWithRootViewController:childVc];
    //添加为子控制器
    [self addChildViewController:nav];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.  
}

- (void)tabBarDidClickPlusButton:(ZBWTabBar *)tabBar
{
    ComposeViewController *compose = [[ComposeViewController alloc] init];
    ZBWNavigationController *nav = [[ZBWNavigationController alloc] initWithRootViewController:compose];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
