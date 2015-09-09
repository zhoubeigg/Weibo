//
//  HomeViewController.m
//  ZBWeibo
//
//  Created by macAir on 15/7/29.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "HomeViewController.h"
#import "DropdownMenu.h"
#import "TitleMenuViewController.h"
#import "ZBWHttpTool.h"
#import "AccountTool.h"
#import "TitleButton.h"
#import "UIImageView+WebCache.h"
#import "ZBWUser.h"
#import "ZBWStatus.h"
#import "MJExtension.h"
#import "LoadMoreFooter.h"
#import "StatusCell.h"
#import "ZWBStatusFrame.h"
#import "MJRefresh.h"

@interface HomeViewController () <DropdownMenuDelegate>
@property (nonatomic, strong) NSMutableArray *statusFrames;
@end

@implementation HomeViewController

- (NSMutableArray *)statusFrames
{
    if (!_statusFrames) {
        self.statusFrames = [NSMutableArray array];
    }
    return _statusFrames;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = ZBColor(211, 211, 211);
    
    // 设置导航栏内容
    [self setupNav];
    
    // 获得用户信息（昵称）
    [self setupUserInfo];
    
    // 下拉刷新
    [self setupDonwnRefresh];
    
    // 上拉刷新
    [self setupUpRefresh];
    
    // 获得未读数
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(setupUnreadCount) userInfo:nil repeats:YES];
    // 让主线程抽时间处理timer
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

// 获得未读数
- (void)setupUnreadCount
{

    // 1.拼接请求参数
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 2.发送请求
    [ZBWHttpTool get:@"https://rm.api.weibo.com/2/remind/unread_count.json" params:params success:^(id json) {
        // 显示微博的未读数
        NSString *status = [json[@"status"] description];
        if ([status isEqualToString:@"0"]) {
            self.tabBarItem.badgeValue = nil;
            [self registerUserNotification];
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        } else {
            self.tabBarItem.badgeValue = status;
            [self registerUserNotification];
            [UIApplication sharedApplication].applicationIconBadgeNumber = status.intValue;
        }

    } failure:^(NSError *error) {
        ZBLog(@"请求失败-%@",error);
    }];
}

// iOS8更新应用图标角标需要用户授权
- (void)registerUserNotification
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (version >= 8.0) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}

// 上拉刷新 
- (void)setupUpRefresh
{
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreStatus)];
}

// 集成下拉刷新控件
- (void)setupDonwnRefresh
{
    // 1.添加刷新控件
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewStatus)];
   
    // 2.进入下拉刷新状态
    [self.tableView headerBeginRefreshing];
}

// 进入下拉刷新状态
- (void)loadNewStatus
{
    // 1.拼接请求参数
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    //  取出最前面的微博（最新的微博，ID最大的微博）
    ZWBStatusFrame *firstStatusF = [self.statusFrames firstObject];
    if (firstStatusF) {
        params[@"since_id"] = firstStatusF.status.idstr;
    }
   
    // 2.发送请求
    [ZBWHttpTool get:@"https://api.weibo.com/2/statuses/friends_timeline.json" params:params success:^(id json) {
        // 将微博字典数组转换为微博模型数组
        NSArray *newStatuses = [ZBWStatus objectArrayWithKeyValuesArray:json[@"statuses"]];
        
        // 将 ZBWstatus数组 转为 ZWBStaFrame数组
        NSArray *newFrames = [self statusFramesWithStatuses:newStatuses];
        
        // 将最新的微博数据添加到总数组的最前面
        NSRange range = NSMakeRange(0, newFrames.count);
        NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
        [self.statusFrames insertObjects:newFrames atIndexes:set];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView headerEndRefreshing];
        
        // 显示最新的微博数量
        [self showNewStatusCount:newStatuses.count];
    } failure:^(NSError *error) {
        ZBLog(@"请求失败---%@",error);
        // 结束刷新
        [self.tableView headerEndRefreshing];

    }];

}

// 显示最新微博数
- (void)showNewStatusCount:(NSUInteger)count
{
    // 刷新成功（清空图标数字）
    self.tabBarItem.badgeValue = nil;
    [self registerUserNotification];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    // 1.创建label
    UILabel *label = [[UILabel alloc] init];
    label.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"timeline_new_status_background"]];
    label.width = [UIScreen mainScreen].bounds.size.width;
    label.height = 35;
    
    // 2.设置其他属性
    if (count == 0) {
        label.text = @"没有最新的微博，稍后再试";
    } else {
        label.text = [NSString stringWithFormat:@"共有%lu条新的微博", (unsigned long)count];
    }
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    
    // 3.添加
    label.y = 64 - label.height;
    [self.navigationController.view insertSubview:label belowSubview:self.navigationController.navigationBar];
    
    // 4.动画
    CGFloat duration = 1.0;
    [UIView animateWithDuration:duration animations:^{
        label.transform = CGAffineTransformMakeTranslation(0, label.height); // 移动一个label高度
    } completion:^(BOOL finished) {
        CGFloat delay = 1.0;
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionCurveLinear animations:^{
            label.transform = CGAffineTransformIdentity; // 回到原来位置    
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
    }];
}

