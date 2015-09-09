//
//  ZWBStatusFrame.h
//  ZBWeibo
//
//  Created by macAir on 15/8/12.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//  一个ZWBStatusFrame模型里面包含的信息
//  1.存放着一个cell内部所有子控件的frame数据
//  2.存放着一个cell的高度
//  3.存放着一个数据模型ZBWStatus

#import <Foundation/Foundation.h>
// 昵称字体
#define StatusCellNameFont [UIFont systemFontOfSize:15]
// 时间字体
#define StatusCellTimeFont [UIFont systemFontOfSize:12]
// 来源字体
#define StatusCellSourceFont [UIFont systemFontOfSize:12]
// 正文字体
#define StatusCellContentFont [UIFont systemFontOfSize:14]
// 被转发微博正文字体
#define RetweetStatusCellContentFont [UIFont systemFontOfSize:13]
// cell之间的间距
#define StatusCellMargin 15
// cell的边框宽度
#define StatusCellBorderW 10


@class ZBWStatus;

@interface ZWBStatusFrame : NSObject
@property (nonatomic, strong) ZBWStatus *status;

/** 原创微博整体 */
@property (nonatomic, assign) CGRect originalViewF;
/** 头像 */
@property (nonatomic, assign) CGRect iconViewF;
/** 会员图标 */
@property (nonatomic, assign) CGRect vipViewF;
/** 微博配图 */
@property (nonatomic, assign) CGRect photosViewF;
/** 昵称 */
@property (nonatomic, assign) CGRect nameLabelF;
/** 发博时间 */
@property (nonatomic, assign) CGRect timeLabelF;
/** 来源 */
@property (nonatomic, assign) CGRect sourceLabelF;
/** 微博正文 */
@property (nonatomic, assign) CGRect contentLabelF;

/** 转发微博整体 */
@property (nonatomic, assign) CGRect retweetViewF;
/** 转发微博昵称+正文 */
@property (nonatomic, assign) CGRect retweetContentLabelF;
/** 转发微博配图 */
@property (nonatomic, assign) CGRect retweetphotosViewF;

/** 工具条 */
@property (nonatomic, assign) CGRect toolbarF;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
@end
