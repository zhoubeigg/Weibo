//
//  ComposePhotosView.h
//  ZBWeibo
//
//  Created by macAir on 15/8/21.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComposePhotosView : UIView
- (void)addPhoto:(UIImage *)photo;
@property (nonatomic, strong, readonly) NSMutableArray *photos;
//- (NSArray *)photos;
@end
