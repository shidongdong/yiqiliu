//
//  DDMainCircleViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/8.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDMainCircleViewController.h"
#import "DDCircleCell.h"
#import "DDAddCircleArg.h"
#import "GlobData.h"
#import "DDUserAck.h"
#import "DDHTTPClient.h"
#import "DDPressWalkArg.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "GlobConfig.h"
#import "UIViewController+Customize.h"
#import "DDMainCircleDetailViewController.h"
#import "DDMainCirclePetListViewController.h"
#import "DDBuildSiteAck.h"
#import "DDCircleDetailArg.h"
#import "DDUserCenterViewController.h"
#import "MBProgressHUD+DDHUD.h"
#import "DDModifyCircleNoticeViewController.h"
@interface DDMainCircleViewController()<UITableViewDelegate,UITableViewDataSource,DDCircleCellDelegate,DDModifyCircleNoticeViewControllerDelegate>

@end

@implementation DDMainCircleViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addDefaultLeftBarItem];
    self.title = @"地盘";
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCircleInfo:) name:@"CirCleNameUpdateNotify" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCircleHeader:) name:@"uploadCicleHeaderNotify" object:nil];
    [self updateFuncBtn];
}

- (void)updateFuncBtn
{
    if (self.isJoin)
    {
        [self.actionButton setTitle:@"召集铲屎官" forState:UIControlStateNormal];
    }
    else
    {
        [self.actionButton setTitle:@"加入地盘" forState:UIControlStateNormal];
    }
}

- (void)updateCircleHeader:(NSNotification *)notication
{
    DDCircleCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.headerView setImage:[notication object] forState:UIControlStateNormal];
}


- (void)updateCircleInfo:(NSNotification *)notication
{
    DDCircleCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    cell.headerNameLabel.text = [notication object];
}

- (IBAction)buttonAction:(UIButton *)sender {
    
    if (![[GlobData shareInstance] canPushWalk:self.content.id] && self.isJoin)
    {
        [MBProgressHUD ShowTips:@"召集太频繁,请稍后再试 ！" delayTime:2.0 atView:nil];
        return;
    }
    
    if (self.isJoin)
    {
        DDPressWalkArg * arg = [[DDPressWalkArg alloc] init];
        DDUserAck * ack = [[GlobData shareInstance] user];
        arg.userId = ack.content.id;
        arg.circleId = self.content.id;
        
        [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"BaseAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
            if (bSuccess)
            {
                [[GlobData shareInstance] saveWalkTime:self.content.id];
                [MBProgressHUD ShowTips:@"召集令发送成功，小伙伴正在赶来！" delayTime:2.0 atView:nil];
            }
        }];
    }
    else
    {
        DDAddCircleArg * arg = [[DDAddCircleArg alloc] init];
        arg.circleId = self.content.id;
        DDUserAck * ack = [[GlobData shareInstance] user];
        arg.userId = ack.content.id;
        
        [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"DDBuildSiteAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
            
            if (bSuccess)
            {
                DDBuildSiteAck * ack = (DDBuildSiteAck *)response;
                
                DDCircleDetailArg * req = [[DDCircleDetailArg alloc] init];
                req.circleId = ack.content.id;
                req.isJoin = 1;
                DDUserAck * user = [[GlobData shareInstance] user];
                req.userId = user.content.id;
                
                [[DDHTTPClient shareInstance] beginHttpRequest:req parse:@"DDCircleDetailAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
                    if (bSuccess)
                    {
                        DDCircleDetailAck * res = (DDCircleDetailAck *)response;
                        self.content = res.content;
                        
                        self.isJoin = 1;
                        [self updateFuncBtn];
                        [self.tableView reloadData];
                    }
                }];
            }
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!self.isJoin)
    {
        return 1;
    }
    else
    {
        if (section == 1)
        {
            if (self.content.petNum > 5)
            {
                return 6;
            }
            else
            {
                return self.content.petNum;
            }
        }
        return 1;
    }
}

