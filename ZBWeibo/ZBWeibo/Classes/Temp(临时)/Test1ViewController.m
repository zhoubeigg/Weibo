//
//  Test1ViewController.m
//  ZBWeibo
//
//  Created by macAir on 15/7/30.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "Test1ViewController.h"
#import "Test2ViewController.h"

@interface Test1ViewController ()

@end

@implementation Test1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    Test2ViewController *test2 = [[Test2ViewController alloc] init];
    test2.title = @"测试2控制器";
    [self.navigationController pushViewController:test2 animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
