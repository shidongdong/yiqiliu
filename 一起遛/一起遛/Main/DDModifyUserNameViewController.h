//
//  DDModifyUserNameViewController.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/20.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDModifyUserNameViewControllerDelegate <NSObject>

- (void)updateUserName:(NSString *)name withUserSex:(NSInteger)sex;

@end

@interface DDModifyUserNameViewController : UIViewController

@property(nonatomic,weak)id<DDModifyUserNameViewControllerDelegate>delegate;
@property(nonatomic,copy)NSString * name;
@property(nonatomic)NSInteger sex;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
