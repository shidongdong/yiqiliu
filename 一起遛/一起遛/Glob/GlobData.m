//
//  GlobData.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/28.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "GlobData.h"
#import "DDUserAck.h"
#import "DDOSSAck.h"


@interface GlobData()

@property(nonatomic)NSTimeInterval lastSendMsgTime;
@property(nonatomic,strong)DDUserAck * userInfo;

@end

@implementation GlobData

+ (instancetype)shareInstance
{
    static GlobData* share = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        share = [[self alloc] init];
        
    });
    return share;
}

- (DDUserAck *)user
{
    return self.userInfo;
}

- (BOOL)hasUser
{
    NSInteger userID = [[[NSUserDefaults standardUserDefaults] objectForKey:kParamUserInfo] integerValue];
    if (userID == 0)
    {
        return NO;
    }
    return YES;
}

- (void)updateUser:(DDUserAck *)user;
{
    self.userInfo = user;
    NSString * userID = [NSString stringWithFormat:@"%ld",user.content.id];
    [[NSUserDefaults standardUserDefaults] setObject:userID forKey:kParamUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearUser
{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kParamUserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
  //  [self clearTimeLimit];
}

- (BOOL)hasVersionGuide
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kParamGuide] boolValue];
}

- (void)saveVersionGuide
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:kParamGuide];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)canPushPoliceWarn:(NSInteger)circleID
{
    NSString * key = [NSString stringWithFormat:@"policeCircle%ld",circleID];
    NSDate * date = [NSDate date];
    NSTimeInterval time = [[[NSUserDefaults standardUserDefaults] objectForKey:key] doubleValue];
    if (date.timeIntervalSince1970 - time > 300)
    {
        return YES;
    }
    return NO;
}

- (BOOL)canPushPoisonousWarn
{
    NSDate * date = [NSDate date];
    NSTimeInterval time = [[[NSUserDefaults standardUserDefaults] objectForKey:kParamPoisonousWarn] doubleValue];
    if (date.timeIntervalSince1970 - time > 300)
    {
        return YES;
    }
    return NO;
}

- (BOOL)canPushWalk:(NSInteger)circleID
{
    NSString * key = [NSString stringWithFormat:@"walkCircle%ld",circleID];
    NSDate * date = [NSDate date];
    NSTimeInterval time = [[[NSUserDefaults standardUserDefaults] objectForKey:key] doubleValue];
    if (date.timeIntervalSince1970 - time > 300)
    {
        return YES;
    }
    return NO;
}

- (void)saveSendCodeTime
{
    NSDate * date = [NSDate date];
    self.lastSendMsgTime = date.timeIntervalSince1970;
}

- (NSTimeInterval)sendCodeTime
{
    return self.lastSendMsgTime;
}

- (void)savePoliceWarnTime:(NSInteger)circleID
{
    NSString * key = [NSString stringWithFormat:@"policeCircle%ld",circleID];
    NSDate * date = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",date.timeIntervalSince1970] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)savePoisonousWarnTime
{
    NSDate * date = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",date.timeIntervalSince1970] forKey:kParamPoisonousWarn];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)saveWalkTime:(NSInteger)circleID
{
    NSString * key = [NSString stringWithFormat:@"walkCircle%ld",circleID];
    NSDate * date = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f",date.timeIntervalSince1970] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//- (void)clearTimeLimit
//{
//    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kParamPoliceWarn];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kParamPoisonousWarn];
//    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kParamPoliceWarnCircleID];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kParamWalk];
//    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:kParamWalkCirleID];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//}

- (void)saveOSSInfo:(DDOSSAck *)ossInfo
{
    self.ossAccessKey = ossInfo.content.accessKeyId;
    self.ossSecretKey = ossInfo.content.accessKeySecret;
    self.ossHostKey = ossInfo.content.ossHost;
    self.ossBucktKey = ossInfo.content.bucketName;
}

@end
