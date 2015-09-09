//
//  ZBWStatus.m
//  ZBWeibo
//
//  Created by macAir on 15/8/10.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//  微博模型

#import "ZBWStatus.h"
#import "MJExtension.h"
#import "ZBWPhoto.h"
#import "RegexKitLite.h"
#import "ZBWTextPart.h"
#import "ZBWUser.h"
#import "Emotion.h"
#import "EmotionTool.h"
#import "ZBWSpecial.h"

@implementation ZBWStatus
- (NSDictionary *)objectClassInArray
{
    return @{@"pic_urls" : [ZBWPhoto class]};
}

/** 普通文字转成属性文字 */
- (NSAttributedString *)attributedTextWithText:(NSString *)text
{
    // 利用text生成attributeText
    NSMutableAttributedString *attributeText = [[NSMutableAttributedString alloc] init];
    
    // 表情的规则
    NSString *emotonPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
    // @的规则
    NSString *atPattern = @"@[0-9a-zA-Z\\u4e00-\\u9fa5-_]+";
    // #话题#的规则
    NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
    // URL链接的规则
    NSString *urlPattern = @"\\b(([\\w-]+://?|www[.])[^\\s()<>]+(?:\\([\\w\\d]+\\)|([^[:punct:]\\s]|/)))";
    // 拼接所有规则
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@", emotonPattern, atPattern, topicPattern, urlPattern];
    
    // 遍历所有的特殊字符串
    NSMutableArray *parts = [NSMutableArray array];
    [text enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        
        ZBWTextPart *part = [[ZBWTextPart alloc] init];
        part.special = YES;
        part.text = *capturedStrings;
        part.emotion = [part.text hasPrefix:@"["] && [part.text hasSuffix:@"]"];
        part.range = *capturedRanges;
        [parts addObject:part];
    }];
    // 遍历所有的非特殊字符串
    [text enumerateStringsSeparatedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        
        ZBWTextPart *part = [[ZBWTextPart alloc] init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        [parts addObject:part];
    }];
    
    // 字符串碎片排序
    [parts sortUsingComparator:^NSComparisonResult(ZBWTextPart *part1, ZBWTextPart *part2) {
        return part1.range.location > part2.range.location ? NSOrderedDescending : NSOrderedAscending;
    }];
    
    UIFont *font = [UIFont systemFontOfSize:15];
    NSMutableArray *specials = [NSMutableArray array];
    // 按顺序拼接每一段文字
    for (ZBWTextPart *part in parts) {
        // 等会要拼接的子串
        NSAttributedString *substr = nil;
        if (part.isEmotion) { // 如果是表情
            NSTextAttachment *attch = [[NSTextAttachment alloc] init];
            NSString *name = [EmotionTool emotionWithChs:part.text].png;
            if (name) { // 能找到表情对应的图片
                attch.image = [UIImage imageNamed:name];
                attch.bounds = CGRectMake(0, -3, font.lineHeight, font.lineHeight);
                substr = [NSAttributedString attributedStringWithAttachment:attch];
            } else {// 表情图片不存在
                substr = [[NSAttributedString alloc] initWithString:part.text];
            }
            
        } else if (part.special) { // 非表情特殊文字
            substr = [[NSAttributedString alloc] initWithString:part.text attributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
            
            // 创建特殊对象
            ZBWSpecial *s = [[ZBWSpecial alloc] init];
            s.text = part.text;
            NSUInteger loc = attributeText.length;
            NSUInteger len = part.text.length;
            s.range = NSMakeRange(loc, len);
            [specials addObject:s];
        } else { // 非特殊文字
            substr = [[NSAttributedString alloc] initWithString:part.text];
        }
        [attributeText appendAttributedString:substr];
    }
    
    // 一定要设置属性文字的字体 保证计算出来的尺寸是正确的
    [attributeText addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributeText.length)];
    
    [attributeText addAttribute:@"specials" value:specials range:NSMakeRange(0, 1)];
    
    return attributeText;
}

- (void)setText:(NSString *)text
{
    _text = [text copy];

    self.attributedText = [self attributedTextWithText:text];
}

- (void)setRetweeted_status:(ZBWStatus *)retweeted_status
{
    _retweeted_status = retweeted_status;
    
    NSString *retweetContent = [NSString stringWithFormat:@"@%@ : %@", retweeted_status.user.name, retweeted_status.text];
    self.retweetedAttributedText = [self attributedTextWithText:retweetContent];
}

- (NSString *)created_at
{
    // NSString -> NSDate
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    // 如果是真机调试，转换这种欧美时间，需要设置local
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    
    // 设置日期格式
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss Z yyyy";
    // 微博的创建日期
    NSDate *createDate = [fmt dateFromString:_created_at];
    // 当前时间
    NSDate *now = [NSDate date];
    // 日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *cmps = [calendar components:unit fromDate:createDate toDate:now options:0];
    
    if ([createDate isThisYear]) { // 今年
        if ([createDate isYesterday]) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm";
            return [fmt stringFromDate:createDate];
        } else if ([createDate isToday]) { // 今天
            if (cmps.hour >= 1) {
                return [NSString stringWithFormat:@"%ld小时前", (long)cmps.hour];
            } else if (cmps.minute >= 1) {
                return [NSString stringWithFormat:@"%ld分钟前", (long)cmps.minute];
            } else {
                return @"刚刚";
            }
        } else { // 今年其他时间
            fmt.dateFormat = @"MM-dd HH:mm";
            return [fmt stringFromDate:createDate];
        }
    } else { // 不是今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm";
        return [fmt stringFromDate:createDate];
    }
}

- (void)setSource:(NSString *)source
{
    NSRange range;
    range.location = [source rangeOfString:@">"].location + 1;
    range.length = [source rangeOfString:@"</"].location - range.location;
//    ZBLog(@"%lu---%lu",(unsigned long)range.location, (unsigned long)range.length);
//    ZBLog(@"%@",source);
    if (range.location > 1000) {
//        NSLog(@"这是个神马情况！！！----------------------------------------------%@",source);
        _source = @"未知来源";
    } else {
         _source = [NSString stringWithFormat:@"来自%@", [source substringWithRange:range]];
    }
}

@end
