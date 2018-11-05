//
//  DDUserCenterCell.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/18.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseHeaderButton.h"

@protocol DDUserCenterCellDelegate <NSObject>

- (void)headerBtnAction;

- (void)followBtnAction:(UIButton *)btn;

- (void)updateDogSex:(NSInteger)sex;

@end

@interface DDUserCenterCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UILabel * titleLabel;
@property(nonatomic,weak)IBOutlet UILabel * detailLabel;
@property(nonatomic,weak)IBOutlet UILabel * nameLabel;

@property(nonatomic,weak)IBOutlet BaseHeaderButton * headerBtn;
@property(nonatomic,weak)IBOutlet UIButton * followBtn;
@property(nonatomic,weak)IBOutlet UIImageView * sexImageView;

@property(nonatomic,weak)IBOutlet UIButton * manBtn;
@property(nonatomic,weak)IBOutlet UIButton * womanBtn;

@property(nonatomic,weak)id<DDUserCenterCellDelegate> delegate;

@end
