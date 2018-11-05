//
//  DDMainCirclePetListViewController.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/8.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDMainCirclePetListViewController : UIViewController

@property(nonatomic)NSInteger circleID;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
