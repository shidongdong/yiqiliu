//
//  DDMainViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/22.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDMainViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "UIViewController+Customize.h"
#import "DDCustomAnnotationView.h"
#import "DDMuemView.h"
#import "DDUserAck.h"
#import "GlobData.h"
#import "GlobConfig.h"
#import "DDHTTPClient.h"
#import "DDAllCircleArg.h"
#import "DDAllCircleAck.h"
#import "GlobData.h"
#import "DDCustomAnnotation.h"
#import "DDCircleDetailArg.h"
#import "DDCircleDetailAck.h"
#import "DDMainCircleViewController.h"
#import "DDPoliceWarnListViewController.h"
#import "DDGetUserInfoArg.h"
#import "DDUserCenterViewController.h"
#import "DDStartDogArg.h"
#import "DDEndDogArg.h"
#import "AppDelegate.h"
#import "DDCustomUserView.h"
#import "DDUserAnnotation.h"
#import "UIImageView+WebCache.h"
#import "DDUploadLocationArg.h"
#import "MBProgressHUD+DDHUD.h"
#import "DDUserInfoViewController.h"
@interface DDMainViewController()<MAMapViewDelegate,DDMuemViewDelegate>
{
    CLLocationCoordinate2D  mCoordinate;
    
    double  mapDistance;
    
    CLLocationDistance distance;
    
    BOOL  bJoinCircle;
    
    UIButton * dogBtn;
    
    BOOL bDogWalk;
    
    NSTimer * timer;
    
    NSInteger otherID;
    
}
@property(nonatomic,strong)MAMapView * mapView;
@property(nonatomic,strong)DDMuemView * muemView;
@property(nonatomic,strong)NSMutableArray * annationViews;
@end


@implementation DDMainViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ///初始化地图
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    ///把地图添加至view
    self.mapView.delegate  = self;
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    self.mapView.showsCompass = NO;
    self.mapView.showsScale = NO;
    self.mapView.zoomLevel = 18;
//    self.mapView.minZoomLevel = 10;
//    self.mapView.maxZoomLevel = 18;
    _mapView.allowsBackgroundLocationUpdates = YES;
    [self.view addSubview:_mapView];
    
    
    
    dogBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dogBtn.frame = CGRectMake(self.view.frame.size.width / 2 - 30, self.view.frame.size.height - 100, 60, 60);
    [dogBtn addTarget:self action:@selector(dogWalkAction:) forControlEvents:UIControlEventTouchUpInside];
    [dogBtn setImage:[UIImage imageNamed:@"walkdog_switch_n"] forState:UIControlStateNormal];
    [dogBtn setImage:[UIImage imageNamed:@"walkdog_switch_p"] forState:UIControlStateHighlighted];
    dogBtn.hidden = YES;
    [self.view addSubview:dogBtn];
    
    DDUserAck * ack = [[GlobData shareInstance] user];
    if (!ack)
    {
        DDGetUserInfoArg * arg = [[DDGetUserInfoArg alloc] init];
        NSInteger userID = [[[NSUserDefaults standardUserDefaults] objectForKey:kParamUserInfo] integerValue];
        arg.userId = userID;
        [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"DDUserAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
            if (bSuccess)
            {
                DDUserAck * user = (DDUserAck *)response;
                [[GlobData shareInstance] updateUser:user];
                
                [self.muemView setContentWithHeaderURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kPicBaseURL,user.content.pet.header]] withNickName:user.content.pet.nick withDogState:user.content.walkType];
                if (user.content.walkType == 2)
                {
                    dogBtn.hidden = NO;
                }
                else
                {
                    bDogWalk = NO;
                }
                [self searchDogCircleInfoForVisiableMapView:self.mapView];
                
                if (!user.content.isComplete)
                {
                    [self performSegueWithIdentifier:@"finishInfoSegue" sender:nil];
                }
                
            }
            else
            {
                [self stopTimer];
                
                AppDelegate * app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                [app goLoginViewController];
            }
        }];
    }
    else
    {
        [self updateMuemInfo];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMuemInfo) name:@"updateUserInfo" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopTimer) name:@"stopLocationTimerNotify" object:nil];
    //设置基本的标题栏
}

