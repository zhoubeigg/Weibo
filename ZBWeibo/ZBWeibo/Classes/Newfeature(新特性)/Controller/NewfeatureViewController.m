//
//  NewfeatureViewController.m
//  ZBWeibo
//
//  Created by macAir on 15/8/3.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "NewfeatureViewController.h"
#import "TabBarViewController.h"

#define ZBWNewfeatureCount 4

@interface NewfeatureViewController () <UIScrollViewDelegate>
@property (nonatomic, weak) UIPageControl *pageControl;
@end

@implementation NewfeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.创建一个scrollView：显示所有的新特性图片
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    [self.view addSubview:scrollView];
    
    // 2.添加图片到scrollView中
    CGFloat scrollW = scrollView.width;
    CGFloat scrollH = scrollView.height;
    for (int i = 0; i < ZBWNewfeatureCount; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.width = scrollW;
        imageView.height = scrollH;
        imageView.y = 0;
        imageView.x = i * scrollW;
        // 显示图片
        NSString *name = [NSString stringWithFormat:@"new_feature_%i", i + 1];
        imageView.image = [UIImage imageNamed:name];
        [scrollView addSubview:imageView];
        
        // 如果是最后一个imageView，就往里面添加其他的内容
        if (i == ZBWNewfeatureCount - 1) {
            [self setupLastImageView:imageView];
        }
    }
    
    // 3.设置scrollView的其他属性
    scrollView.contentSize = CGSizeMake(ZBWNewfeatureCount * scrollW, 0);
    scrollView.bounces = NO; //去除弹簧效果
    scrollView.pagingEnabled = YES; //自动分页
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    // 4.添加pagecontrol：分页展示目前是多少页
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = ZBWNewfeatureCount;
    pageControl.width = 100;
    pageControl.currentPageIndicatorTintColor = ZBColor(253, 98, 42);
    pageControl.pageIndicatorTintColor = ZBColor(189, 189, 189);
    pageControl.centerX = scrollW * 0.5;
    pageControl.centerY = scrollH - 50;
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
}

#pragma mark - scrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x / scrollView.width + 0.5;  //四舍五入计算出页码
    self.pageControl.currentPage = page; 
}

- (void)setupLastImageView:(UIImageView *)imageView
{
    // 开启交互功能
    imageView.userInteractionEnabled = YES;
    
    // 1.分享给大家（checkbox）
    UIButton *shareBtn = [[UIButton alloc] init];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_false"] forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"new_feature_share_true"] forState:UIControlStateSelected];
    [shareBtn setTitle:@"分享给大家" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    shareBtn.width = 200; 
    shareBtn.height = 30;
    shareBtn.centerX = imageView.width * 0.5;
    shareBtn.centerY = imageView.height * 0.65;
    [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    //设置按钮内图片和文字的间距
    shareBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [imageView addSubview:shareBtn];
    
    // 2.开始微博
    UIButton *startBtn = [[UIButton alloc] init];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button"] forState:UIControlStateNormal];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"new_feature_finish_button_highlighted"] forState:UIControlStateHighlighted];
    startBtn.size = startBtn.currentBackgroundImage.size;
    startBtn.centerX = shareBtn.centerX;
    startBtn.centerY = imageView.height * 0.75;
    [startBtn setTitle:@"开始微博" forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startClick) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:startBtn];
    
}

- (void)shareClick:(UIButton *)shareBtn
{
    shareBtn.selected = !shareBtn.isSelected;
}

- (void)startClick
{
    /*
     切换控制器的方法：
     1.push：依赖于导航控制器，push操作是可逆的
     2.modal：控制器切换是可逆的，以前的控制器没有销毁
     3.切换window的rootViewController
     */
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = [[TabBarViewController alloc] init];
}

@end
