//
//  Test2ViewController.m
//  ZBWeibo
//
//  Created by macAir on 15/7/30.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "Test2ViewController.h"
#import "Test3ViewController.h"

@interface Test2ViewController ()

@end

@implementation Test2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
  }


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    Test3ViewController *test3 = [[Test3ViewController alloc] init];
    test3.title = @"测试3控制器";
    [self.navigationController pushViewController:test3 animated:YES];
}


@end
