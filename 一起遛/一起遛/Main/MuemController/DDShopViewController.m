//
//  DDShopViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/23.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDShopViewController.h"
#import "UIViewController+Customize.h"
#import "YZSDK.h"
#import "CacheUserInfo.h"
@interface DDShopViewController()<UIWebViewDelegate>

@end

@implementation DDShopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"狗狗商城";
    [self addDefaultLeftBarItem];

    [self loginAndloadUrl:@"https://kdt.im/eTfITr"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)loginAndloadUrl:(NSString*)urlString {
    CacheUserInfo *cacheModel = [CacheUserInfo sharedManage];
    if(!cacheModel.isLogined) {
        YZUserModel *userModel = [CacheUserInfo getYZUserModelFromCacheUserModel:cacheModel];
        //同步买家信息
        [YZSDK registerYZUser:userModel callBack:^(NSString *message, BOOL isError) {
            if(isError) {
                cacheModel.isLogined = NO;
            } else {
                cacheModel.isLogined = YES;
                NSURL *url = [NSURL URLWithString:urlString];
                NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
                [self.webView loadRequest:urlRequest];
            }
        }];
    } else {
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:urlRequest];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:[[YZSDK sharedInstance] jsBridgeWhenWebDidLoad]];
}


@end
