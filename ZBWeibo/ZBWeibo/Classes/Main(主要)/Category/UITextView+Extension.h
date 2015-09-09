//
//  UITextView+Extension.h
//  ZBWeibo
//
//  Created by macAir on 15/8/27.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextView (Extension)
- (void) insertAttributedText:(NSAttributedString *)text;
- (void) insertAttributedText:(NSAttributedString *)text settingBlock:(void (^)(NSMutableAttributedString *attributedText))settingBlock;
@end
