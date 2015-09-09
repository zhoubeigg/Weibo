//
//  DropdownMenu.h
//  ZBWeibo
//
//  Created by macAir on 15/8/1.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DropdownMenu;

@protocol DropdownMenuDelegate <NSObject>
@optional
- (void)dropdownMenuDidDismiss:(DropdownMenu *)menu;
- (void)dropdownMenuDidShow:(DropdownMenu *)menu;
@end

@interface DropdownMenu : UIView
@property (nonatomic, strong) UIView *content;
@property (nonatomic, strong) UIViewController *contentController;
@property (nonatomic, weak) id<DropdownMenuDelegate> delegate;

+ (instancetype)menu;
- (void)showFrom:(UIView *)from;
- (void)dismiss;
@end
