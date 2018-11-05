//
//  DDUserCenterViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/18.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDUserCenterViewController.h"
#import "DDUserCenterCell.h"
#import "DDMyPageArg.h"
#import "DDOtherPageArg.h"
#import "GlobData.h"
#import "DDUserAck.h"
#import "DDHTTPClient.h"
#import "DDUserPageAck.h"
#import "GlobConfig.h"
#import "UIButton+WebCache.h"
#import "UIViewController+Customize.h"
#import "DDModifyUserInfoArg.h"
#import "TKPicSelectTool.h"
#import "DDFollowArg.h"
#import "DDUnfollowArg.h"
#import "DDModifyDogNameViewController.h"
#import "DDModifyUserNameViewController.h"
#import "DDDogKindViewController.h"
#import "DDPickDateView.h"
#import "DDUserAck.h"
#import "UIColor+DDColor.h"
#import "MBProgressHUD+DDHUD.h"
@interface DDUserCenterViewController()<UITableViewDelegate,UITableViewDataSource,TKPicSelectDelegate,DDUserCenterCellDelegate,DDModifyDogNameViewControllerDelegate,DDModifyUserNameViewControllerDelegate,DDPickDateViewDelegate>
{
    NSArray * titles;
    
    TKPicSelectTool * tool;
    
    long  dogBirthday;
    
    BOOL bChangeHeader;
    
}
@property(nonatomic,strong)DDUserPageContent * content;
@property(nonatomic,strong)DDPickDateView * pickView;
@end


@implementation DDUserCenterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    titles = [NSArray arrayWithObjects:@"昵称",@"性别",@"品种",@"年龄", nil];
    [self addDefaultLeftBarItem];
    if (self.isUser)
    {
        self.title = @"我的";
        
        [self addRightBarItemWithImageName:@"confirm_n"];
        DDMyPageArg * arg = [[DDMyPageArg alloc] init];
        DDUserAck * user = [[GlobData shareInstance] user];
        arg.userId = user.content.id;
        
        [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"DDUserPageAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
            if (bSuccess)
            {
                DDUserPageAck * ack = (DDUserPageAck *)response;
                self.content = ack.content;
                [self.tableView reloadData];
            }
        }];
    }
    else
    {
        self.title = @"名片页";
        DDOtherPageArg * arg = [[DDOtherPageArg alloc] init];
        DDUserAck * user = [[GlobData shareInstance] user];
        arg.userId = user.content.id;
        arg.otherId = self.otherID;
        [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"DDUserPageAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
            if (bSuccess)
            {
                DDUserPageAck * ack = (DDUserPageAck *)response;
                self.content = ack.content;
                [self.tableView reloadData];
            }
        }];
    }
    
    tool = [[TKPicSelectTool alloc] init];
    tool.selectDelegate = self;
    tool.viewController = self;
}

- (void)rightBarItemAction:(id)sender
{
    //先进行图片的上传
    
    if (bChangeHeader)
    {
        DDUserCenterCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
        [[DDHTTPClient shareInstance] upLoadImage:cell.headerBtn.imageView.image imageType:Upload_Header_Type completion:^(BOOL bSuccess, NSString *imageURL, NSString *error) {
            if (bSuccess)
            {
                [self submitModifyReqForHeaderURL:imageURL];
            }
        }];
    }
    else
    {
        [self submitModifyReqForHeaderURL:self.content.pet.header];
    }
}

