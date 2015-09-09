//
//  ComposePhotosView.m
//  ZBWeibo
//
//  Created by macAir on 15/8/21.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "ComposePhotosView.h"

@implementation ComposePhotosView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _photos = [NSMutableArray array];
    }
    return self;
}

- (void)addPhoto:(UIImage *)photo
{
    UIImageView *photoView = [[UIImageView alloc] init];
    photoView.image = photo;
    [self addSubview:photoView];
    [_photos addObject:photo];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片的尺寸和位置
    NSUInteger count = self.subviews.count;
    int maxCol = 4;
    CGFloat imageWH = 70;
    CGFloat imageMargin = 10;
    
    for (NSUInteger i = 0; i<count; i++) {
        UIImageView *photoView = self.subviews[i];
        
        NSUInteger col = i % maxCol;
        photoView.x = col * (imageWH + imageMargin);
        
        NSUInteger row = i / maxCol;
        photoView.y = row * (imageWH + imageMargin);
        photoView.width = imageWH;
        photoView.height = imageWH;
    }
}

@end
