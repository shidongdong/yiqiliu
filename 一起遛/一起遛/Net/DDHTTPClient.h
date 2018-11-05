//
//  DDHTTPClient.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/22.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "BaseArg.h"
#import "BaseAck.h"

typedef NS_ENUM(NSInteger, UploadImageType) {
    Upload_Header_Type = 0,
    Upload_Lost_Type,
    Upload_Domain_Type,
};


@interface DDHTTPClient : AFHTTPSessionManager

typedef void(^requestFinsihBlock)(BOOL bSuccess, BaseAck * response, NSString * error);
typedef void(^uploadImageBlock)(BOOL bSuccess, NSString * imageURL, NSString * error);


+ (instancetype)shareInstance;

- (void)beginHttpRequest:(BaseArg *)req
                   parse:(NSString *)parseClass
              completion:(requestFinsihBlock)block;

- (void)upLoadImage:(UIImage *)image
          imageType:(UploadImageType)type
         completion:(uploadImageBlock)block;

//检查网络是否可用
- (BOOL)checkNetAvailable;

@end