- (void)updateMuemInfo
{
    DDUserAck * ack = [[GlobData shareInstance] user];
    [self.muemView setContentWithHeaderURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kPicBaseURL,ack.content.pet.header]] withNickName:ack.content.pet.nick withDogState:ack.content.walkType];
    if (ack.content.walkType == 2)
    {
        dogBtn.hidden = NO;
    }
    else
    {
        bDogWalk = YES;
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)stopTimer
{
    self.mapView.delegate  = nil;
    if (timer)
    {
        [timer invalidate];
        timer = nil;
    }
}

//实时上报用户位置
- (void)uploadUserLoaction:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"上报了位置");
    DDUploadLocationArg * arg = [[DDUploadLocationArg alloc] init];
    DDUserAck * user = [[GlobData shareInstance] user];
    arg.userId = user.content.id;
    arg.latitude = coordinate.latitude;
    arg.longitude = coordinate.longitude;
    
    [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"BaseAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
        
    }];
}

- (IBAction)unwindToMainMapViewForSegue:(UIStoryboardSegue *)unwindSegue
{
    if ([unwindSegue.identifier isEqualToString:@"unwindFromPoliceWarnSegue"])
    {
        
    }
    else if ([unwindSegue.identifier isEqualToString:@"unwindFromPoisonousSegue"])
    {
        
    }
    else if ([unwindSegue.identifier isEqualToString:@"unwindToMainFromUserSegue"])
    {
        [self updateMuemInfo];
    }
}

- (void)dogWalkAction:(UIButton *)btn
{
//    [self reqUserAroundCircle];
//    
//    return;
    
    bDogWalk = !bDogWalk;
    DDUserAck * user = [[GlobData shareInstance] user];
    if (bDogWalk)
    {
        DDStartDogArg * arg = [[DDStartDogArg alloc] init];
        arg.userId = user.content.id;
        arg.latitude = mCoordinate.latitude;
        arg.longitude = mCoordinate.longitude;
        
        [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"BaseAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
            if (bSuccess)
            {
                [btn setImage:[UIImage imageNamed:@"walkdog_switchend_n"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"walkdog_switchend_p"] forState:UIControlStateHighlighted];
                [MBProgressHUD ShowTips:@"遛狗开始" delayTime:2.0 atView:nil];
            }
            else
            {
                bDogWalk = NO;
            }
        }];
    }
    else
    {
        DDEndDogArg * arg = [[DDEndDogArg alloc] init];
        arg.userId = user.content.id;
        arg.latitude = mCoordinate.latitude;
        arg.longitude = mCoordinate.longitude;
        
        [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"BaseAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
            if (bSuccess)
            {
                [btn setImage:[UIImage imageNamed:@"walkdog_switch_n"] forState:UIControlStateNormal];
                [btn setImage:[UIImage imageNamed:@"walkdog_switch_p"] forState:UIControlStateHighlighted];
                [MBProgressHUD ShowTips:@"遛狗结束" delayTime:2.0 atView:nil];
            }
            else
            {
                bDogWalk = YES;
            }
        }];
    }
}

- (void)netRequestMap
{
    DDUserAck * ack = [[GlobData shareInstance] user];
    if (ack.content.id == 0 || !ack)
    {
        return;
    }
    DDAllCircleArg * arg = [[DDAllCircleArg alloc] init];
    arg.userId = ack.content.id;
    arg.longitude = self.mapView.centerCoordinate.longitude;
    arg.latitude = self.mapView.centerCoordinate.latitude;
    arg.distance = distance;
    
    [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"DDAllCircleAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
        if (bSuccess)
        {
            [self.annationViews removeAllObjects];
            DDAllCircleAck * ack = (DDAllCircleAck *)response;
            [self.annationViews addObjectsFromArray:ack.content];
            [self reloadMapView];
        }
    }];
}

- (void)reloadMapView
{
    for (DDAllCircleContent * content in self.annationViews)
    {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(content.latitude, content.longitude);
        
        BOOL bAdd = [self mapviewNeedAddNewAnnotation:content];
        
        if (bAdd)
        {
            [self addAnnotationWithCooordinate:coordinate withContent:content];
            if (content.isJoin)
            {
                [self addMACircleViewWithCenter:coordinate radius:200];
            }
        }
    }
}

