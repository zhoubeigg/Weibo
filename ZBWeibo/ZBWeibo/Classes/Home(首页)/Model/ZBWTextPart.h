//
//  ZBWTextPart.h
//  ZBWeibo
//
//  Created by macAir on 15/9/2.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBWTextPart : NSObject
/** 这段文字内容 */
@property (nonatomic, copy) NSString *text;
/** 这段文字的范围 */
@property (nonatomic, assign) NSRange range;
/** 是否为特殊文字 */
@property (nonatomic, assign, getter = isSpecial) BOOL special;
/** 是否为特殊文字 */
@property (nonatomic, assign, getter = isEmotion) BOOL emotion;
@end
