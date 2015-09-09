//
//  EmotionKeyboard.m
//  ZBWeibo
//
//  Created by macAir on 15/8/22.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "EmotionKeyboard.h"
#import "EmotionListView.h"
#import "EmotionTabBar.h"
#import "Emotion.h"
#import "MJExtension.h"
#import "EmotionTool.h"

@interface EmotionKeyboard() <EmotionTabBarDelegate>
// 容纳表情内容的控件
@property (nonatomic, weak) UIView *contentView;
// 表情内容
@property (nonatomic, strong) EmotionListView *recentListView;
@property (nonatomic, strong) EmotionListView *defaultListView;
@property (nonatomic, strong) EmotionListView *emojiListView;
@property (nonatomic, strong) EmotionListView *lxhListView;

@property (nonatomic, weak) EmotionTabBar *tabBar;
@end

@implementation EmotionKeyboard

#pragma mark - 懒加载
- (EmotionListView *)recentListView
{
    if (!_recentListView) {
        self.recentListView = [[EmotionListView alloc] init];
        // 加载沙盒中得数据
        self.recentListView.emotions = [EmotionTool recentEmotions];
    }
    return _recentListView;
}

- (EmotionListView *)defaultListView
{
    if (!_defaultListView) {
        self.defaultListView = [[EmotionListView alloc] init];
        self.defaultListView.emotions = [EmotionTool defaultEmotions];
    }
    return _defaultListView;
}

- (EmotionListView *)emojiListView
{
    if (!_emojiListView) {
        self.emojiListView = [[EmotionListView alloc] init];
        self.emojiListView.emotions = [EmotionTool emojiEmotions];
    }
    return _emojiListView;
}

- (EmotionListView *)lxhListView
{
    if (!_lxhListView) {
        self.lxhListView = [[EmotionListView alloc] init];
        self.lxhListView.emotions = [EmotionTool lxhEmotions];
    }
    return _lxhListView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1.contentView
        UIView *contentView = [[UIView alloc] init];
        [self addSubview:contentView];
        self.contentView = contentView;
        
        // 2.tabBar
        EmotionTabBar *tabBar = [[EmotionTabBar alloc] init];
        tabBar.delegate = self;
        [self addSubview:tabBar];
        self.tabBar = tabBar;
        
        // 监听表情选中的通知
        [ZBWNotificationCenter addObserver:self selector:@selector(emotonDidSelect) name:ZBWEmotionDidSelectNotification object:nil];
    }
    return self;
}

- (void)emotonDidSelect
{
    self.recentListView.emotions = [EmotionTool recentEmotions];
}

- (void)dealloc
{
    [ZBWNotificationCenter removeObserver:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 1.tabBar
    self.tabBar.width = self.width;
    self.tabBar.height = 37;
    self.tabBar.x = 0;
    self.tabBar.y = self.height - self.tabBar.height;
    
    // 2.表情内容
    self.contentView.x = self.contentView.y = 0;
    self.contentView.width = self.width;
    self.contentView.height = self.tabBar.y;
    
    // 3.设置frame
    UIView *child = [self.contentView.subviews lastObject];
    child.frame = self.contentView.bounds;
}

#pragma mark - EmotionTabBarDelegate
- (void)emotionTabBar:(EmotionTabBar *)tabBar didSelectButton:(EmotionTabBarButtonType)buttonType
{
    // 移除contentView之前显示的控件
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 根据按钮的类型，切换contentView上面的listview
    switch (buttonType) {
        case EmotionTabBarButtonTypeRecent:{
            //ZBLog(@"最近");
            // 加载沙盒中得数据
//            self.recentListView.emotions = [EmotionTool recentEmotions];
            [self.contentView addSubview:self.recentListView];
            break;
        }
            
        case EmotionTabBarButtonTypeDefault:{
            //ZBLog(@"默认");
           [self.contentView addSubview:self.defaultListView];
            break;
        }
            
        case EmotionTabBarButtonTypeEmoji:{
            //ZBLog(@"Emoji");
           [self.contentView addSubview:self.emojiListView];
            break;
        }
            
        case EmotionTabBarButtonTypeLxh:{
            //ZBLog(@"浪小花");
           [self.contentView addSubview:self.lxhListView];
            break;
        }
    }
    
    // 重新计算子控件的frame
    [self setNeedsLayout];
}

@end
