//
//  ZBWNavigationController.m
//  ZBWeibo
//
//  Created by macAir on 15/7/30.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "ZBWNavigationController.h"

@interface ZBWNavigationController ()

@end

@implementation ZBWNavigationController

+ (void)initialize
{
    //设置项目所有的item主题样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    //设置普通状态
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:15];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    //设置不可用状态
    NSMutableDictionary *disableTextAttrs = [NSMutableDictionary dictionary];
    disableTextAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.7];
    disableTextAttrs[NSFontAttributeName] = textAttrs[NSFontAttributeName];
    [item setTitleTextAttributes:disableTextAttrs forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// 重写这个方法可以拦截所有push进来的控制器
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 保证push进来的控制器不是第一个控制器（跟控制器）
        
        viewController.hidesBottomBarWhenPushed = YES;
        
        /*设置导航栏上面的内容*/
        
        //设置左边的返回按钮
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(back) image:@"navigationbar_back" highImage:@"navigationbar_back_highlighted"];
        
        //设置右边的更多按钮
        
        viewController.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(more) image:@"navigationbar_more" highImage:@"navigationbar_more_highlighted"];
    }

    
    [super pushViewController:viewController animated:animated];
    
    
}

- (void)more
{
    [self popToRootViewControllerAnimated:YES];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
