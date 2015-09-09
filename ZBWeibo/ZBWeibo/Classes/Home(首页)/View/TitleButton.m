//
//  TitleButton.m
//  ZBWeibo
//
//  Created by macAir on 15/8/10.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "TitleButton.h"
#define ZBWMargin 10

@implementation TitleButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_down"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"navigationbar_arrow_up"] forState:UIControlStateSelected];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    frame.size.width += ZBWMargin;
    [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 1.计算titleLabel的frame
    self.titleLabel.x = self.imageView.x;
    
    // 2.计算imageView的frame
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + ZBWMargin;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state
{
    [super setTitle:title forState:state];
    [self layoutSubviews];
    [self sizeToFit];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state
{
    [super setImage:image forState:state];
    
    [self sizeToFit];
}
@end
