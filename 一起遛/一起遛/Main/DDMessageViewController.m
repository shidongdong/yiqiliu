//
//  DDMessageViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/5.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDMessageViewController.h"
#import "UIViewController+Customize.h"
#import "DDMessageCell.h"
#import "DDMessageArg.h"
#import "DDHTTPClient.h"
#import "DDUserAck.h"
#import "GlobData.h"
#import "DDMessageAck.h"
#import "DDDleMessageArg.h"
#import "UIImageView+WebCache.h"
#import "GlobConfig.h"
#import "DDLostWebViewController.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshBackNormalFooter.h"
#import "GeTuiSdk.h"
@interface DDMessageViewController()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger pageIndex;
}
@property(nonatomic,strong)NSMutableArray * sourceList;
@end


@implementation DDMessageViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [GeTuiSdk setBadge:0];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [self addDefaultLeftBarItem];
    self.title = @"消息";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateNewMessage:) name:@"newMessageNotify" object:nil];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reqMessage)];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reqMore)];
    self.tableView.tableFooterView = [[UIView alloc] init];
//    [self.tableView.mj_header beginRefreshing];
    [self reqMessage];
}

- (void)reqMessage
{
    pageIndex = 1;
    
    DDMessageArg * arg = [[DDMessageArg alloc] init];
    arg.userId = [[GlobData shareInstance] user].content.id;
    arg.currentPage = pageIndex;
    [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"DDMessageAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
        [self.tableView.mj_header endRefreshing];
        if (bSuccess)
        {
            DDMessageAck * ack = (DDMessageAck *)response;
            
            if (ack.content.count < 20)
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            else
            {
                [self.tableView.mj_footer resetNoMoreData];
            }
            [self.sourceList removeAllObjects];
            [self.sourceList addObjectsFromArray:ack.content];
            [self.tableView reloadData];
        }
    }];
}

- (void)reqMore
{
    pageIndex++;
    DDMessageArg * arg = [[DDMessageArg alloc] init];
    arg.userId = [[GlobData shareInstance] user].content.id;
    arg.currentPage = pageIndex;
    [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"DDMessageAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
        [self.tableView.mj_footer endRefreshing];
        if (bSuccess)
        {
            
            DDMessageAck * ack = (DDMessageAck *)response;
            [self.sourceList addObjectsFromArray:ack.content];
            
            if (ack.content.count < 20)
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            [self.tableView reloadData];
        }
    }];
}

- (void)updateNewMessage:(NSNotification *)notication
{
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sourceList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDMessageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"messageCellID"];
    DDMessageContent * content = [self.sourceList objectAtIndex:indexPath.row];
    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kPicBaseURL,content.header]];
    if (content.type == 0)
    {
        cell.headerView.image = [UIImage imageNamed:@"default-system"];
    }
    else
    {
        [cell.headerView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default-avatar"]];
    }
    cell.infoLabel.text = content.content;
    cell.timeLabel.text = [self transformToDate:content.createTime];
    NSString * title;
    if (content.type == 0)
    {
        title = @"系统消息";
    }
    else if (content.type == 1)
    {
        title = @"城管警报";
    }
    else if (content.type == 2)
    {
        title = @"召唤令";
    }
    else if (content.type == 3)
    {
        title = @"有毒警报";
    }
    else if (content.type == 4)
    {
        title = @"寻狗启示";
    }
    cell.titleLabel.text = title;
    return cell;
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


- (NSString *)transformToDate:(long)createTime
{
    NSDate * nowDate = [NSDate date];
    NSTimeInterval nowTime = nowDate.timeIntervalSince1970;
    NSTimeInterval sec = nowTime - createTime /1000;
    if (sec < 60)
    {
        return [NSString stringWithFormat:@"%d秒前",(int)sec];
    }
    else if (sec < 3600)
    {
        return [NSString stringWithFormat:@"%d分钟前",(int)sec/60];
    }
    else if (sec < 3600 * 24)
    {
        return [NSString stringWithFormat:@"%d小时前",(int)sec/3600];
    }
    else
    {
        NSDate * date = [NSDate dateWithTimeIntervalSince1970:createTime / 1000];
        NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMT];
        NSDate * newDate = [date dateByAddingTimeInterval:timeZoneOffset];
        NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd"];
        NSString * dateStr = [formatter stringFromDate:newDate];
        return dateStr;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDMessageContent * content = [self.sourceList objectAtIndex:indexPath.row];
    CGFloat height = [self boundingRectWithInfo:content.content];
    return height + 60.0f;
}

- (CGFloat)boundingRectWithInfo:(NSString *)message
{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0]};
    
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    CGFloat width = size.width - 98;
    
    CGSize retSize = [message boundingRectWithSize:CGSizeMake(width, 0)
                                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                                          attributes:attribute
                                                             context:nil].size;
    
    return retSize.height;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        DDDleMessageArg * arg = [[DDDleMessageArg alloc] init];
        DDMessageContent * content = [self.sourceList objectAtIndex:indexPath.row];
        arg.id = content.id;
        arg.userId = [[GlobData shareInstance] user].content.id;
        [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"BaseAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
            if (bSuccess)
            {
                [self.sourceList removeObjectAtIndex:indexPath.row];
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DDMessageContent * content = [self.sourceList objectAtIndex:indexPath.row];
    if (content.url.length > 0)
    {
        [self performSegueWithIdentifier:@"lostWebSegue" sender:content.url];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"lostWebSegue"])
    {
        DDLostWebViewController * viewController = (DDLostWebViewController *)segue.destinationViewController;
        viewController.lostURL = sender;
    }
}

#pragma mark -
#pragma mark getter
- (NSMutableArray *)sourceList
{
    if (!_sourceList)
    {
        _sourceList = [[NSMutableArray alloc] init];
    }
    return _sourceList;
}

@end