// 将 ZBWstatus数组 转为 ZWBStaFrame数组
- (NSArray *)statusFramesWithStatuses:(NSArray *)statuses
{
    NSMutableArray *Frames = [NSMutableArray array];
    for (ZBWStatus *status in statuses) {
        ZWBStatusFrame *f = [[ZWBStatusFrame alloc] init];
        f.status = status;
        [Frames addObject:f];
    }
    return Frames;
}

/**
 *  加载更多的微博数据
 */
- (void)loadMoreStatus
{
    // 1.拼接请求参数
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    
    // 取出最后面的微博（最新的微博，ID最大的微博）
    ZWBStatusFrame *lastStatusF = [self.statusFrames lastObject];
    if (lastStatusF) {
        // 若指定此参数，则返回ID小于或等于max_id的微博，默认为0。
        // id这种数据一般都是比较大的，一般转成整数的话，最好是long long类型
        long long maxId = lastStatusF.status.idstr.longLongValue - 1;
        params[@"max_id"] = @(maxId);
    }
    
    // 2.发送请求
    [ZBWHttpTool get:@"https://api.weibo.com/2/statuses/friends_timeline.json" params:params success:^(id json) {
        // 将 "微博字典"数组 转为 "微博模型"数组
        NSArray *newStatuses = [ZBWStatus objectArrayWithKeyValuesArray:json[@"statuses"]];
        
        // 将 ZBWstatus数组 转为 ZWBStaFrame数组
        NSArray *newFrames = [self statusFramesWithStatuses:newStatuses];
        
        // 将更多的微博数据，添加到总数组的最后面
        [self.statusFrames addObjectsFromArray:newFrames];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新(隐藏footer)
        [self.tableView footerEndRefreshing];
    } failure:^(NSError *error) {
        ZBLog(@"请求失败-%@", error);
        
        // 结束刷新
        [self.tableView footerEndRefreshing];
    }];

}


- (void)setupNav
{
    /*设置导航栏上面的内容*/
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(friendSearch) image:@"navigationbar_friendsearch" highImage:@"navigationbar_friendsearch_highlighted"];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self Action:@selector(pop) image:@"navigationbar_pop" highImage:@"navigationbar_pop_highlighted"];
    
    //中间的标题按钮
    TitleButton *titleButton = [[TitleButton alloc] init];
   
    //设置图片和文字
    NSString *name = [AccountTool account].name;
    [titleButton setTitle:name?name:@"首页" forState:UIControlStateNormal];
    
    //监听标题按钮
    [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];

    self.navigationItem.titleView = titleButton;
    
}

// 获得用户信息
- (void)setupUserInfo
{
    //https://api.weibo.com/2/users/show.json
    
    // 1.拼接请求参数
    Account *account = [AccountTool account];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"access_token"] = account.access_token;
    params[@"uid"] = account.uid;
    
    // 2.发送请求
    [ZBWHttpTool get:@"https://api.weibo.com/2/users/show.json" params:params success:^(id json) {
        // 标题按钮
        UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
        // 设置名字
        ZBWUser *user = [ZBWUser objectWithKeyValues:json];
        //        NSString *name = responseObject[@"name"];
        [titleButton setTitle:user.name forState:UIControlStateNormal];
        // 存储昵称到沙盒
        account.name = user.name;
        [AccountTool saveAccount:account];
    } failure:^(NSError *error) {
        ZBLog(@"请求失败---%@",error);
    }];

}

// 点击标题
- (void)titleClick:(UIButton *)titleButton
{
    // 1.创建下拉菜单
    DropdownMenu *menu = [DropdownMenu menu];
    menu.delegate = self;

    // 2.设置内容
    TitleMenuViewController *vc = [[TitleMenuViewController alloc] init];
    vc.view.height = 200;
    vc.view.width = 150;
    menu.contentController = vc;
    // 3.显示
    [menu showFrom:titleButton];
    
}

- (void)friendSearch
{
    NSLog(@"friendSearch---");
}

- (void)pop
{
      NSLog(@"pop---");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DropdownMenuDelegate
// 下拉菜单被销毁
- (void)dropdownMenuDidDismiss:(DropdownMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    // 箭头向下
//    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
    titleButton.selected = NO;
}

- (void)dropdownMenuDidShow:(DropdownMenu *)menu
{
    UIButton *titleButton = (UIButton *)self.navigationItem.titleView;
    // 箭头向上
//    [titleButton setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateNormal];
    titleButton.selected = YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.statusFrames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 获得cell
    StatusCell *cell = [StatusCell cellWithTableView:tableView];

    // 给cell传递模型数据
    cell.statusFrame = self.statusFrames[indexPath.row];
    
    return cell;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    //    scrollView == self.tableView == self.view
//    // 如果tableView还没有数据，就直接返回
//    if (self.statusFrames.count == 0 || self.tableView.tableFooterView.isHidden == NO) return;
//    
//    CGFloat offsetY = scrollView.contentOffset.y;
//    // 当最后一个cell完全显示在眼前时，contentOffset的y值
//    CGFloat judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.height - self.tableView.tableFooterView.height;
//    if (offsetY >= judgeOffsetY) { // 最后一个cell完全进入视野范围内
//        // 显示footer
//        self.tableView.tableFooterView.hidden = NO;
//        
//        // 加载更多的微博数据
//        [self loadMoreStatus];
//    }
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZWBStatusFrame *frame = self.statusFrames[indexPath.row];
    return frame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
