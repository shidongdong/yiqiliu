//
//  DDDogLostMapViewController.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/7.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDMapView.h"
@interface DDDogLostMapViewController : UIViewController
{
    
}
@property (weak, nonatomic) IBOutlet UILabel *placeLabel;
@property (nonatomic)CLLocationCoordinate2D  mCoordinate;
@end
