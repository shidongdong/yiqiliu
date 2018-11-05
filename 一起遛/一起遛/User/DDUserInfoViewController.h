//
//  DDUserInfoViewController.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/26.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDUserInfoViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic)NSInteger userID;
@property (nonatomic)BOOL  bFromMianMap;
@end