- (BOOL)mapviewNeedAddNewAnnotation:(DDAllCircleContent *)content
{
    
    
    for (id obj in self.mapView.annotations) {
        
        if ([obj isKindOfClass:[DDCustomAnnotation class]])
        {
            
            DDCustomAnnotation * annotation = (DDCustomAnnotation *)obj;
            if (annotation.content.id == content.id)
            {
                if (![annotation.content isEqualContnet:content])
                {
                    [self.mapView removeAnnotation:annotation];
                    
                    for (DDUserAnnotation * userAnn in annotation.userAnnotations)
                    {
                        [self.mapView removeAnnotation:userAnn];
                    }
                    return YES;
                }
                else
                {
                    NSMutableArray * tmpArr = [[NSMutableArray alloc] init];
                    for (NSInteger i = 0; i < annotation.content.pet.count; i++)
                    {
                        DDAllCirclePet * pet = [annotation.content.pet objectAtIndex:i];
                        DDUserAnnotation * userAnn = [annotation.userAnnotations objectAtIndex:i];
                        
                        BOOL bExist = NO;
                        
                        for (NSInteger j = 0; j < content.pet.count ;j++)
                        {
                            DDAllCirclePet * tmpPet = [content.pet objectAtIndex:j];
                            if (tmpPet.id == pet.id)
                            {
                                bExist = YES;
                                if (tmpPet.latitude != pet.latitude || tmpPet.longitude != pet.longitude)
                                {
                                    DDCustomUserView * view = (DDCustomUserView *)[self.mapView viewForAnnotation:userAnn];
                                    userAnn.coordinate = CLLocationCoordinate2DMake(tmpPet.latitude,tmpPet.longitude);
                                    [view setAnnotation:userAnn];
                                }
                                
                                if (![tmpPet.header isEqualToString:pet.header])
                                {
                                    DDCustomUserView * view = (DDCustomUserView *)[self.mapView viewForAnnotation:userAnn];
                                    NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kPicBaseURL,tmpPet.header]];
                                    [view.bgImageView sd_setImageWithURL:url placeholderImage:nil];
                                }
                                
                                [tmpArr addObject:tmpPet];
                            }
                        }
                        if (!bExist)
                        {
                            [self.mapView removeAnnotation:userAnn];
                        }
                        
                    }
                    
                    for (DDAllCirclePet * existPet in tmpArr)
                    {
                        if (![content.pet containsObject:existPet])
                        {
                            DDUserAnnotation * userAnnotation = [[DDUserAnnotation alloc] init];
                            userAnnotation.coordinate = CLLocationCoordinate2DMake(existPet.latitude, existPet.longitude);
                            userAnnotation.userID = existPet.user.id;
                            userAnnotation.header = existPet.header;
                            [annotation.userAnnotations addObject:userAnnotation];
                            [self.mapView addAnnotation:userAnnotation];
                        }
                    }
                    
                    
                    
                    
                    return NO;
                }
                
            }
        }
    }
    
    return YES;
    
}

//- (DDAllCircleContent *)searchCircleDate:(CLLocationCoordinate2D)coordinate
//{
//    for (DDAllCircleContent * content in self.annationViews)
//    {
//        if (content.longitude == coordinate.longitude && content.latitude == coordinate.latitude)
//        {
//            return content;
//        }
//    }
//    return nil;
//}


- (IBAction)muemClick:(UIButton *)sender {
    [self.muemView showMenuWithAnimation:YES];
}

- (IBAction)messageClick:(UIButton *)sender {
    [self performSegueWithIdentifier:@"messageSegue" sender:nil];
}

-(void)addAnnotationWithCooordinate:(CLLocationCoordinate2D)coordinate withContent:(DDAllCircleContent *)content
{
    DDCustomAnnotation *annotation = [[DDCustomAnnotation alloc] init];
    annotation.coordinate = coordinate;
    annotation.content = content;
    [self.mapView addAnnotation:annotation];
    
    if (content.pet.count > 0)
    {
        for (int i = 0; i < content.pet.count; i++)
        {
            DDUserAnnotation * userAnnotation = [[DDUserAnnotation alloc] init];
            
            DDAllCirclePet * pet = [content.pet objectAtIndex:i];
            userAnnotation.coordinate = CLLocationCoordinate2DMake(pet.latitude, pet.longitude);
            userAnnotation.userID = pet.user.id;
            userAnnotation.header = pet.header;
            [annotation.userAnnotations addObject:userAnnotation];
            [self.mapView addAnnotation:userAnnotation];
        }
    }
    
}

