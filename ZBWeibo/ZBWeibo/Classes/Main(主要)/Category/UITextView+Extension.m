//
//  UITextView+Extension.m
//  ZBWeibo
//
//  Created by macAir on 15/8/27.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "UITextView+Extension.h"

@implementation UITextView (Extension)
- (void) insertAttributedText:(NSAttributedString *)text
{
    [self insertAttributedText:text settingBlock:nil];
}

- (void)insertAttributedText:(NSAttributedString *)text settingBlock:(void (^)(NSMutableAttributedString *))settingBlock
{
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] init];
    // 拼接之前的文字（图片和普通文字）
    [attributedText appendAttributedString:self.attributedText];
    
    // 拼接其它文字
    NSUInteger loc = self.selectedRange.location;
    // replace比insert功能更好
    [attributedText replaceCharactersInRange:self.selectedRange withAttributedString:text];
    
    // 调用外面传进来的代码
    if (settingBlock) {
        settingBlock(attributedText);
    }
    
    self.attributedText = attributedText;
    
    // 移动光标到插入表情的后面
    self.selectedRange = NSMakeRange(loc + 1, 0);
}

@end
