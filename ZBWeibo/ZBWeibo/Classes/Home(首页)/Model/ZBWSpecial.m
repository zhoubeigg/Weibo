//
//  ZBWSpecial.m
//  ZBWeibo
//
//  Created by macAir on 15/9/4.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "ZBWSpecial.h"

@implementation ZBWSpecial
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@",self.text, NSStringFromRange(self.range)];
}
@end
