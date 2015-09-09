//
//  StatusPhotosView.h
//  ZBWeibo
//
//  Created by macAir on 15/8/17.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusPhotosView : UIView
@property (nonatomic, strong) NSArray *photos;
// 根据图片个数计算尺寸
+ (CGSize)sizeWithCount:(NSUInteger)count;
@end
