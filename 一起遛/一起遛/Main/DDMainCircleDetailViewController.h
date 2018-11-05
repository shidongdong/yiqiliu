//
//  DDMainCircleDetailViewController.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/8.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDCircleDetailAck.h"
@interface DDMainCircleDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property(nonatomic,strong)DDCircleDetailContent * content;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic)BOOL bJoin;

@end
