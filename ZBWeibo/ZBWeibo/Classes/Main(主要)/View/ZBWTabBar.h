//
//  ZBWTabBar.h
//  ZBWeibo
//
//  Created by macAir on 15/8/3.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZBWTabBar;

@protocol ZBWTabBarDelegate <UITabBarDelegate>
@optional
- (void)tabBarDidClickPlusButton:(ZBWTabBar *)tabBar;
@end

@interface ZBWTabBar : UITabBar
@property (nonatomic, weak) id<ZBWTabBarDelegate> delegate;
@end

