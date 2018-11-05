//
//  DDMainCircleDetailViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/8.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDMainCircleDetailViewController.h"
#import "UIViewController+Customize.h"
#import "DDCircleDetailCell.h"
#import "GlobConfig.h"
#import "UIButton+WebCache.h"
#import "DDQuitCircleArg.h"
#import "GlobData.h"
#import "DDUserAck.h"
#import "DDHTTPClient.h"
#import "DDModifyCircleNameViewController.h"
#import "TKPicSelectTool.h"
#import "DDModifyCircleArg.h"
@interface DDMainCircleDetailViewController()<UITableViewDelegate,UITableViewDataSource,DDModifyCircleNameViewControllerDelegate,TKPicSelectDelegate,DDCircleDetailCellDelegate>
{
    NSArray * titles;
    
    TKPicSelectTool * tool;
    
}

@end


@implementation DDMainCircleDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    tool = [[TKPicSelectTool alloc] init];
    tool.selectDelegate = self;
    tool.viewController = self;
    [self addDefaultLeftBarItem];
    self.title = @"地盘详情";
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    titles = [NSArray arrayWithObjects:@"地盘名称",@"地盘位置",@"建立者",@"建立时间", nil];
    
    if (!self.bJoin)
    {
        self.exitButton.hidden = YES;
    }
    
}
- (IBAction)exitAction:(UIButton *)sender {
    DDQuitCircleArg * arg = [[DDQuitCircleArg alloc] init];
    DDUserAck * user = [[GlobData shareInstance] user];
    arg.userId = user.content.id;
    arg.circleId = self.content.id;
    
    [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"BaseAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
        if (bSuccess)
        {
            [self performSegueWithIdentifier:@"unwindFromExitCircleSegue" sender:nil];
        }
    }];
}

- (void)uploadCicleHeader:(UIImage *)image
{
    [[DDHTTPClient shareInstance] upLoadImage:image imageType:Upload_Domain_Type completion:^(BOOL bSuccess, NSString *imageURL, NSString *error) {
        if (bSuccess)
        {
            DDCircleDetailCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            [cell.headerBtn setImage:image forState:UIControlStateNormal];
            
            DDModifyCircleArg * arg = [[DDModifyCircleArg alloc] init];
            arg.userId = [[GlobData shareInstance] user].content.id;
            arg.pic = imageURL;
            arg.id = self.content.id;
            [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"BaseAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
                if (bSuccess)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"uploadCicleHeaderNotify" object:image];
                }
                else
                {
                    NSString * headerStr = [NSString stringWithFormat:@"%@/%@",kPicBaseURL,self.content.pic];
                    NSURL * url = [NSURL URLWithString:headerStr];
                    [cell.headerBtn sd_setImageWithURL:url forState:UIControlStateNormal];
                }
            }];
            
        }
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 110.0;
    }
    return 48.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDCircleDetailCell * cell;
    if (indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"circleDetailHeaderID"];
        cell.delegate = self;
        NSString * headerStr = [NSString stringWithFormat:@"%@/%@",kPicBaseURL,self.content.pic];
        NSURL * url = [NSURL URLWithString:headerStr];
        if (self.content.isCreateUser)
        {
            cell.headerBtn.userInteractionEnabled = YES;
        }
        else
        {
            cell.headerBtn.userInteractionEnabled = NO;
        }
        [cell.headerBtn sd_setImageWithURL:url forState:UIControlStateNormal];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"circleDetailInfoID"];
        cell.nameLabel.text = [titles objectAtIndex:indexPath.row - 1];
        
        NSString * detail;
        if (indexPath.row == 1)
        {
            detail = self.content.name;
            if (self.content.isCreateUser)
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
        else if (indexPath.row == 2)
        {
            detail = self.content.address;
        }
        else if (indexPath.row == 3)
        {
            detail = self.content.createUser;
        }
        else
        {
            NSDate * date = [NSDate dateWithTimeIntervalSince1970:self.content.createDate/1000];
            NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
            NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMT];
            NSDate * newDate = [date dateByAddingTimeInterval:timeZoneOffset];
            [formatter setDateFormat:@"yyyy/MM/dd"];
            NSString * dateStr = [formatter stringFromDate:newDate];
            detail = dateStr;
        }
        
        cell.detailLabel.text = detail;
    }
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
    if (indexPath.row == 1 && self.content.isCreateUser)
    {
        [self performSegueWithIdentifier:@"modifyCircleNameSegue" sender:nil];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"modifyCircleNameSegue"])
    {
        DDModifyCircleNameViewController * viewController = (DDModifyCircleNameViewController *)segue.destinationViewController;
        viewController.content = self.content;
        viewController.delegate = self;
    }
}

#pragma mark -
#pragma mark DDModifyCircleNameViewControllerDelegate
- (void)updateUserName:(NSString *)name
{
    self.content.name = name;
    DDCircleDetailCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.detailLabel.text = name;
}

#pragma mark -
#pragma mark CellDelegate
- (void)showPicTool
{
    [tool doSelectPic:@"选择" clipping:NO maxSelect:1];
}


#pragma mark -
#pragma mark TKToolDelegate
-(void)onImageSelect:(UIImage *)image
{
    [self uploadCicleHeader:image];
}
-(void)onImagesSelect:(NSArray *)images
{
    if (images.count > 0)
    {
        UIImage * image = [images objectAtIndex:0];
        [self uploadCicleHeader:image];
    }
}

@end
