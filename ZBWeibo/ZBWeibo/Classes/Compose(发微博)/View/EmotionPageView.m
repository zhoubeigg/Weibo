//
//  EmotionPageView.m
//  ZBWeibo
//
//  Created by macAir on 15/8/25.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//  用来表示每一页表情

#import "EmotionPageView.h"
#import "Emotion.h"
#import "EmotionPopView.h"
#import "EmotionButton.h"
#import "EmotionTool.h"

@interface EmotionPageView()
/** 点击表情按钮后弹出的放大镜 */
@property (nonatomic, strong) EmotionPopView *popView;
/** 删除按钮 */
@property (nonatomic, weak) UIButton *deleteButton;
@end

@implementation EmotionPageView

- (EmotionPopView *)popView
{
    if (!_popView) {
        self.popView = [EmotionPopView popView];
    }
    return _popView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 1、删除按钮
        UIButton *deleteButton = [[UIButton alloc] init];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete_highlighted"] forState:UIControlStateHighlighted];
        [deleteButton setImage:[UIImage imageNamed:@"compose_emotion_delete"] forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
        self.deleteButton = deleteButton;
        
        // 2.添加长按手势
        [self addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressPageView:)]];
    }
    return self;
}

// 根据手指的位置找出所在的表情按钮
- (EmotionButton *)emotionButtonWithLocation:(CGPoint)location
{
    NSUInteger count = self.emotions.count;
    for (NSUInteger i = 0; i<count; i++) {
        EmotionButton *btn = self.subviews[i + 1];
        if (CGRectContainsPoint(btn.frame, location)) {
        
            // 已经找到手指所在的表情按钮了，就没有必要再往下遍历
            return btn;
        }
    }
    
    return nil;
}

// 在这个方法中处理长按手势
- (void)longPressPageView:(UILongPressGestureRecognizer *)recognizer
{
    CGPoint location = [recognizer locationInView:recognizer.view];
    // 获得手指所在位置的表情按钮
    EmotionButton *btn = [self emotionButtonWithLocation:location];
    
    switch (recognizer.state) {
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:{  // 手指已经不再触摸pageview
            // 移除popview
            [self.popView removeFromSuperview];
            
            // 如果手指还在表情按钮上
            if (btn) {
                // 发出通知
                [self selectEmotion:btn.emotion];
            }
            break;
        }
            
        case UIGestureRecognizerStateBegan:// 手势开始（刚检测到长按）
        case UIGestureRecognizerStateChanged:{ // 手势改变（手指的位置改变）
            [self.popView showFrom:btn];
            break;
        }
         default:
            
            break;
    }
}

- (void)setEmotions:(NSArray *)emotions
{
    _emotions = emotions;
    
    NSUInteger count = emotions.count;
    for (int i = 0; i<count; i++) {
        EmotionButton *btn = [[EmotionButton alloc] init];
        [self addSubview:btn];
        
        // 设置表情数据
        btn.emotion = emotions[i];
        
        // 监听按钮点击
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 内边距（四周）
    CGFloat inset = 10;
    NSUInteger count = self.emotions.count;
    CGFloat btnW = (self.width - 2 * inset) / EmotionMaxCols;
    CGFloat btnH = (self.height -  inset) / EmotionMaxRows;
    for (int i = 0; i<count; i++) {
        UIButton *btn = self.subviews[i + 1];
        btn.width = btnW;
        btn.height = btnH;
        btn.x = inset + (i%EmotionMaxCols) * btnW;
        btn.y = inset + (i/EmotionMaxCols) * btnH;
    }
    
    // 删除按钮位置
    self.deleteButton.width = btnW;
    self.deleteButton.height = btnH;
    self.deleteButton.y = self.height - btnH;
    self.deleteButton.x = self.width - inset - btnW;
}

// 监听删除按钮点击
- (void)deleteClick
{
    [ZBWNotificationCenter postNotificationName:ZBWEmotionDidDeleteNotification object:nil];
}

// 监听表情按钮点击
- (void)btnClick:(EmotionButton *)btn
{
    // 显示popview
    [self.popView showFrom:btn];
    
    // 等会让popview自动消失
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.popView removeFromSuperview];
    });
    
    // 发出通知
    [self selectEmotion:btn.emotion];
}

// 选中某个表情，发出通知
- (void)selectEmotion:(Emotion *)emotion
{
    // 将这个表情存进沙盒
    [EmotionTool addRecentEmotion:emotion];
    
    // 发出通知
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[ZBWSelectEmotionKey] = emotion;
    [ZBWNotificationCenter postNotificationName:ZBWEmotionDidSelectNotification object:nil userInfo:userInfo];
}



@end
