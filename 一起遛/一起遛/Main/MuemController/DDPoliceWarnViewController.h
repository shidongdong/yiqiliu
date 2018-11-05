//
//  DDPoliceWarnViewController.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/30.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDPetCircleAck.h"
#import <MAMapKit/MAMapKit.h>
@interface DDPoliceWarnViewController : UIViewController

@property(nonatomic,strong)NSString * name;
@property(nonatomic)DDPetCircleContent * content;
@property(nonatomic)CLLocationCoordinate2D coordinate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
