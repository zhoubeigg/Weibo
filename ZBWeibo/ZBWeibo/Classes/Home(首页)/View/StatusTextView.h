//
//  StatusTextView.h
//  ZBWeibo
//
//  Created by macAir on 15/9/2.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//  用来显示微博正文的textview

#import <UIKit/UIKit.h>

@interface StatusTextView : UITextView
/** 所有的特殊字符串（里面存放着ZBWSpecial） */
@property (nonatomic, strong) NSArray *specials;
@end
