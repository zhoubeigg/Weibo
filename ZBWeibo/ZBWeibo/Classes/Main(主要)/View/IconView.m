//
//  IconView.m
//  ZBWeibo
//
//  Created by macAir on 15/8/18.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import "IconView.h"
#import "ZBWUser.h"
#import "UIImageView+WebCache.h"

@interface IconView()
@property (nonatomic, weak) UIImageView *verifiedView;
@end

@implementation IconView

- (UIImageView *)verifiedView
{
    if (!_verifiedView) {
       UIImageView *verifiedView = [[UIImageView alloc] init];
        [self addSubview:verifiedView];
        self.verifiedView = verifiedView;
    }
    return _verifiedView;
}

- (void)setUser:(ZBWUser *)user
{
    _user = user;
    
    // 1.下载图片
    [self sd_setImageWithURL:[NSURL URLWithString:user.profile_image_url] placeholderImage:[UIImage imageNamed:@"avatar_default_small"]];
    
    // 2.设置加V图片
    switch (user.verified_type) {
//        case UserVerifiedTypeNone:
//            self.verifiedView.hidden = YES;
//            break;
//            
        case UserVerifiedPersonal:
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_vip"];
            break;
            
        case UserVerifiedOrgEnterprice:
        case UserVerifiedOrgMedia:
        case UserVerifiedOrgWebsite:
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_enterprise_vip"];
            break;
            
        case UserVerifiedDaren:
            self.verifiedView.hidden = NO;
            self.verifiedView.image = [UIImage imageNamed:@"avatar_grassroot"];
            break;
            

        default:
            self.verifiedView.hidden = YES; // 当做没有任何认证
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.verifiedView.size = self.verifiedView.image.size;
    CGFloat scale = 0.6;
    self.verifiedView.x = self.width - self.verifiedView.width * scale;
    self.verifiedView.y = self.height - self.verifiedView.height * scale;
}
@end
