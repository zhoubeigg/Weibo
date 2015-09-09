//
//  AccountTool.h
//  ZBWeibo
//
//  Created by macAir on 15/8/6.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Account.h"

@interface AccountTool : NSObject
+ (void)saveAccount:(Account *)account;
+ (Account *)account;
@end
