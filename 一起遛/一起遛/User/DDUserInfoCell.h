//
//  DDUserInfoCell.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/26.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DDUserInfoCellDelegate <NSObject>

@optional
- (void)updateSex:(NSInteger)sex;

- (void)updateNickName:(NSString *)name;

@end

@interface DDUserInfoCell : UITableViewCell


@property(nonatomic,weak)IBOutlet UITextField * nickTextField;
@property(nonatomic,weak)IBOutlet UIButton * manBtn;
@property(nonatomic,weak)IBOutlet UIButton * womanBtn;

@property(nonatomic,weak)id<DDUserInfoCellDelegate>delegate;

@end
