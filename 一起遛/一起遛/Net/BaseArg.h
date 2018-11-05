//
//  BaseArg.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/22.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "DDJSONModel.h"
@interface BaseArg : DDJSONModel

@property(nonatomic)NSInteger deviceType;
@property(nonatomic,copy)NSString * dvc;
/**
 *  请求URL
 */
- (NSString *)reqURL;

/**
 *  请求方法
 */
- (NSString *)reqMethod;

/**
 *  是否显示请求Loading
 */
- (BOOL)reqLoading;

/**
 *  是否自动提示请求错误
 */
- (BOOL)reqErrorToast;

/**
 *  请求的超时时间
 */
- (NSTimeInterval)reqTimeOut;

@end
