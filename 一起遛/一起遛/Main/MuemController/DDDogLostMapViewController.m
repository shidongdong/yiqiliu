//
//  DDDogLostMapViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/7.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDDogLostMapViewController.h"
#import "UIViewController+Customize.h"


@interface DDDogLostMapViewController()<DDMapViewDelegate>
{
    
}
@property(nonatomic,strong)DDMapView * mapView;

@end

@implementation DDDogLostMapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addDefaultLeftBarItem];
    self.title = @"选择位置";
    
    self.mapView = [[DDMapView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 128)];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

- (IBAction)buttonAction:(UIButton *)sender {
    [self performSegueWithIdentifier:@"unwindFromMapSegue" sender:nil];
}

- (void)reloadMapLocation:(CLLocationCoordinate2D)coordinate placeName:(NSString *)place
{
    self.placeLabel.text = place;
    self.mCoordinate = coordinate;
}

@end