- (void)addMACircleViewWithCenter:(CLLocationCoordinate2D)center radius:(double)radius
{
    MACircle *circle = [MACircle circleWithCenterCoordinate:center radius:radius];
    [self.mapView addOverlay:circle];
}

- (void)searchDogCircleInfoForVisiableMapView:(MAMapView *)mapView
{
    MAMapRect rect = mapView.visibleMapRect;
    MAMapPoint a = MAMapPointMake(rect.origin.x , rect.origin.y);
    MAMapPoint b = MAMapPointMake(rect.origin.x , rect.origin.y + rect.size.height);
    distance = MAMetersBetweenMapPoints(a, b)/ 2 / 1000;
    [self netRequestMap];
}

#pragma mark -
#pragma mark MAMapViewDelegate

- (void)reqUserAroundCircle
{
    [self searchDogCircleInfoForVisiableMapView:self.mapView];
}


-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
//        self.mapView.userTrackingMode = MAUserTrackingModeNone;
//        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
//        MACoordinateSpan span = MACoordinateSpanMake(0.05, 0.05);
//        MACoordinateRegion region = MACoordinateRegionMake(coordinate, span);
//        [mapView setRegion:region animated:YES];
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
        if (userLocation.coordinate.longitude != mCoordinate.longitude || userLocation.coordinate.latitude != mCoordinate.latitude) {
            if (bDogWalk)
            {
                [self uploadUserLoaction:userLocation.coordinate];
            }
        }
        mCoordinate = userLocation.coordinate;
        
        if (!timer)
        {
            timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(reqUserAroundCircle) userInfo:nil repeats:YES];
        }
        
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[DDCustomAnnotation class]])
    {
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        
        DDCustomAnnotationView *annotationView = (DDCustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[DDCustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            // must set to NO, so we can show the custom callout view.
            annotationView.canShowCallout = NO;
            
            
        }
        DDCustomAnnotation * ann = (DDCustomAnnotation *)annotation;
        if (ann.content.isJoin)
        {
            annotationView.bgImage = [UIImage imageNamed:@"domain_1"];
        }
        else
        {
            annotationView.bgImage = [UIImage imageNamed:@"domain_4"];
        }
        
        return annotationView;
    }
    else if ([annotation isKindOfClass:[DDUserAnnotation class]])
    {
        static NSString *userReuseIndetifier = @"userReuseIndetifier";
        
        DDCustomUserView *annotationView = (DDCustomUserView*)[mapView dequeueReusableAnnotationViewWithIdentifier:userReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[DDCustomUserView alloc] initWithAnnotation:annotation reuseIdentifier:userReuseIndetifier];
            annotationView.canShowCallout = NO;
            
        }
        DDUserAnnotation * ann = (DDUserAnnotation *)annotation;
        NSURL * url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",kPicBaseURL,ann.header]];
        [annotationView.bgImageView sd_setImageWithURL:url placeholderImage:nil];
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.showsAccuracyRing = NO;
        [self.mapView updateUserLocationRepresentation:pre];
    }
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:(MACircle *)overlay];
        circleRenderer.fillColor        = [UIColor colorWithRed:79/255.0f green:170.0/255.0f blue:216.0/255.0f alpha:0.3];
        return circleRenderer;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    
    [mapView deselectAnnotation:view.annotation animated:YES];
    
    if ([view isKindOfClass:[DDCustomAnnotationView class]])
    {
        DDCustomAnnotation * customAnnition =  (DDCustomAnnotation *)view.annotation;
        DDCircleDetailArg * arg = [[DDCircleDetailArg alloc] init];
        arg.circleId = customAnnition.content.id;
        arg.isJoin = customAnnition.content.isJoin;
        DDUserAck * ack = [[GlobData shareInstance] user];
        arg.userId = ack.content.id;
        
        bJoinCircle = customAnnition.content.isJoin;
        
        [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"DDCircleDetailAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
            if (bSuccess)
            {
                DDCircleDetailAck * ack = (DDCircleDetailAck *)response;
                [self performSegueWithIdentifier:@"mainCircleDetailSegue" sender:ack.content];
            }
        }];
    }
    else if ([view isKindOfClass:[DDCustomUserView class]])
    {
        DDUserAnnotation * userAnnition =  (DDUserAnnotation *)view.annotation;
        otherID = userAnnition.userID;
        [self performSegueWithIdentifier:@"goUserCenterSegue" sender:@"0"];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"mainCircleDetailSegue"])
    {
       DDMainCircleViewController * viewController = (DDMainCircleViewController *)segue.destinationViewController;
        DDCircleDetailContent * content = (DDCircleDetailContent *)sender;
        viewController.content = content;
        viewController.isJoin = bJoinCircle;
    }
    else if ([segue.identifier isEqualToString:@"muemPoliceWarnSegue"])
    {
        DDPoliceWarnListViewController * viewcontroller = (DDPoliceWarnListViewController *)segue.destinationViewController;
        viewcontroller.coordinate = mCoordinate;
    }
    else if ([segue.identifier isEqualToString:@"goUserCenterSegue"])
    {
        DDUserCenterViewController * viewcontroller = (DDUserCenterViewController *)segue.destinationViewController;
        
        BOOL isUser =[sender boolValue];
        viewcontroller.isUser = isUser;
        
        if (!isUser)
        {
            viewcontroller.otherID = otherID;
        }
    }
    else if ([segue.identifier isEqualToString:@"finishInfoSegue"])
    {
        DDUserInfoViewController * viewcontroller = (DDUserInfoViewController *)segue.destinationViewController;
        viewcontroller.bFromMianMap = YES;
        DDUserAck * ack = [[GlobData shareInstance] user];
        viewcontroller.userID = ack.content.id;
    }
}


