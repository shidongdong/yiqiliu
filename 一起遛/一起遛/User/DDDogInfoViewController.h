//
//  DDDogInfoViewController.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/24.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDDogInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic)NSInteger sex;
@property(nonatomic,copy)NSString * nickName;
@property(nonatomic)NSInteger userID;
@property(nonatomic)BOOL bFromMain;
@end
