//
//  MessageCenterViewController.m
//  ZBWeibo
//
//  Created by macAir on 15/7/29.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "MessageCenterViewController.h"
#import "Test1ViewController.h"

@interface MessageCenterViewController ()

@end

@implementation MessageCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"写私信" style:UIBarButtonItemStylePlain target:self action:@selector(composeMsg)];
    
    //禁用这个item
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)composeMsg {
    
    NSLog(@"composeMsg---");
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Test-message-%d", (int)indexPath.row];
    
    return cell;
}

#pragma mark - 代理方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Test1ViewController *test1 = [[Test1ViewController alloc] init];
    test1.title = @"测试1控制器";
    //当test1控制器被push的时候，隐藏tabBar
//    test1.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:test1 animated:YES];
}

@end
