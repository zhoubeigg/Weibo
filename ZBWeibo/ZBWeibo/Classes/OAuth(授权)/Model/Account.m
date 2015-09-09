//
//  Account.m
//  ZBWeibo
//
//  Created by macAir on 15/8/5.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "Account.h"

@implementation Account
+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    Account *account = [[self alloc] init];
    account.access_token = dict[@"access_token"];
    account.uid = dict[@"uid"];
    account.expires_in = dict[@"expires_in"];
    // 获得账号存储的是时间（accessToken的产生时间)
    account.created_time = [NSDate date];
    return account;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.access_token forKey:@"access_token"];
    [aCoder encodeObject:self.expires_in forKey:@"expires_in"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.created_time forKey:@"created_time"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.access_token = [aDecoder decodeObjectForKey:@"access_token"];
        self.expires_in = [aDecoder decodeObjectForKey:@"expires_in"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.created_time = [aDecoder decodeObjectForKey:@"created_time"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

@end