- (void)submitModifyReqForHeaderURL:(NSString *)url
{
    DDModifyUserInfoArg * arg = [[DDModifyUserInfoArg alloc] init];
    DDUserAck * user = [[GlobData shareInstance] user];
    arg.userId = user.content.id;
    arg.userNick = self.content.nick;
    arg.userGender  = self.content.gender;
    arg.petId = self.content.pet.id;
    arg.petNick = self.content.pet.nick;
    arg.petHeader = url;
    arg.petGender = self.content.pet.gender;
    arg.petBreadId = self.content.pet.breedId;
    arg.petBreed = self.content.pet.breed;
    arg.petBirthday = dogBirthday;
    
    [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"DDUserAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
        if (bSuccess)
        {
            [MBProgressHUD ShowTips:@"操作成功" delayTime:2.0 atView:nil];
            DDUserAck * user = (DDUserAck *)response;
            [[GlobData shareInstance] updateUser:user];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserInfo" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (section == 0)
    {
        return 5;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1)
    {
        return 10.0;
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        return 110.0;
    }
    return 48.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDUserCenterCell * cell;
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"userCenterHeaderID"];
            cell.delegate = self;
            NSString * headerString = [NSString stringWithFormat:@"%@/%@",kPicBaseURL,self.content.pet.header];
            NSURL * url = [NSURL URLWithString:headerString];
            [cell.headerBtn sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default-avatar"]];
            if (self.isUser)
            {
                cell.followBtn.hidden = YES;
                cell.headerBtn.userInteractionEnabled = YES;
            }
            else
            {
                cell.followBtn.hidden = NO;
                cell.headerBtn.userInteractionEnabled = NO;
                if (self.content.isAttention)
                {
                    [cell.followBtn setTitle:@"取消关注" forState:UIControlStateNormal];
                    [cell.followBtn setTintColor:[UIColor text4Color]];
                    [cell.followBtn setBackgroundImage:[UIImage imageNamed:@"unattention"] forState:UIControlStateNormal];
                }
                else
                {
                    [cell.followBtn setTitle:@"+关注" forState:UIControlStateNormal];
                    [cell.followBtn setTintColor:[UIColor whiteColor]];
                    [cell.followBtn setBackgroundImage:[UIImage imageNamed:@"attention"] forState:UIControlStateNormal];
                }
            }
            
        }
        else if (indexPath.row == 2 && self.isUser)
        {
            cell = [tableView dequeueReusableCellWithIdentifier:@"userCenterSexID"];
            if (self.content.pet.gender == 0)
            {
                cell.manBtn.selected = NO;
                cell.womanBtn.selected = YES;
            }
            else
            {
                cell.manBtn.selected = YES;
                cell.womanBtn.selected = NO;
            }
            cell.titleLabel.text = [titles objectAtIndex:indexPath.row - 1];
        }
        else
        {
         
            cell = [tableView dequeueReusableCellWithIdentifier:@"userCenterNomalID"];
            if (self.isUser)
            {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            
            cell.titleLabel.text = [titles objectAtIndex:indexPath.row - 1];
            if (indexPath.row == 1)
            {
                cell.detailLabel.text = self.content.pet.nick;
            }
            else if (indexPath.row == 2)
            {
                if (self.content.pet.gender == 0)
                {
                    cell.detailLabel.text = @"MM";
                }
                else
                {
                    cell.detailLabel.text = @"GG";
                }
                
            }
            else if (indexPath.row == 3)
            {
                cell.detailLabel.text = [NSString stringWithFormat:@"%@",self.content.pet.breed];
            }
            else
            {
                NSDate * date =[NSDate dateWithTimeIntervalSince1970:self.content.pet.birthday / 1000];
                NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
                NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMT];
                NSDate * newDate = [date dateByAddingTimeInterval:timeZoneOffset];
                [formatter setDateFormat:@"yyyy/MM/dd"];
                NSString * dateStr = [formatter stringFromDate:newDate];
                cell.detailLabel.text = dateStr;
            }
        }
        
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"masterCellID"];
        cell.nameLabel.text = self.content.nick;
        if (self.content.gender == 0)
        {
            cell.sexImageView.image = [UIImage imageNamed:@"femal"];
        }
        else
        {
            cell.sexImageView.image = [UIImage imageNamed:@"male"];
        }
        if (self.isUser)
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
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
    if (!self.isUser)
    {
        return;
    }
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 1)
        {
            [self performSegueWithIdentifier:@"modifyDogNameSegue" sender:nil];
        }
        else if (indexPath.row == 3)
        {
            [self performSegueWithIdentifier:@"dogKindSegue3" sender:nil];
        }
        else if (indexPath.row == 4)
        {
            [self.pickView showPickView];
        }
    }
    else
    {
        [self performSegueWithIdentifier:@"modifyUserNameSegue" sender:nil];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"modifyDogNameSegue"])
    {
        DDModifyDogNameViewController * viewController = segue.destinationViewController;
        viewController.delegate = self;
        viewController.name = self.content.pet.nick;
    }
    else if ([segue.identifier isEqualToString:@"modifyUserNameSegue"])
    {
        DDModifyUserNameViewController * viewcontroller = segue.destinationViewController;
        viewcontroller.delegate  = self;
        viewcontroller.name = self.content.nick;
        viewcontroller.sex = self.content.gender;
    }
    else if ([segue.identifier isEqualToString:@"dogKindSegue3"])
    {
        DDDogKindViewController * viewController = segue.destinationViewController;
        viewController.backSegue = @"unwindToModifyUserInfoSegue";
    }
}

