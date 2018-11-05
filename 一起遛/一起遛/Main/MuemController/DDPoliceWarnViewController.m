//
//  DDPoliceWarnViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/30.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDPoliceWarnViewController.h"
#import "UIViewController+Customize.h"
#import "DDPoliceWarnInfoCell.h"
#import "DDHTTPClient.h"
#import "DDUserAck.h"
#import "DDPoliceWarnArg.h"
#import "GlobData.h"
#import "MBProgressHUD+DDHUD.h"
@interface DDPoliceWarnViewController()<UITableViewDelegate,UITableViewDataSource>

@end


@implementation DDPoliceWarnViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addDefaultLeftBarItem];
    self.title = @"城管报警";
    
//    MAMapPoint pointA = MAMapPointForCoordinate(self.coordinate);
//    MAMapPoint pointB = MAMapPointForCoordinate(CLLocationCoordinate2DMake(self.content.latitude, self.content.longitude));
//    CLLocationDistance distance = MAMetersBetweenMapPoints(pointA, pointB);
//    if (distance > 3000)
//    {
//        
//    }
//    else
//    {
//        
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDPoliceWarnInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"policeWarnInfoCellID"];
    if (indexPath.row == 0)
    {
        cell.titleLabel.text = @"通知地盘";
        cell.infoLabel.text = self.content.name;
    }
    else
    {
        cell.titleLabel.text = @"所在位置";
        cell.infoLabel.text = self.content.address;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (IBAction)sendAction:(UIButton *)sender {
    
    if (![[GlobData shareInstance] canPushPoliceWarn:self.content.id])
    {
        [MBProgressHUD ShowTips:@"距上一次发送警报时间过短,请稍后发送" delayTime:2 atView:nil];
        return;
    }
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"确定在此位置建立城管警报？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        DDPoliceWarnArg * arg = [[DDPoliceWarnArg alloc] init];
        DDUserAck * ack = [[GlobData shareInstance] user];
        arg.userId = ack.content.id;
        arg.longitude = self.coordinate.longitude;
        arg.latitude = self.coordinate.latitude;
        arg.circleId = self.content.id;
        
        [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"BaseAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
            if (bSuccess)
            {
                [[GlobData shareInstance] savePoliceWarnTime:self.content.id];
                [MBProgressHUD ShowTips:@"发送成功，地盘内铲屎官会收到警报" delayTime:2 atView:nil];
                [self performSegueWithIdentifier:@"unwindFromPoliceWarnSegue" sender:nil];
            }
        }];
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
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
@end
