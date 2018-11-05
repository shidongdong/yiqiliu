//
//  DDLoginViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/22.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDLoginViewController.h"
#import "DDCheckPhoneViewController.h"
#import "DDHTTPClient.h"
#import "DDLoginArg.h"
#import "DDUserAck.h"
#import "DDDeviceInfo.h"
#import "MBProgressHUD+DDHUD.h"
#import "UIColor+DDColor.h"
#import "DDUserInfoViewController.h"
#import "GlobData.h"
#import "GeTuiSdk.h"
@implementation DDLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor bgColor];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissBoard)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark -
#pragma mark private
- (void)dismissBoard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (BOOL)checkAvailable
{
    if (self.userTextField.text.length == 0 || self.passwordTextField.text.length == 0)
    {
        [MBProgressHUD ShowTips:@"用户名或者密码不能为空" delayTime:2.0 atView:nil];
        return NO;
    }
    
    return YES;
}

#pragma mark -
#pragma mark event
- (IBAction)unwindToLoginForSegue:(UIStoryboardSegue *)unwindSegue
{
    
}


- (IBAction)loginAction:(UIButton *)sender {
    //调用登陆接口
    [self.userTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    //检查有效性
    BOOL bEnable = [self checkAvailable];
    if (!bEnable)
    {
        return;
    }
    
    DDLoginArg * arg = [[DDLoginArg alloc] init];
    arg.mobile = self.userTextField.text;
    arg.password = self.passwordTextField.text;
    arg.deviceType = 1;
    arg.dvc = [[DDDeviceInfo shareInstance] getDeviceId];
    
    [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"DDUserAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
        if (bSuccess)
        {
            NSLog(@"登陆成功");
            
            DDUserAck * ack = (DDUserAck *)response;
            [[GlobData shareInstance] updateUser:ack];
            
            [GeTuiSdk bindAlias:[[DDDeviceInfo shareInstance] getDeviceId] andSequenceNum:[[DDDeviceInfo shareInstance] getDeviceId]];
            
            if (ack.content.isComplete)
            {
                [self performSegueWithIdentifier:@"mainVCSegue" sender:nil];
            }
            else
            {
                [self performSegueWithIdentifier:@"finishUserInfoSegue" sender:@(ack.content.id)];
            }
        
        }
    }];
    
}
- (IBAction)forgetPassword:(UIButton *)sender {
    [self performSegueWithIdentifier:@"checkPhoneSegue" sender:@"0"];
}
- (IBAction)registerAction:(UIButton *)sender {
    [self performSegueWithIdentifier:@"checkPhoneSegue" sender:@"1"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"checkPhoneSegue"])
    {
        DDCheckPhoneViewController * viewController = segue.destinationViewController;
        viewController.type = (checkPhoneType)[sender integerValue];
    }
    else if ([segue.identifier isEqualToString:@"finishUserInfoSegue"])
    {
        DDUserInfoViewController * viewController = segue.destinationViewController;
        viewController.userID = [sender integerValue];
    }
}

@end
