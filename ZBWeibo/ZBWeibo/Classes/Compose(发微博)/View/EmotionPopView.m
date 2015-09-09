//
//  EmotionPopView.m
//  ZBWeibo
//
//  Created by macAir on 15/8/25.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "EmotionPopView.h"
#import "Emotion.h"
#import "EmotionButton.h"

@interface EmotionPopView()
@property (weak, nonatomic) IBOutlet EmotionButton *emotionButton;

@end
@implementation EmotionPopView

+ (instancetype)popView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"EmotionPopView" owner:nil options:nil] lastObject];
}

- (void)showFrom:(EmotionButton *)button
{
    if (button == nil) return;
    
    // 给popview传递数据
    self.emotionButton.emotion = button.emotion;
    
    // 取得最上面的window
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self];
    
    // 计算出被点击的按钮在window中得frame
    CGRect btnFrame = [button convertRect:button.bounds toView:nil];
    
    self.y = CGRectGetMidY(btnFrame) - self.height;
    self.centerX = CGRectGetMidX(btnFrame);

}

@end
