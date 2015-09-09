//
//  StatusPhotosView.m
//  ZBWeibo
//
//  Created by macAir on 15/8/17.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "StatusPhotosView.h"
#import "ZBWPhoto.h"
#import "StatusPhotoView.h"

#define ZBWStatusPhotoWH 70
#define ZBWStatusPhotoMargin 10
#define ZBWStatusPhotoMaxCol(count) ((count==4)?2:3)

@implementation StatusPhotosView

- (void)setPhotos:(NSArray *)photos
{
    _photos = photos;
    
    NSUInteger photosCount = photos.count;
    
    // 创建足够数量的imageView
    while (self.subviews.count < photos.count) {
        StatusPhotoView *photoView = [[StatusPhotoView alloc] init];
        [self addSubview:photoView];
    }
    // 遍历所有的图片控件，设置图片
    for (int i = 0; i<self.subviews.count; i++) {
        StatusPhotoView *photoView = self.subviews[i];
        
        if (i < photosCount) { // 显示
            photoView.photo = photos[i];
            photoView.hidden = NO;
        } else { // 隐藏
            photoView.hidden = YES;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    NSUInteger photosCount = self.photos.count;
    int maxCol = ZBWStatusPhotoMaxCol(photosCount);
    for (int i = 0; i<photosCount; i++) {
        StatusPhotoView *photoView = self.subviews[i];
        
        int col = i % maxCol;
        photoView.x = col * (ZBWStatusPhotoWH + ZBWStatusPhotoMargin);
        
        int row = i / maxCol;
        photoView.y = row * (ZBWStatusPhotoWH + ZBWStatusPhotoMargin);
        photoView.width = ZBWStatusPhotoWH;
        photoView.height = ZBWStatusPhotoWH;
    }
}

+ (CGSize)sizeWithCount:(NSUInteger)count
{
    // 最大列数
     int maxCols = ZBWStatusPhotoMaxCol(count);
    
    // 列数
    NSUInteger cols = (count >= maxCols)? maxCols : count;
    CGFloat photosW = cols * ZBWStatusPhotoWH + (cols - 1) * ZBWStatusPhotoMargin;
    
    // 行数
    NSUInteger rows = (count + maxCols - 1) / maxCols;
    CGFloat photosH = rows * ZBWStatusPhotoWH + (rows - 1) * ZBWStatusPhotoMargin;
    
    return CGSizeMake(photosW, photosH);
}



@end
