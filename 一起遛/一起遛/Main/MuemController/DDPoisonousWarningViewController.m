//
//  DDPoliceWarningViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/30.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDPoisonousWarningViewController.h"
#import "UIViewController+Customize.h"
#import "DDHTTPClient.h"
#import "DDBugWarnArg.h"
#import "GlobData.h"
#import "DDUserAck.h"
#import "MBProgressHUD+DDHUD.h"
#import "DDMapView.h"

@interface DDPoisonousWarningViewController()<DDMapViewDelegate>
{
    CLLocationCoordinate2D  mCoordinate;
}
@property(nonatomic,strong)DDMapView * mapView;

@end

@implementation DDPoisonousWarningViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addDefaultLeftBarItem];
    self.title = @"有毒警报";
    
    self.mapView = [[DDMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 128)];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
  
    
}

- (IBAction)sendWarnningAction:(UIButton *)sender {
    
    if (![[GlobData shareInstance] canPushPoisonousWarn])
    {
        [MBProgressHUD ShowTips:@"距上一次发送警报时间过短,请稍后发送" delayTime:2 atView:nil];
        return;
    }
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:nil message:@"确定在此位置建立有毒警报？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        DDBugWarnArg * arg = [[DDBugWarnArg alloc] init];
        
        DDUserAck * user =[[GlobData shareInstance] user];
        arg.userId =user.content.id;
        arg.latitude = mCoordinate.latitude;
        arg.longitude = mCoordinate.longitude;
        arg.address = self.placeLabel.text;
        [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"BaseAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
            if (bSuccess)
            {
                [[GlobData shareInstance] savePoisonousWarnTime];
                [MBProgressHUD ShowTips:@"发送成功，附近铲屎官会收到警报" delayTime:2 atView:nil];
                [self performSegueWithIdentifier:@"unwindFromPoisonousSegue" sender:nil];
            }
        }];
        
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)reloadMapLocation:(CLLocationCoordinate2D)coordinate placeName:(NSString *)place
{
    self.placeLabel.text = place;
    mCoordinate = coordinate;
}
@end
