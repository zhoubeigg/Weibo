//
//  EmotionTabBar.h
//  ZBWeibo
//
//  Created by macAir on 15/8/22.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    EmotionTabBarButtonTypeRecent,
    EmotionTabBarButtonTypeDefault,
    EmotionTabBarButtonTypeEmoji,
    EmotionTabBarButtonTypeLxh
} EmotionTabBarButtonType;

@class EmotionTabBar;

@protocol EmotionTabBarDelegate <NSObject>

@optional
- (void)emotionTabBar:(EmotionTabBar *)tabBar didSelectButton:(EmotionTabBarButtonType)buttonType;
@end

@interface EmotionTabBar : UIView
@property (nonatomic, weak) id<EmotionTabBarDelegate> delegate;
@end