- (IBAction)unwindToModifyUserInfoForSegue:(UIStoryboardSegue *)unwindSegue
{
    if ([unwindSegue.identifier isEqualToString:@"unwindToModifyUserInfoSegue"])
    {
        DDDogKindViewController * viewcontroller = unwindSegue.sourceViewController;
        [self updateUIForDog:viewcontroller.dog];
    }
}

- (void)updateUIForDog:(DDDog *)dog
{
    self.content.pet.breed = dog.name;
    self.content.pet.breedId = dog.id;
    
    DDUserCenterCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    cell.detailLabel.text = dog.name;
}

#pragma mark -
#pragma mark DataPickViewDelegate
- (void)uploadBirthdayInfo:(NSDate *)date
{
    DDUserCenterCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMT];
    NSDate * newDate = [date dateByAddingTimeInterval:timeZoneOffset];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString * birthdayStr = [formatter stringFromDate:newDate];
    cell.detailLabel.text = birthdayStr;
    dogBirthday = date.timeIntervalSince1970 * 1000;
    [self.pickView hidePickView];
}


#pragma mark -
#pragma mark TKPicSelectDelegate

-(void)onImageSelect:(UIImage *)image
{
    bChangeHeader = YES;
    DDUserCenterCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.headerBtn setImage:image forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark DDUserCenterCellDelegate

- (void)headerBtnAction
{
    [tool doSelectPic:@"选择" clipping:YES maxSelect:1];
}

- (void)followBtnAction:(UIButton *)btn
{
    if (self.content.isAttention)
    {
        DDUnfollowArg * arg = [[DDUnfollowArg alloc] init];
        DDUserAck * user = [[GlobData shareInstance] user];
        arg.userId = user.content.id;
        arg.otherId = self.content.id;
        arg.userNick = self.content.nick;
        arg.userGender = self.content.gender;
        
        [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"BaseAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
            if (bSuccess)
            {
                self.content.isAttention = 0;
                [btn setTitle:@"+关注" forState:UIControlStateNormal];
                [btn setTintColor:[UIColor whiteColor]];
                [btn setBackgroundImage:[UIImage imageNamed:@"attention"] forState:UIControlStateNormal];
            }
        }];
    }
    else
    {
        DDFollowArg * arg = [[DDFollowArg alloc] init];
        DDUserAck * user = [[GlobData shareInstance] user];
        arg.userId = user.content.id;
        arg.otherId = self.content.id;
        arg.userNick = self.content.nick;
        arg.userGender = self.content.gender;
        
        [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"BaseAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
            if (bSuccess)
            {
                self.content.isAttention = 1;
                [btn setTitle:@"取消关注" forState:UIControlStateNormal];
                [btn setTintColor:[UIColor text4Color]];
                [btn setBackgroundImage:[UIImage imageNamed:@"unattention"] forState:UIControlStateNormal];
            }
        }];
    }
}

- (void)updateDogSex:(NSInteger)sex
{
    self.content.pet.gender = sex;
}

#pragma mark -
#pragma mark DDModifyDogNameViewControllerDelegate
- (void)updateDogName:(NSString *)dogName
{
    self.content.pet.nick = dogName;
    
    DDUserCenterCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.detailLabel.text = dogName;
}

#pragma mark -
#pragma mark DDModifyUserNameViewControllerDelegate
- (void)updateUserName:(NSString *)name withUserSex:(NSInteger)sex
{
    
    
    self.content.nick = name;
    self.content.gender = sex;
    
    DDUserCenterCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.nameLabel.text = name;
    

    if (sex == 0)
    {
        cell.sexImageView.image = [UIImage imageNamed:@"femal"];
    }
    else
    {
        cell.sexImageView.image = [UIImage imageNamed:@"male"];
    }
}


- (DDPickDateView *)pickView
{
    if (!_pickView)
    {
        _pickView = [[DDPickDateView alloc] initWithFrame:self.view.bounds];
        _pickView.delegate = self;
        [self.view addSubview:_pickView];
    }
    return _pickView;
}
@end
