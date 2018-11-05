//
//  DDDogLostViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/31.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDDogLostViewController.h"
#import "DDDogLostCell.h"
#import "UIViewController+Customize.h"
#import "DDDogKindViewController.h"
#import "DDAppealDogLostArg.h"
#import "DDHTTPClient.h"
#import "DDUserAck.h"
#import "GlobData.h"
#import "DDDogLostMapViewController.h"
#import "DDPickDateView.h"
#import "Masonry.h"
#import "GlobConfig.h"
#import "MBProgressHUD+DDHUD.h"
@interface DDDogLostViewController()<UITableViewDelegate,UITableViewDataSource,DDDogLostCellDelegate,DDPickDateViewDelegate,DDDogLostPicViewDelegate>
{
    NSInteger  dogID;
    
    NSInteger  dogSex;
    
    CLLocationCoordinate2D mCoordinate;
    
    long dogLostTime;
    
}
@property(nonatomic,strong)DDPickDateView * pickView;
@property(nonatomic,copy)NSString * phone;
@property(nonatomic,copy)NSString * nickName;
@property(nonatomic,copy)NSString * remarkInfo;
@property(nonatomic,strong)NSString * lostPlace;
@property(nonatomic,strong)NSMutableArray * uploadImages;
@end

@implementation DDDogLostViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addDefaultLeftBarItem];
    self.title = @"狗狗走失";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotify:) name:UIKeyboardWillShowNotification object:nil];
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotify:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotify:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)unwindToDogLostForSegue:(UIStoryboardSegue *)unwindSegue
{
    if ([unwindSegue.identifier isEqualToString:@"unwindToDogLostSegue"])
    {
        DDDogKindViewController * viewcontroller = unwindSegue.sourceViewController;
        [self updateUIForDog:viewcontroller.dog];
    }
    else if ([unwindSegue.identifier isEqualToString:@"unwindFromMapSegue"])
    {
        DDDogLostMapViewController * viewcontroller = unwindSegue.sourceViewController;
        [self updateLocation:viewcontroller.mCoordinate placeName:viewcontroller.placeLabel.text];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"dogKindSegue2"])
    {
        DDDogKindViewController * viewController = segue.destinationViewController;
        viewController.backSegue = @"unwindToDogLostSegue";
    }
}


- (void)updateUIForDog:(DDDog *)dog
{
    DDDogLostCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell.kindLabel.text = dog.name;
    dogID = dog.id;
}

- (void)updateLocation:(CLLocationCoordinate2D)coordinate placeName:(NSString *)place
{
    mCoordinate = coordinate;
    self.lostPlace = place;
    
    DDDogLostCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    cell.placeLabel.text = place;
}


