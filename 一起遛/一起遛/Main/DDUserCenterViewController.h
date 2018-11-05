//
//  DDUserCenterViewController.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/18.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDUserCenterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic)BOOL isUser;  //是否是用户
@property(nonatomic)NSInteger otherID;
@end
