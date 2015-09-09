//
//  ZBWUser.m
//  ZBWeibo
//
//  Created by macAir on 15/8/10.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//  用户模型

#import "ZBWUser.h"

@implementation ZBWUser

- (void)setMbtype:(int)mbtype
{
    _mbtype = mbtype;
    self.vip = mbtype > 2;
}

@end
