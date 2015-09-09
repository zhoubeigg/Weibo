//
//  ZBWStatus.h
//  ZBWeibo
//
//  Created by macAir on 15/8/10.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZBWUser;

@interface ZBWStatus : NSObject

/**idstr	string	字符串型的微博ID*/
@property (nonatomic, copy) NSString *idstr;

/**text	string	微博信息内容*/
@property (nonatomic, copy) NSString *text;
/**text	string	微博信息内容 -- 带有属性的（特殊文字会高亮显示、显示表情）*/
@property (nonatomic, copy) NSAttributedString *attributedText;

/**user	object	微博作者的用户信息字段 详细*/
@property (nonatomic, strong) ZBWUser *user;

/** 微博创建时间 */
@property (nonatomic, copy) NSString *created_at;

/** 微博来源 */
@property (nonatomic, copy) NSString *source;

/** 微博配图地址 */
@property (nonatomic, strong) NSArray *pic_urls;

/** 转发的微博 */
@property (nonatomic, strong) ZBWStatus *retweeted_status;
/** 转发微博信息内容 -- 带有属性的（特殊文字会高亮显示、显示表情）*/
@property (nonatomic, copy) NSAttributedString *retweetedAttributedText;

/** 转发数 */
@property (nonatomic, assign) int reposts_count;

/** 评论数 */
@property (nonatomic, assign) int comments_count;

/** 表态数 */
@property (nonatomic, assign) int attitudes_count;
@end
