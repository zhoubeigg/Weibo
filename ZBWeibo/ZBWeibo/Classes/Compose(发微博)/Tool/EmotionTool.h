//
//  EmotionTool.h
//  ZBWeibo
//
//  Created by macAir on 15/8/31.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Emotion;

@interface EmotionTool : NSObject
+ (void)addRecentEmotion:(Emotion *)emotion;
+ (NSArray *)recentEmotions;
+ (NSArray *)defaultEmotions;
+ (NSArray *)lxhEmotions;
+ (NSArray *)emojiEmotions;

/** 根据文字描述返回对应的表情 */
+ (Emotion *)emotionWithChs:(NSString *)chs;
@end
