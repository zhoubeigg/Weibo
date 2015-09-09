//
//  EmotionTextView.m
//  ZBWeibo
//
//  Created by macAir on 15/8/27.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "EmotionTextView.h"
#import "Emotion.h"
#import "EmotionAttachment.h"

@implementation EmotionTextView

- (void)insertEmotion:(Emotion *)emotion
{
    if (emotion.code) {
        [self insertText:emotion.code.emoji];
    } else if (emotion.png) {
                
        // 加载图片
        EmotionAttachment *attch = [[EmotionAttachment alloc] init];
        
        // 传递模型
        attch.emotion = emotion;
        
        // 设置图片和尺寸
        CGFloat attchWH = self.font.lineHeight;
        attch.bounds = CGRectMake(0, -4, attchWH, attchWH);
        
        // 根据附件创建一个属性文字
        NSAttributedString *imageStr = [NSAttributedString attributedStringWithAttachment:attch];
        
        // 插入属性文字到光标
        [self insertAttributedText:imageStr settingBlock:^(NSMutableAttributedString *attributedText) {
             // 设置字体
            [attributedText addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, attributedText.length)];
        }];
//
//        NSMutableAttributedString *text = (NSMutableAttributedString *)self.attributedText;
//        [text addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, text.length)];

    } 
}

- (NSString *)fullText
{
    NSMutableString *fullText = [NSMutableString string];
    
    // 遍历所有的属性文字（图片、emoji、普通文字）
    [self.attributedText enumerateAttributesInRange:NSMakeRange(0, self.attributedText.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        // 如果是图片表情
        EmotionAttachment *attch = attrs[@"NSAttachment"];
        if (attch) {
            [fullText appendString:attch.emotion.chs];
        } else { // emoji,普通文本
            // 获得这个范围内的文字
            NSAttributedString *str = [self.attributedText attributedSubstringFromRange:range];
            [fullText appendString:str.string];
        }
    }];
    
    return fullText;
}

@end
