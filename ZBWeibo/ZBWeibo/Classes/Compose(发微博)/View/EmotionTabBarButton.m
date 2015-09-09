//
//  EmotionTabBarButton.m
//  ZBWeibo
//
//  Created by macAir on 15/8/23.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "EmotionTabBarButton.h"

@implementation EmotionTabBarButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置文字颜色
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateDisabled];
        // 设置字体
        self.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted
{
    //按钮高亮所做的一切操作都不在了 
}

@end
