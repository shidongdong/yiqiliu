//
//  DDMapView.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/7.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@protocol DDMapViewDelegate <NSObject>

@optional
- (void)reloadMapLocation:(CLLocationCoordinate2D)coordinate placeName:(NSString *)place;

@end


@interface DDMapView : UIView

@property(nonatomic,weak)id<DDMapViewDelegate>delegate;

@end
