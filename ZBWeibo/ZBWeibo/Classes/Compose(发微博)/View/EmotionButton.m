//
//  EmotionButton.m
//  ZBWeibo
//
//  Created by macAir on 15/8/25.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "EmotionButton.h"
#import "Emotion.h"

@implementation EmotionButton

// 当控件从代码中创建时调用这个方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

// 当控件从xib中创建时调用这个方法
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    self.titleLabel.font = [UIFont systemFontOfSize:32];
    
    // 按钮高亮的时候，不要调整图片（不变灰）
    self.adjustsImageWhenHighlighted = NO;
}

- (void)setEmotion:(Emotion *)emotion
{
    _emotion = emotion;
    
    if (emotion.png) { // 有图片
        [self setImage:[UIImage imageNamed:emotion.png] forState:UIControlStateNormal];
    } else if (emotion.code) {
        // 设置emoj
        [self setTitle:emotion.code.emoji forState:UIControlStateNormal];
    }

}

@end
