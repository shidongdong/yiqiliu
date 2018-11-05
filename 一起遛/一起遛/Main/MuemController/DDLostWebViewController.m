//
//  DDLostWebViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/28.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDLostWebViewController.h"
#import "UIViewController+Customize.h"
@interface DDLostWebViewController ()<UIWebViewDelegate>

@end

@implementation DDLostWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addDefaultLeftBarItem];
    NSURL *url = [NSURL URLWithString:self.lostURL];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
