//
//  EmotionTool.m
//  ZBWeibo
//
//  Created by macAir on 15/8/31.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

// 最近表情的存储路径
#define RecentEmotionPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"emotions.archive"]

#import "Emotion.h"
#import "EmotionTool.h"
#import "MJExtension.h"

@implementation EmotionTool

static NSMutableArray *_recentEmotions;

+ (void)initialize
{
    // 加载沙盒中的表情数据
    _recentEmotions = [NSKeyedUnarchiver unarchiveObjectWithFile:RecentEmotionPath];
    if (_recentEmotions == nil) {
        _recentEmotions = [NSMutableArray array];
    }
}

// 根据文字描述返回对应的表情
+ (Emotion *)emotionWithChs:(NSString *)chs
{
    NSArray *defaults = [self defaultEmotions];
    for (Emotion *emotion in defaults) {
        if ([emotion.chs isEqualToString:chs]) return emotion;
    }
    
    NSArray *lxhs = [self lxhEmotions];
    for (Emotion *emotion in lxhs) {
        if ([emotion.chs isEqualToString:chs]) return emotion;
    }
    
    return nil;
}

+ (void)addRecentEmotion:(Emotion *)emotion
{
    // 删除重复的表情（需要重写isEqual方法，默认是比较内存地址）
    [_recentEmotions removeObject:emotion];
    
    // 讲表情放进数组的最前面
    [_recentEmotions insertObject:emotion atIndex:0];
    
    // 将所有的表情存进沙盒
    [NSKeyedArchiver archiveRootObject:_recentEmotions toFile:RecentEmotionPath];
}

+ (NSArray *)recentEmotions
{
    return _recentEmotions;
}


static NSArray *_emojiEmotions, *_defaultEmotions, *_lxhEmotions;
+ (NSArray *)emojiEmotions
{
    if (!_emojiEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/emoji/info.plist" ofType:nil];
        _emojiEmotions =  [Emotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _emojiEmotions;
}

+ (NSArray *)defaultEmotions
{
    if (!_defaultEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/default/info.plist" ofType:nil];
        _defaultEmotions = [Emotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _defaultEmotions;
}

+ (NSArray *)lxhEmotions
{
    if (!_lxhEmotions) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"EmotionIcons/lxh/info.plist" ofType:nil];
        _lxhEmotions = [Emotion objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    }
    return _lxhEmotions;
}
@end
