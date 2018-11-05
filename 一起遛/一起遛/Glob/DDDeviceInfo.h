//
//  DeviceInfo.h
//  GuanHealth
//
//  Created by hermit on 15/2/26.
//  Copyright (c) 2015年 wensihaihui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDDeviceInfo : NSObject


+ (instancetype)shareInstance;
//设备型号
- (NSString*)getDeviceModel;
//设备系统版本号
- (NSString*)getDeviceOSVersion;
//设备唯一识别码
- (NSString*)getDeviceUUID;
//App的版本号
- (NSString*)getAppVersion;
//运营商
- (NSString*)getCarrierName;
//网络的ip地址
- (NSString*)getIPAddress:(BOOL)preferIPv4;
//设备id（自定义拼接而成）
- (NSString*)getDeviceId;
//编码后的ip地址
//- (NSString*)getBehaviorInfo;

@end
