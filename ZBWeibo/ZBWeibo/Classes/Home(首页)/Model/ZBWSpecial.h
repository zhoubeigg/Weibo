//
//  ZBWSpecial.h
//  ZBWeibo
//
//  Created by macAir on 15/9/4.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBWSpecial : NSObject
/** 这段特殊文字内容 */
@property (nonatomic, copy) NSString *text;
/** 这段特殊文字的范围 */
@property (nonatomic, assign) NSRange range;
/** 这段特殊文字的矩形框（数组里面直接存放CGRect） */
@property (nonatomic, strong) NSArray *rects;
@end
