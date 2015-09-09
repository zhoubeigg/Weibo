//
//  EmotionButton.h
//  ZBWeibo
//
//  Created by macAir on 15/8/25.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Emotion;
@interface EmotionButton : UIButton
@property (nonatomic, strong) Emotion *emotion;
@end
