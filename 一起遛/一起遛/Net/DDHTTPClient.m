//
//  DDHTTPClient.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/22.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDHTTPClient.h"
#import "MBProgressHUD.h"
#import "MBProgressHUD+DDHUD.h"
#import "GlobConfig.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <AliyunOSSiOS/OSSService.h>
#import <AliyunOSSiOS/OSSCompat.h>
#import "GlobData.h"
#import "DDDeviceInfo.h"
#import "AppDelegate.h"
//NSString * const AccessKey = @"0wTdfqeNtZDIjuyG";
//NSString * const SecretKey = @"aaItM1sCVj0oJJZWYPFcfsnmB4yiyH";

typedef BaseAck * (^ParseClassBlock)(NSDictionary *json, Class class);

ParseClassBlock parseClassTemplate = ^(NSDictionary *json, Class class) {
    NSError* error = nil;
    id Res = [[class alloc] initWithDictionary:json error:&error];
    return Res;
};

@interface DDHTTPClient()
{
    OSSClient * client;
    
    
    MBProgressHUD * reqHud;
}
@end


@implementation DDHTTPClient

+ (instancetype)shareInstance
{
    static DDHTTPClient* share = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        share = [[self alloc] init];
        
    });
    return share;
}

- (instancetype)init
{
    self = [super initWithBaseURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",kBaseURL]]];
    if (self)
    {
        self.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        [self.reachabilityManager startMonitoring];
        if (TURN_ON_HTTPS)
        {
            self.securityPolicy = [self customSecurityPolicy];
        }
    }
    return self;
}


//发送一个请求
- (void)beginHttpRequest:(BaseArg *)req
                   parse:(NSString *)parseClass
              completion:(requestFinsihBlock)block
{
    
    if (![self checkNetAvailable])
    {
        if ([req reqErrorToast])
        {
            [MBProgressHUD ShowTips:@"请检查你的网络" delayTime:2.0 atView:NULL];
            block(NO,NULL,@"请检查你的网络");
            return;
        }
    }
    
    req.deviceType = 1;
    req.dvc = [[DDDeviceInfo shareInstance] getDeviceId];
    
    NSString * versionURL = [NSString stringWithFormat:@"%@/v%@%@",kBaseURL,[[DDDeviceInfo shareInstance] getAppVersion],[req reqURL]];
    
    NSString *url = [[NSURL URLWithString:versionURL] absoluteString];
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:[req reqMethod] URLString:url parameters:[req toDictionary] error:nil];
    request.timeoutInterval = [req reqTimeOut];
    
    NSLog(@"\nRequest : 【%@】 \nParams:%@",url,[req toDictionary]);
    
    // 按需显示 loading
    
    if([req reqLoading])
    {
        reqHud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication] keyWindow] animated:YES];
    }
    
    [[self dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"\nAck : 【%@】 \nParams:%@",url,responseObject);
        if (reqHud)
        {
            [reqHud hideAnimated:YES];
            reqHud = nil;
        }
        
        if (error == nil)
        {
            Class class = NSClassFromString(parseClass);
            BaseAck * data = parseClassTemplate(responseObject,class);
            
            if (data.state == 200)
            {
                block(YES,data,NULL);
            }
            else
            {
                
                class = NSClassFromString(@"BaseAck");
                data = parseClassTemplate(responseObject,class);
                [MBProgressHUD ShowTips:data.content delayTime:2.0 atView:NULL];
                block(NO,NULL,data.content);
                
                if (data.state == 407 || data.state == 408)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopLocationTimerNotify" object:nil];
                    AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                    [app goLoginViewController];
                }
            }
        }
        else
        {
            if ([req reqErrorToast])
            {
                [MBProgressHUD ShowTips:error.domain delayTime:2.0 atView:NULL];
                block(NO,NULL,error.domain);
            }
        }
    }] resume];
}

