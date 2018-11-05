//
//  AppDelegate.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/22.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "AppDelegate.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "DDOSSArg.h"
#import "DDHTTPClient.h"
#import "DDOSSAck.h"
#import "GlobData.h"
#import "GeTuiSdk.h"
#import "DDDeviceInfo.h"
#import "YZSDK.h"
#import "DDDBCenter.h"
#import "UMMobClick/MobClick.h"
#define kGtAppId           @"9cRHuKLWv07WkzKrkqsC04"
#define kGtAppKey          @"fw5tSAEK3N8P8mxxziVfI7"
#define kGtAppSecret       @"bZ5ziKg2Oo7Kflbb9Adpb4"

@interface AppDelegate ()<GeTuiSdkDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    if(![[GlobData shareInstance] hasVersionGuide]){
        UIViewController *rootVC = [story instantiateViewControllerWithIdentifier: @"guideID"];
        self.window.rootViewController = rootVC;
    } else {
        UINavigationController * rootNav;
        if (![[GlobData shareInstance] hasUser])
        {
            rootNav =[story instantiateViewControllerWithIdentifier: @"NaviID1"];
        }
        else
        {
            rootNav =[story instantiateViewControllerWithIdentifier: @"NaviID2"];
        }
        self.window.rootViewController = rootNav;
    }
    
    [self.window makeKeyAndVisible];
    
    [AMapServices sharedServices].apiKey = @"b0cc633503f48693bfa1b15a456ca302";
    
    //是否打印log
    [YZSDK setOpenDebugLog:YES];
    //设置AppID和AppSecret
    [YZSDK setOpenInterfaceAppID:@"c3ce22f13420111a28" appSecret:@"e31e99050a929531d52f2439db0c2f35"];
    //设置UA
    [YZSDK userAgentInit:@"aeddf85ee0363205461473037287100" version:@"1.0.0"];
    //UMeng
    UMConfigInstance.appKey = @"57edc7a2e0f55a0700000fc9";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    
    // 通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    [GeTuiSdk startSdkWithAppId:kGtAppId appKey:kGtAppKey appSecret:kGtAppSecret delegate:self];
    [GeTuiSdk runBackgroundEnable:YES];
    // 注册APNS
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                         settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                         categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    //请求图片OSS参数
    DDOSSArg * arg = [[DDOSSArg alloc] init];
    [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"DDOSSAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
        if (bSuccess)
        {
            DDOSSAck * ack = (DDOSSAck *)response;
            [[GlobData shareInstance] saveOSSInfo:ack];
        }
    }];
    
    return YES;
}

- (void)goLoginViewController
{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController * rootNav =[story instantiateViewControllerWithIdentifier: @"NaviID1"];
    
//    UIViewController * viewcontroller = self.window.rootViewController;
//    viewcontroller = nil;
    
    self.window.rootViewController = rootNav;
}

#pragma mark -
#pragma mark ReceiveNotication
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    /**
     发送通知去请求消息未读书目
     */
    //跳转留到后续版本再做
//    UINavigationController * nav = (UINavigationController *)self.window.rootViewController;
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    UIViewController *messageVc = [story instantiateViewControllerWithIdentifier: @"messageSBID"];
//    [nav pushViewController:messageVc animated:YES];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // 将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes
                                              length:payloadData.length
                                            encoding:NSUTF8StringEncoding];
    }
    NSError* error = nil;
    DDMessage * message = [[DDMessage alloc] initWithData:payloadData error:&error];
    [[DDDBCenter shareInstance] addDDMessage:message];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newMessageNotify" object:message];
    
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    //向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    /// Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}


/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"\n>>>[GeTuiSdk RegisterClient]:%@\n\n", clientId);
}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    //个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}


@end
