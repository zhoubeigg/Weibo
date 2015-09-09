//
//  Emotion.m
//  ZBWeibo
//
//  Created by macAir on 15/8/23.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "Emotion.h"

@interface Emotion() <NSCoding>

@end
@implementation Emotion

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.chs = [decoder decodeObjectForKey:@"chs"];
        self.png = [decoder decodeObjectForKey:@"png"];
        self.code = [decoder decodeObjectForKey:@"code"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.chs forKey:@"chs"];
    [encoder encodeObject:self.png forKey:@"png"];
    [encoder encodeObject:self.code forKey:@"code"];
}

// 常用来比较两个对象是否一样
- (BOOL)isEqual:(Emotion *)other
{
    return [self.chs isEqualToString:other.chs] || [self.code isEqualToString:other.code];
}

@end
