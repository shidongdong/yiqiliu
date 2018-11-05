//
//  DDDogLostCell.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/31.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DDDogLostPicView.h"
#import "DDPlaceHolderTextView.h"
@protocol DDDogLostCellDelegate <NSObject>

- (void)updateLostDogSex:(NSInteger)sex;

- (void)updateNickName:(NSString *)name;

- (void)updatePhone:(NSString *)phone;

- (void)updateLostInfo:(NSString *)info;

@end

@interface DDDogLostCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UITextField * nameTextField;
@property(nonatomic,weak)IBOutlet UILabel * kindLabel;
@property(nonatomic,weak)IBOutlet UILabel * placeLabel;
@property(nonatomic,weak)IBOutlet UITextField * phoneTextField;
@property(nonatomic,weak)IBOutlet UILabel * timeLabel;
@property(nonatomic,weak)IBOutlet DDPlaceHolderTextView * contentTextField;
@property(nonatomic,weak)IBOutlet UIButton * manBtn;
@property(nonatomic,weak)IBOutlet UIButton * womanBtn;

@property(nonatomic,weak)IBOutlet UILabel * picNumLabel;

@property(nonatomic,weak)IBOutlet DDDogLostPicView * picView;

@property(nonatomic,weak)id<DDDogLostCellDelegate>delegate;

@end
