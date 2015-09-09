//
//  EmotionPageView.h
//  ZBWeibo
//
//  Created by macAir on 15/8/25.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//  用来表示每一页表情

#import <UIKit/UIKit.h>

// 一行最多是7列
#define EmotionMaxCols 7
// 每页中最多3行
#define EmotionMaxRows 3
// 每一页的表情个数
#define EmotionPageSize ((EmotionMaxRows * EmotionMaxCols) - 1)

@interface EmotionPageView : UIView
/** 这一页显示的表情（里面都是Emotion模型） */
@property (nonatomic, strong) NSArray *emotions;
@end
