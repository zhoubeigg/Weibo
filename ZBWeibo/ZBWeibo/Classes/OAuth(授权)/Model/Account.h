//
//  Account.h
//  ZBWeibo
//
//  Created by macAir on 15/8/5.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Account : NSObject <NSCoding>

@property (nonatomic, copy) NSString *access_token;
@property (nonatomic, copy) NSNumber *expires_in;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, strong) NSDate *created_time;
@property (nonatomic, copy) NSString *name;

+ (instancetype)accountWithDict:(NSDictionary *)dict;
@end