- (CGFloat)boundingRectWithAnnouncement
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0]};
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    CGFloat width;
    if (self.content.isCreateUser)
    {
        width = size.width - 80;
    }
    else
    {
        width = size.width - 48;
    }
    
    CGSize retSize = [self.content.announcement boundingRectWithSize:CGSizeMake(width, 0)
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 110.0;
    }
    else if (indexPath.section == 2)
    {
        return [self boundingRectWithAnnouncement] + 50;
    }
    else
    {
        if (self.isJoin)
        {
            return 50.0;
        }
        else
        {
            return 80.0;
        }
        
    }
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
    DDCircleCell * cell;
    if (indexPath.section == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"circleCellHeaderID"];
        NSString * picString = [NSString stringWithFormat:@"%@/%@",kPicBaseURL,self.content.pic];
        NSURL * url = [NSURL URLWithString:picString];
        [cell.headerView sd_setImageWithURL:url forState:UIControlStateNormal];
        cell.headerNameLabel.text = self.content.name;
        cell.placeLabel.text = self.content.address;
    }
    else if (indexPath.section == 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"circleCellNoticelD"];
        cell.noticeLabel.text = self.content.announcement;
        
        if (self.content.isCreateUser)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
    }
    else
    {
        if (self.isJoin)
        {
            
            if (indexPath.row == [self.content.data count])
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"circleCellShowAllID"];
                cell.delegate = self;
            }
            else
            {
                cell = [tableView dequeueReusableCellWithIdentifier:@"circleCellMemberID"];
                DDCircleDetailData * data = [self.content.data objectAtIndex:indexPath.row];
                NSString * picString = [NSString stringWithFormat:@"%@/%@",kPicBaseURL,data.header];
                NSURL * url = [NSURL URLWithString:picString];
                [cell.memberHeaderImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default-avatar"]];
                cell.memberNameLabel.text = data.nick;
                cell.memberdogLabel.text = data.breed;
                if (data.dogStatus)
                {
                    cell.memberdogImageView.hidden = NO;
                }
                else
                {
                    cell.memberdogImageView.hidden = YES;
                }
            }
        }
        else
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"circleCellNoAddlD"];
            cell.noAddLabel.text = [NSString stringWithFormat:@"%ld名铲屎官在此活跃",self.content.petNum];
            cell.noAddView.layer.cornerRadius = 5;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0)
    {
        [self performSegueWithIdentifier:@"circleInfoSegue" sender:nil];
    }
    else if (indexPath.section == 2)
    {
        if (self.content.isCreateUser)
        {
            [self performSegueWithIdentifier:@"circleNoticeDetailSegue" sender:nil];
        }
    }
    else if (indexPath.section == 1)
    {
        if (self.isJoin && indexPath.row != [self.content.data count])
        {
            [self performSegueWithIdentifier:@"gotoUserCenterSegue" sender:indexPath];
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"circleInfoSegue"])
    {
        DDMainCircleDetailViewController * viewController = segue.destinationViewController;
        viewController.content = self.content;
        viewController.bJoin = self.isJoin;
    }
    else if ([segue.identifier isEqualToString:@"circlePetsListSegue"])
    {
        DDMainCirclePetListViewController * viewcontroller = segue.destinationViewController;
        viewcontroller.circleID = self.content.id;
    }
    else if ([segue.identifier isEqualToString:@"gotoUserCenterSegue"])
    {
        DDUserCenterViewController * viewcontroller = segue.destinationViewController;
        viewcontroller.isUser = NO;
        NSIndexPath * indexPath = (NSIndexPath *)sender;
        DDCircleDetailData * data = [self.content.data objectAtIndex:indexPath.row];
        if (data.user.id == [[GlobData shareInstance] user].content.id)
        {
            viewcontroller.isUser = YES;
        }
        else
        {
            viewcontroller.isUser = NO;
        }
        viewcontroller.otherID = data.user.id;
    }
    else if ([segue.identifier isEqualToString:@"circleNoticeDetailSegue"])
    {
        DDModifyCircleNoticeViewController * viewController = (DDModifyCircleNoticeViewController *)segue.destinationViewController;
        viewController.content = self.content;
        viewController.delegate = self;
    }
}

- (void)showAllPetsAction
{
    [self performSegueWithIdentifier:@"circlePetsListSegue" sender:nil];
}

#pragma mark -
#pragma mark DDModifyCircleNoticeViewControllerDelegate
- (void)updateNoticeToUserInfo:(NSString *)notice
{
    self.content.announcement = notice;
    [self.tableView reloadData];
}

@end
