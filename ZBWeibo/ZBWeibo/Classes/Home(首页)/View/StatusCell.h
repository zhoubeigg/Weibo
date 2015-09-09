//
//  StatusCell.h
//  ZBWeibo
//
//  Created by macAir on 15/8/12.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZWBStatusFrame;

@interface StatusCell : UITableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) ZWBStatusFrame *statusFrame;
@end
