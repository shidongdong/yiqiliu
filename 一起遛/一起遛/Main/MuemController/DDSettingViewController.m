//
//  DDSettingViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/30.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDSettingViewController.h"
#import "UIColor+DDColor.h"
#import "UIViewController+Customize.h"
#import "DDLogoutArg.h"
#import "DDHTTPClient.h"
#import "DDUserAck.h"
#import "GlobData.h"
#import "DDDeviceInfo.h"
#import "AppDelegate.h"
#import "GeTuiSdk.h"
@interface DDSettingViewController()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DDSettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addDefaultLeftBarItem];
    self.title = @"设置";
}


#pragma mark - 
#pragma mark UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 57.0;
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"newSettingCellID"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"newSettingCellID"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.font  =[UIFont systemFontOfSize:16.0];
    cell.textLabel.textColor = [UIColor text2Color];
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"意见反馈";
    }
    else
    {
        cell.textLabel.text = @"关于我们";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0)
    {
        [self performSegueWithIdentifier:@"setAdviseSegue" sender:nil];
    }
    else
    {
        [self performSegueWithIdentifier:@"setAboutusSegue" sender:nil];
    }
    
}


- (IBAction)logoutAction:(UIButton *)sender {
    DDLogoutArg * arg = [[DDLogoutArg alloc] init];
    DDUserAck * ack = [[GlobData shareInstance] user];
    arg.userId = ack.content.id;
    arg.deviceType = 1;
    arg.dvc = [[DDDeviceInfo shareInstance] getDeviceId];
    [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"BaseAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
        if (bSuccess)
        {
            [[GlobData shareInstance] clearUser];
            [GeTuiSdk unbindAlias:[[DDDeviceInfo shareInstance] getDeviceId] andSequenceNum:[[DDDeviceInfo shareInstance] getDeviceId]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"stopLocationTimerNotify" object:nil];
            AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [app goLoginViewController];
        }
    }];
}
@end
