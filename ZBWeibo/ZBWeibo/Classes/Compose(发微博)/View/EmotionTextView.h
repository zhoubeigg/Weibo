//
//  EmotionTextView.h
//  ZBWeibo
//
//  Created by macAir on 15/8/27.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "ZBWTextView.h"
@class Emotion;

@interface EmotionTextView : ZBWTextView
- (void)insertEmotion:(Emotion *)emotion;
- (NSString *)fullText;
@end
