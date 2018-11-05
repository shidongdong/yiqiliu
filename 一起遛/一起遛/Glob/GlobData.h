//
//  GlobData.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/28.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kParamUserInfo @"User"
#define kParamGuide    @"Guide"

#define kParamPoliceWarn  @"Police"
#define kParamPoisonousWarn  @"Poisonous"
#define kParamWalk  @"Walk"
#define kParamWalkCirleID  @"WalkID"
#define kParamPoliceWarnCircleID  @"PoliceID"

@class DDUserAck;
@class DDOSSAck;
@interface GlobData : NSObject
{
    
}
@property(nonatomic,copy)NSString * ossAccessKey;
@property(nonatomic,copy)NSString * ossSecretKey;
@property(nonatomic,copy)NSString * ossHostKey;
@property(nonatomic,copy)NSString * ossBucktKey;

+ (instancetype)shareInstance;

- (DDUserAck *)user;

- (void)updateUser:(DDUserAck *)user;

- (void)clearUser;

- (void)saveOSSInfo:(DDOSSAck *)ossInfo;

- (BOOL)hasVersionGuide;

- (void)saveVersionGuide;

- (BOOL)hasUser;

- (BOOL)canPushPoliceWarn:(NSInteger)circleID;

- (BOOL)canPushPoisonousWarn;

- (BOOL)canPushWalk:(NSInteger)circleID;

- (void)savePoliceWarnTime:(NSInteger)circleID;

- (void)savePoisonousWarnTime;

- (void)saveWalkTime:(NSInteger)circleID;

- (void)saveSendCodeTime;

- (NSTimeInterval)sendCodeTime;
@end
