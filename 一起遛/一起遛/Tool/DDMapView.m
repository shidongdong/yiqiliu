//
//  DDMapView.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/7.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDMapView.h"


static NSString * customReuseIndetifier = @"DDMapCellId";

@interface DDMapView()<MAMapViewDelegate,AMapSearchDelegate>
{
    CLLocationCoordinate2D placeCoordinate;
}
@property(nonatomic,strong)MAMapView * mapView;
@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation DDMapView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.mapView = [[MAMapView alloc] initWithFrame:self.bounds];
        ///把地图添加至view
        self.mapView.delegate  = self;
        self.mapView.showsUserLocation = YES;
        self.mapView.userTrackingMode = MAUserTrackingModeNone;
        self.mapView.showsCompass = NO;
        self.mapView.showsScale = NO;
        [self addSubview:self.mapView];
        
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 31, 39)];
        imageView.image = [UIImage imageNamed:@"site"];
        imageView.center = CGPointMake(self.mapView.frame.size.width / 2, self.mapView.frame.size.height / 2 - 20);
        [self.mapView addSubview:imageView];
    }
    return self;
}

#pragma mark -
#pragma mark Map

-(void)addAnnotationWithCooordinate:(CLLocationCoordinate2D)coordinate
{
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = self.mapView.centerCoordinate;
    [self.mapView addAnnotation:annotation];
}

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation)
    {
        self.mapView.showsUserLocation = NO;
        
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude);
        MACoordinateSpan span = MACoordinateSpanMake(0.05, 0.05);
        MACoordinateRegion region = MACoordinateRegionMake(coordinate, span);
        [mapView setRegion:region animated:YES];
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        
      //  [self addAnnotationWithCooordinate:coordinate];
      //  [self searchReGeocodeWithCoordinate:coordinate];
    }
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        MAAnnotationView *annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            // must set to NO, so we can show the custom callout view.
        }
        annotationView.image = [UIImage imageNamed:@"site"];
        //        [annotationView.annotation setCoordinate:mapView.centerCoordinate];
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    placeCoordinate = mapView.centerCoordinate;
    [self searchReGeocodeWithCoordinate:placeCoordinate];
}

- (void)searchReGeocodeWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location                    = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.requireExtension            = YES;
    [self.search AMapReGoecodeSearch:regeo];
}

/* 逆地理编码回调. */
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if (_delegate && [_delegate respondsToSelector:@selector(reloadMapLocation:placeName:)])
    {
        [_delegate reloadMapLocation:placeCoordinate placeName:response.regeocode.formattedAddress];
    }
}

#pragma mark -
#pragma mark getter
- (AMapSearchAPI *)search
{
    if (!_search)
    {
        _search = [[AMapSearchAPI alloc] init];
        _search.delegate = self;
    }
    return _search;
}

@end