#pragma mark -
#pragma mark MuemViewDelegate
- (void)selectMuemType:(MuemType)type
{
    [self.muemView hideMenuWithAnimation:NO];
    if (type == poisonousWarnning_Type)
    {
        [self performSegueWithIdentifier:@"bugWarnningSegue" sender:nil];
    }
    else if (type == setting_Type)
    {
        [self performSegueWithIdentifier:@"muemSettingSegue" sender:nil];
    }
    else if (type == dogLost_Type)
    {
        [self performSegueWithIdentifier:@"muemDogLostSegue" sender:nil];
    }
    else if (type == buildPart_Type)
    {
        [self performSegueWithIdentifier:@"muemBuildSiteSegue" sender:nil];
    }
    else
    {
        [self performSegueWithIdentifier:@"muemPoliceWarnSegue" sender:nil];
    }
}

- (void)goUserInfoAction
{
    [self.muemView hideMenuWithAnimation:NO];
    [self performSegueWithIdentifier:@"goUserCenterSegue" sender:@"1"];
}

- (void)goShopWebView
{
    [self.muemView hideMenuWithAnimation:NO];
    [self performSegueWithIdentifier:@"goShopSegue" sender:nil];
}

- (void)updateWalkType:(BOOL)bAuto
{
    dogBtn.hidden = !bAuto;
    if (dogBtn.hidden)
    {
        bDogWalk = NO;
        [dogBtn setImage:[UIImage imageNamed:@"walkdog_switch_n"] forState:UIControlStateNormal];
        [dogBtn setImage:[UIImage imageNamed:@"walkdog_switch_p"] forState:UIControlStateHighlighted];
    }
}

#pragma mark -
#pragma mark getter
- (DDMuemView *)muemView
{
    if (!_muemView)
    {
        _muemView = [[DDMuemView alloc] initWithFrame:CGRectMake(-self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _muemView.delegate = self;
        [self.view addSubview:_muemView];
    }
    [self.view bringSubviewToFront:_muemView];
    return _muemView;
}

- (NSMutableArray *)annationViews
{
    if (!_annationViews)
    {
        _annationViews = [[NSMutableArray alloc] init];
    }
    return _annationViews;
}


@end
