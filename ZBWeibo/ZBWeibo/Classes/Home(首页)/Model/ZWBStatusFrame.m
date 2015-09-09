//
//  ZWBStatusFrame.m
//  ZBWeibo
//
//  Created by macAir on 15/8/12.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//  一个ZWBStatusFrame模型里面包含的信息
//  1.存放着一个cell内部所有子控件的frame数据
//  2.存放着一个cell的高度
//  3.存放着一个数据模型ZBWStatus

#import "ZWBStatusFrame.h"
#import "ZBWStatus.h"
#import "ZBWUser.h"
#import "StatusPhotosView.h"

@implementation ZWBStatusFrame

- (void)setStatus:(ZBWStatus *)status
{
    _status = status;
    
    ZBWUser *user = status.user;
    
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /** 原创微博 */
    /** 头像 */
    CGFloat iconWH = 35;
    CGFloat iconX = StatusCellBorderW;
    CGFloat iconY = StatusCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + StatusCellBorderW;
    CGFloat nameY = iconY;
    CGSize nameSize = [user.name sizeWithFont:StatusCellNameFont];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    /** 会员图标 */
    if (user.isVip) {
        CGFloat vipX = CGRectGetMaxX(self.nameLabelF) + StatusCellBorderW;
        CGFloat vipY = nameY;
        CGFloat vipH = nameSize.height;
        CGFloat vipW = 14;
        self.vipViewF = CGRectMake(vipX, vipY, vipW, vipH);
    }
    
    /** 发博时间 */
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + StatusCellBorderW;
    CGSize timeSize = [status.created_at sizeWithFont:StatusCellTimeFont];
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
   
    /** 来源 */
    CGFloat sourceX = CGRectGetMaxX(self.timeLabelF) + StatusCellBorderW;
    CGFloat sourceY = timeY;
    CGSize sourceSize = [status.source sizeWithFont:StatusCellSourceFont];
    self.sourceLabelF = (CGRect){{sourceX, sourceY}, sourceSize};
    
    /** 微博正文 */
    CGFloat contentX = iconX;
    CGFloat contentY = MAX(CGRectGetMaxY(self.iconViewF), CGRectGetMaxY(self.timeLabelF)) + StatusCellBorderW;
    CGFloat maxW = cellW - 2 *contentX;
    CGSize contentSize = [status.attributedText boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    self.contentLabelF = (CGRect){{contentX, contentY}, contentSize};

    /** 微博配图 */
    CGFloat originalH = 0;
    if (status.pic_urls.count) { // 有配图
        CGFloat photosX = contentX;
        CGFloat photosY = CGRectGetMaxY(self.contentLabelF) + StatusCellBorderW;
        CGSize photosSize = [StatusPhotosView sizeWithCount:status.pic_urls.count];
        self.photosViewF = (CGRect){{photosX, photosY}, photosSize};
        
        originalH = CGRectGetMaxY(self.photosViewF) + StatusCellBorderW;
    } else { // 没有配图
        originalH = CGRectGetMaxY(self.contentLabelF) + StatusCellBorderW;
    }
    
    /** 原创微博整体 */
    CGFloat originalX = 0;
    CGFloat originalY = StatusCellMargin;
    CGFloat originalW = cellW;
    self.originalViewF = CGRectMake(originalX, originalY, originalW, originalH);
    
    CGFloat toolbarY = 0;
    /** 被转发微博*/
    if (status.retweeted_status) {
        ZBWStatus *retweeted_status = status.retweeted_status;
//        ZBWUser *retweeted_status_user = retweeted_status.user;
        
     /** 被转发微博正文 */
        CGFloat retweetContentX = StatusCellBorderW;
        CGFloat retweetContentY = StatusCellBorderW;
        CGSize retweetContentSize = [status.retweetedAttributedText boundingRectWithSize:CGSizeMake(maxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        self.retweetContentLabelF = (CGRect){{retweetContentX, retweetContentY}, retweetContentSize};
        
      /** 被转发微博配图 */
        CGFloat retweetH = 0;
        if (retweeted_status.pic_urls.count) { // 转发微博有配图
            CGFloat retweetPhotosX = retweetContentX;
            CGFloat retweetPhotosY = CGRectGetMaxY(self.retweetContentLabelF) + StatusCellBorderW;
            CGSize retweetphotosSize = [StatusPhotosView sizeWithCount:retweeted_status.pic_urls.count];
            self.retweetphotosViewF = (CGRect){{retweetPhotosX, retweetPhotosY}, retweetphotosSize};
            
            retweetH = CGRectGetMaxY(self.retweetphotosViewF) + StatusCellBorderW;
        } else { // 转发微博没有配图
            retweetH = CGRectGetMaxY(self.retweetContentLabelF) + StatusCellBorderW;
        }
        
         /** 被转发微博整体 */
        CGFloat retweetX = 0;
        CGFloat retweetY = CGRectGetMaxY(self.originalViewF);
        CGFloat retweetW = cellW;
        self.retweetViewF = CGRectMake(retweetX, retweetY, retweetW, retweetH);
        
        toolbarY = CGRectGetMaxY(self.retweetViewF);
    } else {
        toolbarY = CGRectGetMaxY(self.originalViewF);
    }
    /** 工具条 */
    CGFloat toolbarX = 0;
    CGFloat toolbarW = cellW;
    CGFloat toolbarH = 35;
    self.toolbarF = CGRectMake(toolbarX, toolbarY, toolbarW, toolbarH);

    /** cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.toolbarF);
}
@end
