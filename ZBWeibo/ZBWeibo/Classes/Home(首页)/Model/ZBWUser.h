//
//  ZBWUser.h
//  ZBWeibo
//
//  Created by macAir on 15/8/10.
//  Copyright (c) 2015年 ZhouBei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    UserVerifiedTypeNone = -1,
    UserVerifiedPersonal = 0,
    UserVerifiedOrgEnterprice = 2,
    UserVerifiedOrgMedia = 3,
    UserVerifiedOrgWebsite = 5,
    UserVerifiedDaren = 220
} UserVerifiedType;

@interface ZBWUser : NSObject

/**idstr	string	字符串型的用户UID*/
@property (nonatomic, copy) NSString *idstr;

/**name	string	友好显示名称*/
@property (nonatomic, copy) NSString *name;

/**profile_image_url	string	用户头像地址（中图），50×50像素*/
@property (nonatomic, copy) NSString *profile_image_url;

/** 会员类型 */
@property (nonatomic, assign) int mbtype;

/** 会员等级 */
@property (nonatomic, assign) int mbrank;
@property (nonatomic, assign, getter=isVip) BOOL vip;

/** 认证类型 */
@property (nonatomic, assign) UserVerifiedType verified_type;
@end
