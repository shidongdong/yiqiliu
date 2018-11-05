//
//  DDPoliceWarnListViewController.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/2.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
@interface DDPoliceWarnListViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (nonatomic)CLLocationCoordinate2D coordinate;

@end
