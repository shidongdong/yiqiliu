//
//  UserInfoModel.m
//  YouzaniOSDemo
//
//  Created by youzan on 15/11/6.
//  Copyright (c) 2015年 youzan. All rights reserved.
//

#import "CacheUserInfo.h"
#import "GlobData.h"
#import "DDUserAck.h"
#import "GlobConfig.h"
@implementation CacheUserInfo

#pragma mark - Public Method

+ (instancetype)sharedManage {
    static CacheUserInfo *shareManage = nil;
    static dispatch_once_t once;
    dispatch_once(&once,^{
        shareManage = [[self alloc] init];
    });
    return shareManage;
}

- (void)resetUserValue {
    [self setProperty:@"gender" Value:@"1"];
    [self setProperty:@"userId" Value:@"123456"];//买家的唯一标示
    [self setProperty:@"name" Value:@"测试用户"];
    [self setProperty:@"telephone" Value:@""];
    [self setProperty:@"avatar" Value:@""];
    [self setProperty:@"isLogined" Value:@"NO"];
}

+ (YZUserModel *) getYZUserModelFromCacheUserModel:(CacheUserInfo *)cacheModel {
    YZUserModel *userModel = [[YZUserModel alloc] init];
    
    DDUserAck * user = [[GlobData shareInstance] user];
    
    userModel.userID = [NSString stringWithFormat:@"%ld",user.content.id];
    userModel.userName = user.content.nick;
    userModel.nickName = user.content.nick;
    userModel.gender = [NSString stringWithFormat:@"%ld",user.content.gender];
    userModel.avatar = [NSString stringWithFormat:@"%@/%@",kPicBaseURL,user.content.pet.header];
    userModel.telePhone = user.content.mobile;
    return userModel;
}

#pragma mark - Private Method

- (void)setProperty:(NSString *)key Value:(NSString *)value {
    [[NSUserDefaults standardUserDefaults] setObject:value forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Setter And Getter

- (void)setUserId:(NSString *)userId {
    [self setProperty:@"userId" Value:userId];
}

- (void)setGender:(NSString *)gender {
    [self setProperty:@"gender" Value:gender];
}

- (void)setName:(NSString *)name {
    [self setProperty:@"name" Value:name];
}

- (void)setTelephone:(NSString *)telephone {
    [self setProperty:@"telephone" Value:telephone];
}

- (void)setAvatar:(NSString *)avatar {
    [self setProperty:@"avatar" Value:avatar];
}

- (void)setIsLogined:(BOOL)isLogined {
    if(isLogined) {
        [self setProperty:@"isLogined" Value:@"YES"];
    } else {
        [self setProperty:@"isLogined" Value:@"NO"];
    }
}

- (NSString *)userId {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
}

- (NSString *)gender {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"gender"];
}

- (NSString *)name {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"name"];
}

- (NSString *)telephone {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"telephone"];
}

- (NSString *)avatar {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar"];
}

- (BOOL) isLogined {
    NSString *isLogined = [[NSUserDefaults standardUserDefaults] objectForKey:@"isLogined"];
    if(isLogined == nil || isLogined.length == 0) {
        return NO;
    }
    return [isLogined isEqualToString:@"YES"];
}

@end
