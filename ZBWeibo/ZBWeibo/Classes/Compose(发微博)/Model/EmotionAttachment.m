//
//  EmotionAttachment.m
//  ZBWeibo
//
//  Created by macAir on 15/8/30.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "EmotionAttachment.h"
#import "Emotion.h"

@implementation EmotionAttachment

- (void)setEmotion:(Emotion *)emotion
{
    _emotion = emotion;
    
    self.image = [UIImage imageNamed:emotion.png];
}

@end