- (void)upLoadImage:(UIImage *)image
          imageType:(UploadImageType)type
         completion:(uploadImageBlock)block
{
    
    if (![self checkNetAvailable])
    {
        [MBProgressHUD ShowTips:@"请检查你的网络" delayTime:2.0 atView:NULL];
        block(NO,nil,@"请检查你的网络");
        return;
    }
    
    NSData * data = UIImageJPEGRepresentation(image, 0.5);
    // 明文设置secret的方式建议只在测试时使用，更多鉴权模式参考后面链接给出的官网完整文档的`访问控制`章节
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc] initWithPlainTextAccessKey:[GlobData shareInstance].ossAccessKey secretKey:[GlobData shareInstance].ossSecretKey];
    client = [[OSSClient alloc] initWithEndpoint:[GlobData shareInstance].ossHostKey credentialProvider:credential];
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = [GlobData shareInstance].ossBucktKey;
    NSString *objectKeys = [NSString stringWithFormat:@"%@/%@",[self uploadFilePathForUploadType:type],[self uploadNameForImage:image]];
    
    put.objectKey = objectKeys;
    //put.uploadingFileURL = [NSURL fileURLWithPath:fullPath];
    put.uploadingData = data;
    put.uploadProgress = ^(int64_t bytesSent, int64_t totalByteSent, int64_t totalBytesExpectedToSend) {
        NSLog(@"%lld, %lld, %lld", bytesSent, totalByteSent, totalBytesExpectedToSend);
    };
    OSSTask * putTask = [client putObject:put];
    
    [putTask continueWithBlock:^id(OSSTask *task) {
        task = [client presignPublicURLWithBucketName:[GlobData shareInstance].ossBucktKey
                                        withObjectKey:objectKeys];
        NSLog(@"objectKey: %@", put.objectKey);
        if (!task.error) {
            NSLog(@"upload object success!");
            dispatch_async(dispatch_get_main_queue(), ^{
                block(YES,objectKeys,nil);
            });
        } else {
            NSLog(@"upload object failed, error: %@" , task.error);
            dispatch_async(dispatch_get_main_queue(), ^{
                block(NO,nil,task.error.domain);
            });
        }
        return nil;
    }];
}

- (NSString *)uploadFilePathForUploadType:(UploadImageType)type
{
    NSString * filepath;
    
    if (type == Upload_Header_Type)
    {
        filepath = @"images/header/";
    }
    else if (type == Upload_Lost_Type)
    {
        filepath = @"images/lost/";
    }
    else
    {
        filepath = @"images/domain/";
    }
    
    NSDate *now = [NSDate date];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *dateComponent = [calendar components:unitFlags fromDate:now];
    
    NSInteger year = [dateComponent year];
    NSInteger month =  [dateComponent month];
    NSInteger day = [dateComponent day];
    
    filepath = [filepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",year]];
    filepath = [filepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",month]];
    filepath = [filepath stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld",day]];
    
    return filepath;
}

- (NSString *)uploadNameForImage:(UIImage *)image
{
    int iRandom=arc4random();
    if (iRandom<0) {
        iRandom=-iRandom;
    }
    NSDateFormatter *tFormat=[[NSDateFormatter alloc] init];
    [tFormat setDateFormat:@"yyyyMMddHHmmss"];
    NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMT];
    NSDate * newDate = [[NSDate date] dateByAddingTimeInterval:timeZoneOffset];
    
    NSString *tResult=[NSString stringWithFormat:@"%@%d_w%i_h%i.jpg",[tFormat stringFromDate:newDate],iRandom,(int)image.size.width,(int)image.size.height];
    return tResult;
}


- (BOOL)checkNetAvailable
{
    if ([self.reachabilityManager networkReachabilityStatus] ==  AFNetworkReachabilityStatusNotReachable)
    {
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark private
- (AFSecurityPolicy*)customSecurityPolicy
{
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    securityPolicy.allowInvalidCertificates = YES;
    securityPolicy.validatesDomainName = NO;
    return securityPolicy;
}


@end
