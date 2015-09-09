//
//  ZBWHttpTool.h
//  ZBWeibo
//
//  Created by macAir on 15/9/1.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBWHttpTool : NSObject
+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^) (NSError *error))failure;

+ (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^) (NSError *error))failure;
@end
