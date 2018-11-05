//
//  DDDogInfoViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/24.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDDogInfoViewController.h"
#import "DDDogInfoCell.h"
#import "UIViewController+Customize.h"
#import "UIColor+DDColor.h"
#import "DDHTTPClient.h"
#import "TKPicSelectTool.h"
#import "DDUserInfoArg.h"
#import "DDDogKindViewController.h"
#import "DDUserAck.h"
#import "DDPickDateView.h"
#import "GlobData.h"
#import "MBProgressHUD+DDHUD.h"
@interface DDDogInfoViewController()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,TKPicSelectDelegate,DDDogInfoCellDelegate,DDPickDateViewDelegate>
{
    TKPicSelectTool * tool;
    
    UIDatePicker * datePicker;
    
    long dogBirthday;
}
@property(nonatomic,strong)NSArray * titles;
@property(nonatomic,strong)DDPickDateView * pickView;
@property(nonatomic)NSInteger dogSex;
@property(nonatomic)NSString * dogName;
@property(nonatomic)NSInteger petID;
@property(nonatomic,copy)NSString * dogKindName;
@property(nonatomic,strong)UIImage * headerImage;
@end


@implementation DDDogInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"狗狗信息";
    [self addDefaultLeftBarItem];
    tool = [[TKPicSelectTool alloc] init];
    tool.selectDelegate = self;
    tool.viewController = self;
    self.titles = [NSArray arrayWithObjects:@"昵称",@"性别",@"品种",@"生日", nil];
}

#pragma mark -
#pragma mark private

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 129.0;
    }
    return 48.0;
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
    if (indexPath.row == 0)
    {
        DDDogInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellImageID"];
        cell.delegate = self;
        return cell;
    }
    else if (indexPath.row == 1)
    {
        DDDogInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellTextID"];
        cell.titleLabel.text = [self.titles objectAtIndex:indexPath.row - 1];
        cell.delegate = self;
        return cell;
    }
    else if (indexPath.row == 2)
    {
        DDDogInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellSexID"];
        cell.titleLabel.text = [self.titles objectAtIndex:indexPath.row - 1];
        cell.delegate = self;
        return cell;
    }
    else
    {
        DDDogInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cellText2ID"];
        cell.titleLabel.text = [self.titles objectAtIndex:indexPath.row - 1];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (indexPath.row == 3)
    {
        [self performSegueWithIdentifier:@"dogKindSegue" sender:nil];
    }
    
    if (indexPath.row == 4)
    {
        [self.pickView showPickView];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"dogKindSegue"])
    {
        DDDogKindViewController * viewController = segue.destinationViewController;
        viewController.backSegue = @"unwindToDogInfoSegue";
    }
}

- (void)updateUIForDog:(DDDog *)dog
{
    DDDogInfoCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    cell.detailLabel.text = dog.name;
    self.petID = dog.id;
    self.dogKindName = dog.name;
}

#pragma mark -
#pragma mark event
- (IBAction)finishAction:(UIButton *)sender
{
    if (!self.headerImage)
    {
        [MBProgressHUD ShowTips:@"狗狗头像不能为空" delayTime:2.0 atView:nil];
        return;
    }
    
    if ([self.dogName isEqualToString:@""] || !self.dogName)
    {
        [MBProgressHUD ShowTips:@"狗狗昵称不能为空" delayTime:2.0 atView:nil];
        return;
    }
    
    if (self.petID == 0)
    {
        [MBProgressHUD ShowTips:@"请选择狗狗品种" delayTime:2.0 atView:nil];
        return;
    }
    
    if (dogBirthday == 0)
    {
        [MBProgressHUD ShowTips:@"请选择狗狗生日" delayTime:2.0 atView:nil];
        return;
    }
    
    [[DDHTTPClient shareInstance] upLoadImage:self.headerImage imageType:Upload_Header_Type completion:^(BOOL bSuccess, NSString *imageURL, NSString *error) {
        
        DDUserInfoArg * arg = [[DDUserInfoArg alloc] init];
        
        DDUserAck * user = [[GlobData shareInstance] user];
        
        arg.userId = user.content.id;
        arg.userNick = self.nickName;
        arg.userGender = self.sex;
        arg.petNick = self.dogName;
        arg.petHeader = imageURL;
        arg.petGender = self.dogSex;
        arg.petBreadId = self.petID;
        arg.petBirthday = dogBirthday;
        arg.petBreed = self.dogKindName;
        [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"DDUserAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
            
            if (bSuccess)
            {
                DDUserAck * user = (DDUserAck *)response;
                [[GlobData shareInstance] updateUser:user];
                if (self.bFromMain)
                {
                    [self performSegueWithIdentifier:@"unwindToMainFromUserSegue" sender:nil];
                }
                else
                {
                     [self performSegueWithIdentifier:@"mainVCSegue2" sender:nil];
                }
            }
            
        }];
    }];
}


- (IBAction)unwindToDogInfoForSegue:(UIStoryboardSegue *)unwindSegue
{
    if ([unwindSegue.identifier isEqualToString:@"unwindToDogInfoSegue"])
    {
        DDDogKindViewController * viewcontroller = unwindSegue.sourceViewController;
        [self updateUIForDog:viewcontroller.dog];
    }
}

#pragma mark -
#pragma mark DDDogInfoCellDelegate
- (void)showPhonoTool
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [tool doSelectPic:@"选择" clipping:YES maxSelect:1];
}

- (void)updateDogSex:(NSInteger)sex
{
    self.dogSex = sex;
}

- (void)updateDogName:(NSString *)name
{
    self.dogName = name;
}


-(void)onImageSelect:(UIImage *)image
{
    self.headerImage = image;
    DDDogInfoCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.headerBtn setImage:image forState:UIControlStateNormal];
}

-(void)onImagesSelect:(NSArray *)images
{
    if ([images count] > 0)
    {
        self.headerImage = [images objectAtIndex:0];
        DDDogInfoCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [cell.headerBtn setImage:self.headerImage forState:UIControlStateNormal];
    }
    
}

#pragma mark -
#pragma mark DDPickDateViewDelegate
- (void)uploadBirthdayInfo:(NSDate *)date
{
    DDDogInfoCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    dogBirthday = date.timeIntervalSince1970 * 1000;
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMT];
    NSDate * newDate = [date dateByAddingTimeInterval:timeZoneOffset];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString * birthdayStr = [formatter stringFromDate:newDate];
    cell.detailLabel.text = birthdayStr;
    
    [self.pickView hidePickView];
}


#pragma mark -
#pragma mark getter
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
