//
//  EmotionAttachment.h
//  ZBWeibo
//
//  Created by macAir on 15/8/30.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Emotion;

@interface EmotionAttachment : NSTextAttachment
@property (nonatomic, strong) Emotion *emotion;
@end
