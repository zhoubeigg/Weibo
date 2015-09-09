//
//  UIBarButtonItem+Extension.h
//  ZBWeibo
//
//  Created by macAir on 15/7/31.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithTarget:(id)target Action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;
@end
