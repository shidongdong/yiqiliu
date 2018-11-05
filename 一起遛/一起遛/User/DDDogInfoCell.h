//
//  DDDogInfoCell.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/24.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseHeaderButton.h"
@protocol DDDogInfoCellDelegate <NSObject>

@optional
- (void)updateDogSex:(NSInteger)sex;

- (void)updateDogName:(NSString *)name;

- (void)showPhonoTool;

@end


@interface DDDogInfoCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel * titleLabel;

@property(nonatomic,weak)IBOutlet UITextField * nameTextField;
@property(nonatomic,weak)IBOutlet UILabel * detailLabel;

@property(nonatomic,weak)IBOutlet UIButton * manBtn;
@property(nonatomic,weak)IBOutlet UIButton * womanBtn;

@property(nonatomic,weak)IBOutlet BaseHeaderButton * headerBtn;

@property(nonatomic,weak)id<DDDogInfoCellDelegate>delegate;

@end