- (void)keyboardNotify:(NSNotification *)notication
{
    WS(weakSelf)
    if ([notication.name isEqualToString:UIKeyboardWillHideNotification])
    {
        [UIView animateWithDuration:0.2 animations:^{
            
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(weakSelf.funcView.mas_top).with.offset(0);
            }];
            [self.tableView updateConstraints];
        }];
    }
    else
    {
        NSDictionary *userInfo = [notication userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        int height = keyboardRect.size.height;
        [UIView animateWithDuration:0.2 animations:^{
            
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(weakSelf.funcView.mas_top).with.offset(120 - height);
            }];
            [self.tableView updateConstraints];
        }];
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 7)
    {
        return 243.0;
    }
    else if (indexPath.row == 6)
    {
        return 114.0;
    }
    else
    {
        return 48.0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDDogLostCell * cell;
    if (indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"lostDogNameID"];
        cell.delegate = self;
    }
    else if (indexPath.row == 1)
    {
         cell = [tableView dequeueReusableCellWithIdentifier:@"lostDogKindID"];
    }
    else if (indexPath.row == 2)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"lostDogSexID"];
        cell.delegate = self;
        
    }
    else if (indexPath.row == 3)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"lostDogPlaceID"];
    }
    else if (indexPath.row == 4)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"lostDogTimeID"];
        
    }
    else if (indexPath.row == 5)
    {
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"lostDogPhoneID"];
        cell.delegate = self;
    }
    else if (indexPath.row == 6)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"lostDogPicID"];
        cell.picView.presentViewController = self;
        cell.picView.delegate = self;
        
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"lostDogContentID"];
        cell.delegate = self;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 1)
    {
        [self performSegueWithIdentifier:@"dogKindSegue2" sender:nil];
    }
    else if (indexPath.row == 3)
    {
        [self performSegueWithIdentifier:@"showLostMapSegue" sender:nil];
    }
    else if (indexPath.row == 4)
    {
        [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
        [self.pickView showPickView];
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

#pragma mark -
#pragma mark DDDogLostCellDelegate
- (void)updateLostDogSex:(NSInteger)sex
{
    dogSex = sex;
}

- (void)updateNickName:(NSString *)name
{
    self.nickName = name;
}

- (void)updatePhone:(NSString *)phone
{
    self.phone = phone;
}

- (void)updateLostInfo:(NSString *)info
{
    self.remarkInfo = info;
}


- (IBAction)dogAdviseInfoClick:(UIButton *)sender {
    
    
}

- (IBAction)submitAction:(UIButton *)sender {
    
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if ([self.nickName isEqualToString:@""] || !self.nickName)
    {
        [MBProgressHUD ShowTips:@"狗狗昵称不能为空" delayTime:2.0 atView:nil];
        return;
    }
    
    if (dogID == 0)
    {
        [MBProgressHUD ShowTips:@"请选择狗狗品种" delayTime:2.0 atView:nil];
        return;
    }
    
    if ([self.lostPlace isEqualToString:@""] || !self.lostPlace)
    {
        [MBProgressHUD ShowTips:@"走失地点不能为空" delayTime:2.0 atView:nil];
        return;
    }
    
    if (dogLostTime == 0)
    {
        [MBProgressHUD ShowTips:@"请选择狗狗丢失时间" delayTime:2.0 atView:nil];
        return;
    }
    
    if ([self.phone isEqualToString:@""] || !self.phone)
    {
        [MBProgressHUD ShowTips:@"联系号码不能为空" delayTime:2.0 atView:nil];
        return;
    }
    
    if (self.uploadImages.count == 0)
    {
        [MBProgressHUD ShowTips:@"狗狗照片不能为空" delayTime:2.0 atView:nil];
        return;
    }

    if ([self.remarkInfo isEqualToString:@""] || !self.remarkInfo)
    {
        [MBProgressHUD ShowTips:@"详细描述不能为空" delayTime:2.0 atView:nil];
        return;
    }
    
    
    [[DDHTTPClient shareInstance] upLoadImage:[self.uploadImages objectAtIndex:0] imageType:Upload_Domain_Type completion:^(BOOL bSuccess, NSString *imageURL, NSString *error) {
        if (bSuccess)
        {
            DDAppealDogLostArg * arg = [[DDAppealDogLostArg alloc] init];
            DDUserAck * ack = [[GlobData shareInstance] user];
            arg.userId = ack.content.id;
            arg.pic1 = imageURL;
            arg.pic2 = @"";
            arg.pic3 = @"";
            arg.nick = self.nickName;
            arg.breedId = dogID;
            arg.gender = dogSex;
            arg.lostArea = self.lostPlace;
            arg.lostTime = dogLostTime;
            arg.contactPhone  =self.phone;
            arg.longitude = mCoordinate.longitude;
            arg.latitude = mCoordinate.latitude;
            arg.remark = self.remarkInfo;
            [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"BaseAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
                if (bSuccess)
                {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }];
}

- (void)uploadBirthdayInfo:(NSDate *)date
{
    DDDogLostCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    NSTimeInterval timeZoneOffset = [[NSTimeZone systemTimeZone] secondsFromGMT];
    NSDate * newDate = [date dateByAddingTimeInterval:timeZoneOffset];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString * birthdayStr = [formatter stringFromDate:newDate];
    cell.timeLabel.text = birthdayStr;
    
    dogLostTime = date.timeIntervalSince1970 * 1000;
    
    [self.pickView hidePickView];
}

#pragma mark -
#pragma mark DDDogLostPicViewDelegate
- (void)uploadPics:(NSArray *)pics
{
    DDDogLostCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    cell.picNumLabel.text = [NSString stringWithFormat:@"(%ld/1)",pics.count];
    
    [self.uploadImages removeAllObjects];
    [self.uploadImages addObjectsFromArray:pics];
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

- (NSMutableArray *)uploadImages
{
    if (!_uploadImages)
    {
        _uploadImages = [[NSMutableArray alloc] init];
    }
    return _uploadImages;
}

@end
