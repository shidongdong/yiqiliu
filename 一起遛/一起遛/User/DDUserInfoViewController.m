//
//  DDUserInfoViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/26.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDUserInfoViewController.h"
#import "DDUserInfoCell.h"
#import "DDDogInfoViewController.h"
#import "MBProgressHUD+DDHUD.h"
#import "UIViewController+Customize.h"
@interface DDUserInfoViewController()<UITableViewDelegate,UITableViewDataSource,DDUserInfoCellDelegate>
{
    
}
@property(nonatomic)NSInteger sex;
@property(nonatomic,copy)NSString * nick;
@end

@implementation DDUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title = @"个人信息";
 
    if (self.bFromMianMap)
    {
        self.navigationItem.hidesBackButton = YES;
    }
    else
    {
        [self addDefaultLeftBarItem];
    }
}


- (IBAction)nextAction:(UIButton *)sender {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (![self checkAvailable]) {
        return;
    }
    
    [self performSegueWithIdentifier:@"goDogInfoSegue" sender:nil];
    
}

- (BOOL)checkAvailable
{
    if (self.nick.length == 0)
    {
        [MBProgressHUD ShowTips:@"昵称不能为空" delayTime:2 atView:nil];
        return NO;
    }
    return YES;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"goDogInfoSegue"])
    {
        DDDogInfoViewController * viewController = (DDDogInfoViewController *)segue.destinationViewController;
        viewController.sex = self.sex;
        viewController.nickName = self.nick;
        viewController.userID = self.userID;
        viewController.bFromMain = self.bFromMianMap;
    }
}


#pragma mark -
#pragma mark UITableViewDelegate && UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        DDUserInfoCell * cell =[tableView dequeueReusableCellWithIdentifier:@"userInfoCellID1"];
        cell.delegate = self;
        return cell;
    }
    else
    {
        DDUserInfoCell * cell =[tableView dequeueReusableCellWithIdentifier:@"userInfoCellID2"];
        cell.delegate = self;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

#pragma mark -
#pragma mark DDUserInfoCellDelegate

- (void)updateNickName:(NSString *)name
{
    self.nick = name;
}

- (void)updateSex:(NSInteger)sex
{
    self.sex = sex;
}

@end
