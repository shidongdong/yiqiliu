//
//  UserInfoModel.h
//  YouzaniOSDemo
//
//  Created by youzan on 15/11/6.
//  Copyright (c) 2015年 youzan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YZUserModel.h"

/**
 *  买家信息。测试数据。
 */
@interface CacheUserInfo : NSObject

@property (copy, nonatomic  ) NSString *userId;
@property (copy, nonatomic  ) NSString *gender;
@property (copy, nonatomic  ) NSString *name;
@property (copy, nonatomic  ) NSString *telephone;
@property (copy, nonatomic  ) NSString *avatar;

@property (assign, nonatomic) BOOL isLogined; /**< 是否登陆有赞 */


+ (instancetype)sharedManage;

/**
 *  重置测试用户的数据
 */
//- (void)resetUserValue;

/**
 *  数据模型转换
 *
 *  @param cacheModel 当前测试用户的数据
 *
 *  @return YZUserModel
 */
+ (YZUserModel *)getYZUserModelFromCacheUserModel:(CacheUserInfo *)cacheModel;

@end
