//
//  DDCodeViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/22.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDCodeViewController.h"
#import "DDHTTPClient.h"
#import "DDGetCodeArg.h"
#import "DDRegisterArg.h"
#import "UIViewController+Customize.h"
#import "DDUserAck.h"
#import "GlobData.h"
#import "DDFindPwdArg.h"
#import "DDGetCodeForPwdArg.h"
#import "GeTuiSdk.h"
#import "DDDeviceInfo.h"
@interface DDCodeViewController()
{
    NSInteger countDownNum;
}
@property(nonatomic,strong)NSTimer * timer;

@end

@implementation DDCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    [self addDefaultLeftBarItem];
    self.title = @"验证码";
    
    countDownNum = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownAction) userInfo:nil repeats:YES];
    self.sendBtn.layer.cornerRadius = 5;
    self.countLabel.layer.cornerRadius = 5;
    self.countLabel.hidden = NO;
}


- (void)countDownAction
{
    countDownNum--;
    
    if (countDownNum < 0)
    {
        countDownNum = 60;
        self.countLabel.hidden = YES;
        self.timer.fireDate = [NSDate distantFuture];
        return;
    }
    self.countLabel.text = [NSString stringWithFormat:@"%lds",countDownNum];
}


- (IBAction)finishAction:(UIButton *)sender {
    
    [self.codeTextField resignFirstResponder];
    
    if (self.isRegister)
    {
        DDRegisterArg * arg = [[DDRegisterArg alloc] init];
        arg.mobile = self.mobile;
        arg.password = self.password;
        arg.code = self.codeTextField.text;
        
        [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"DDUserAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
            
            DDUserAck * ack = (DDUserAck *)response;
            
            [[GlobData shareInstance] updateUser:ack];
            
            if (!ack.content.isComplete)
            {
                
                [GeTuiSdk bindAlias:[[DDDeviceInfo shareInstance] getDeviceId] andSequenceNum:[[DDDeviceInfo shareInstance] getDeviceId]];
                [self performSegueWithIdentifier:@"finishUserInfoSegue2" sender:nil];
            }
            
        }];
    }
    else
    {
        
        DDFindPwdArg * arg = [[DDFindPwdArg alloc] init];
        arg.mobile = self.mobile;
        arg.password = self.password;
        arg.code = self.codeTextField.text;
        
        [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"DDUserAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
            if (bSuccess)
            {
                DDUserAck * ack = (DDUserAck *)response;
                [[GlobData shareInstance] updateUser:ack];
                if (!ack.content.isComplete)
                {
                    [self performSegueWithIdentifier:@"finishUserInfoSegue2" sender:nil];
                }
                else
                {
                    [self performSegueWithIdentifier:@"gotomainVCFromCodeSegue" sender:nil];
                }
            }
        }];
    }
    
    
    
    
}
- (IBAction)sendCode:(UIButton *)sender {
    
    [self.codeTextField resignFirstResponder];
    
    if (self.isRegister)
    {
        DDGetCodeArg * arg = [[DDGetCodeArg alloc] init];
        arg.mobile = self.mobile;
        [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"BaseAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
            if (bSuccess)
            {
                self.countLabel.hidden = NO;
                self.timer.fireDate = [NSDate distantPast];
            }
        }];
    }
    else
    {
        DDGetCodeForPwdArg * arg = [[DDGetCodeForPwdArg alloc] init];
        arg.mobile = self.mobile;
        [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"BaseAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
            if (bSuccess)
            {
                self.countLabel.hidden = NO;
                self.timer.fireDate = [NSDate distantPast];
            }
        }];
    }
    
}

- (void)dealloc
{
    if ([self.timer isValid])
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
