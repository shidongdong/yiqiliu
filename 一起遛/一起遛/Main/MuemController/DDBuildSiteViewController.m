//
//  DDBuildSiteViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/30.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDBuildSiteViewController.h"
#import "UIViewController+Customize.h"
#import "DDHTTPClient.h"
#import "MBProgressHUD+DDHUD.h"
#import "DDBuildSiteArg.h"
#import "DDBuildSiteAck.h"
#import "DDUserAck.h"
#import "GlobData.h"
#import "DDMapView.h"
#import "TKPicSelectTool.h"
#import "Masonry.h"
#import "GlobConfig.h"
@interface DDBuildSiteViewController()<DDMapViewDelegate,UITextFieldDelegate,TKPicSelectDelegate>
{
    CLLocationCoordinate2D placeCoordinate;
    
    TKPicSelectTool * tool;
    
    BOOL hasChoosePhoto;
}
@property(nonatomic,strong)DDMapView * mapView;
@end

@implementation DDBuildSiteViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addDefaultLeftBarItem];
    self.title = @"建立地盘";
    
    tool = [[TKPicSelectTool alloc] init];
    tool.selectDelegate = self;
    tool.viewController = self;
    
    self.mapView = [[DDMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 270)];
    ///把地图添加至view
    self.mapView.delegate  = self;
    [self.view addSubview:self.mapView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotify:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotify:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotify:) name:UIKeyboardWillHideNotification object:nil];
}

- (IBAction)buildSiteAction:(UIButton *)sender {
    
    BOOL bAble = [self checkAvailable];
    
    if (!bAble)
    {
        return;
    }
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"确定要在此位置建立地盘？建立后不可撤销" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [[DDHTTPClient shareInstance] upLoadImage:self.headerButton.imageView.image imageType:Upload_Domain_Type completion:^(BOOL bSuccess, NSString *imageURL, NSString *error) {
            if (bSuccess)
            {
                DDBuildSiteArg * arg = [[DDBuildSiteArg alloc] init];
                DDUserAck * ack = [[GlobData shareInstance] user];
                arg.userId = ack.content.id;
                arg.name = self.nameTextField.text;
                arg.address = self.placeLabel.text;
                arg.pic = imageURL;
                arg.longitude = placeCoordinate.longitude;
                arg.latitude = placeCoordinate.latitude;
                
                [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"DDBuildSiteAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
                    if (bSuccess)
                    {
                        [MBProgressHUD ShowTips:@"建立地盘成功" delayTime:2 atView:nil];
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                }];
            }
        }];
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (BOOL)checkAvailable
{
    if (self.nameTextField.text.length == 0)
    {
        [MBProgressHUD ShowTips:@"请填写地盘名称" delayTime:2.0 atView:nil];
        return NO;
    }
    
    if (!hasChoosePhoto)
    {
        [MBProgressHUD ShowTips:@"请选择一张照片作为圈子的标志" delayTime:2.0 atView:nil];
        return NO;
    }
    
    return YES;
}

- (IBAction)photoClick:(UIButton *)sender {
    //进入照相机
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    [tool doSelectPic:@"选择" clipping:YES maxSelect:1];
    
}

- (void)keyboardNotify:(NSNotification *)notication
{
    WS(weakSelf)
    if ([notication.name isEqualToString:UIKeyboardWillHideNotification])
    {
        [UIView animateWithDuration:0.2 animations:^{
            [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(0);
            }];
            [self.bgView updateConstraints];
        }];
    }
    else
    {
        
        NSDictionary *userInfo = [notication userInfo];
        NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect keyboardRect = [aValue CGRectValue];
        int height = keyboardRect.size.height;
        [UIView animateWithDuration:0.2 animations:^{
            [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(-height);
            }];
            [self.bgView updateConstraints];
            
        }];
    }
    
}

- (void)reloadMapLocation:(CLLocationCoordinate2D)coordinate placeName:(NSString *)place
{
    self.placeLabel.text = place;
    placeCoordinate = coordinate;
}


#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)onImageSelect:(UIImage *)image
{
    hasChoosePhoto = YES;
    [self.headerButton setImage:image forState:UIControlStateNormal];
}


@end
