//
//  LoadMoreFooter.m
//  ZBWeibo
//
//  Created by macAir on 15/8/11.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "LoadMoreFooter.h"

@implementation LoadMoreFooter

+ (instancetype)footer
{
    return [[[NSBundle mainBundle] loadNibNamed:@"LoadMoreFooter" owner:nil options:nil] lastObject];
}

@end
