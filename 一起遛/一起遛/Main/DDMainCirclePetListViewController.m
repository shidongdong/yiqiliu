//
//  DDMainCirclePetListViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/8.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDMainCirclePetListViewController.h"
#import "UIViewController+Customize.h"
#import "DDHTTPClient.h"
#import "DDCircleListCell.h"
#import "DDPetListArg.h"
#import "DDPetListAck.h"
#import "UIImageView+WebCache.h"
#import "GlobConfig.h"
#import "DDUserCenterViewController.h"
#import "DDUserAck.h"
#import "GlobData.h"
@interface DDMainCirclePetListViewController()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray * pets;

@end

@implementation DDMainCirclePetListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addDefaultLeftBarItem];
    self.title = @"全部成员";
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self requestPetList];
}

- (void)requestPetList
{
    DDPetListArg * arg = [[DDPetListArg alloc] init];
    arg.circleId = self.circleID;
    arg.pageSize = 100;
    
    [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"DDPetListAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
        if (bSuccess)
        {
            DDPetListAck * ack = (DDPetListAck *)response;
            [self.pets addObjectsFromArray:ack.content];
            [self.tableView reloadData];
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.pets.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDCircleListCell * cell = [tableView dequeueReusableCellWithIdentifier:@"circleListCellID"];
    
    DDCircleDetailData * data = [self.pets objectAtIndex:indexPath.row];
    NSString * petHeader = [NSString stringWithFormat:@"%@/%@",kPicBaseURL,data.header];
    NSURL * url = [NSURL URLWithString:petHeader];
    [cell.headerImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default-avatar"]];
    if (data.dogStatus)
    {
        cell.dogImageView.hidden = NO;
    }
    else
    {
        cell.dogImageView.hidden = YES;
    }
    cell.nameLabel.text = data.nick;
    cell.dogLabel.text = data.breed;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self performSegueWithIdentifier:@"gotoUserCenterFromListSegue" sender:indexPath];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"gotoUserCenterFromListSegue"])
    {
        DDUserCenterViewController * viewcontroller = segue.destinationViewController;
        
        NSIndexPath * indexPath = (NSIndexPath *)sender;
        DDCircleDetailData * data = [self.pets objectAtIndex:indexPath.row];
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
}

#pragma mark -
#pragma mark getter
- (NSMutableArray *)pets
{
    if (!_pets)
    {
        _pets = [[NSMutableArray alloc] init];
    }
    return _pets;
}

@end
