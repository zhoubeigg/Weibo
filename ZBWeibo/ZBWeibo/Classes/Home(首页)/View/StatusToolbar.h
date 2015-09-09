//
//  StatusToolbar.h
//  ZBWeibo
//
//  Created by macAir on 15/8/13.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZBWStatus;
@interface StatusToolbar : UIView
+ (instancetype)toolbar;
@property (nonatomic, strong) ZBWStatus *status;
@end
