//
//  DDModifyUserNameCell.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/20.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDModifyUserNameCellDelegate <NSObject>

- (void)updateUserName:(NSString *)name;

- (void)updateUserSex:(NSInteger)sex;

@end

@interface DDModifyUserNameCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UITextField * textField;
@property(nonatomic,weak)IBOutlet UIButton * manBtn;
@property(nonatomic,weak)IBOutlet UIButton * womanBtn;

@property(nonatomic , weak)id<DDModifyUserNameCellDelegate>delegate;

@end
