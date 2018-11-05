//
//  DDCircleCell.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/8.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseHeaderButton.h"
#import "BaseHeaderImageView.h"
@protocol DDCircleCellDelegate <NSObject>

- (void)showAllPetsAction;

@end


@interface DDCircleCell : UITableViewCell

@property(nonatomic,weak)IBOutlet BaseHeaderButton * headerView;
@property(nonatomic,weak)IBOutlet UILabel * headerNameLabel;
@property(nonatomic,weak)IBOutlet UILabel * placeLabel;

@property(nonatomic,weak)IBOutlet BaseHeaderImageView * memberHeaderImageView;
@property(nonatomic,weak)IBOutlet UIImageView * memberdogImageView;
@property(nonatomic,weak)IBOutlet UILabel * memberNameLabel;
@property(nonatomic,weak)IBOutlet UILabel * memberdogLabel;

@property(nonatomic,weak)IBOutlet UILabel * noticeLabel;
@property(nonatomic,weak)IBOutlet UILabel * noAddLabel;
@property(nonatomic,weak)IBOutlet UIView * noAddView;

@property(nonatomic,weak)id<DDCircleCellDelegate>delegate;

@end
