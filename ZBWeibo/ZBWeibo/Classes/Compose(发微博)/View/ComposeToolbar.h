//
//  ComposeToolbar.h
//  ZBWeibo
//
//  Created by macAir on 15/8/20.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ComposeToolbarButtonTypeCamera,
    ComposeToolbarButtonTypePicture,
    ComposeToolbarButtonTypeMention,
    ComposeToolbarButtonTypeTrend,
    ComposeToolbarButtonTypeEmotion
} ComposeToolbarButtonType;

@class ComposeToolbar;
@protocol ComposeToolbarDelegate <NSObject>

@optional
- (void)composeToolbar:(ComposeToolbar *)toolbar didClickButton:(ComposeToolbarButtonType)buttonType;

@end

@interface ComposeToolbar : UIView
@property (nonatomic, weak) id<ComposeToolbarDelegate> delegate;
@property (nonatomic, assign) BOOL showKeyboardButton;
@end
