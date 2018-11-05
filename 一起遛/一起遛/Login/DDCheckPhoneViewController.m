//
//  DDCheckPhoneViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/22.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDCheckPhoneViewController.h"
#import "UIViewController+Customize.h"
#import "MBProgressHUD+DDHUD.h"
#import "DDHTTPClient.h"
#import "DDGetCodeArg.h"
#import "DDCodeViewController.h"
#import "DDGetCodeForPwdArg.h"
#import "GlobData.h"
#import "MBProgressHUD+DDHUD.h"
@implementation DDCheckPhoneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.type == DD_ForgetPwd_Type)
    {
        self.title = @"找回密码";
    }
    else
    {
        self.title = @"手机号码注册";
    }
    
    [self addDefaultLeftBarItem];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBoard)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dismissBoard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (BOOL)checkAvailable
{
    if (self.phoneTextField.text.length == 0 || self.passwordTextField.text.length == 0)
    {
        [MBProgressHUD ShowTips:@"手机号码或者密码不对" delayTime:2.0 atView:nil];
        return NO;
    }
    return YES;
}

- (IBAction)nextAction:(UIButton *)sender {
    
    NSTimeInterval time = [[GlobData shareInstance] sendCodeTime];
    NSDate * date = [NSDate date];
    if (date.timeIntervalSince1970 - time <= 60)
    {
        [MBProgressHUD ShowTips:@"发送验证码间隔过短" delayTime:2.0 atView:nil];
        return;
    }
    
    
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    if (![self checkAvailable])
    {
        return;
    }
    
    if (self.type == DD_ForgetPwd_Type)
    {
        DDGetCodeForPwdArg * arg = [[DDGetCodeForPwdArg alloc] init];
        arg.mobile = self.phoneTextField.text;
        [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"BaseAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
            if (bSuccess)
            {
                [[GlobData shareInstance] saveSendCodeTime];
                [self performSegueWithIdentifier:@"codeVcSegue" sender:nil];
            }
        }];
    }
    else
    {
        DDGetCodeArg * arg = [[DDGetCodeArg alloc] init];
        arg.mobile = self.phoneTextField.text;
        [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"BaseAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
            if (bSuccess)
            {
                [[GlobData shareInstance] saveSendCodeTime];
                [self performSegueWithIdentifier:@"codeVcSegue" sender:nil];
            }
        }];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"codeVcSegue"])
    {
        DDCodeViewController * viewController = segue.destinationViewController;
        viewController.mobile = self.phoneTextField.text;
        viewController.password = self.passwordTextField.text;
        if (self.type == DD_ForgetPwd_Type)
        {
            viewController.isRegister = NO;
        }
        else
        {
            viewController.isRegister = YES;
        }
    }
}


@end
