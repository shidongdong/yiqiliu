//
//  DDCircleDetailCell.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/8.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseHeaderButton.h"

@protocol DDCircleDetailCellDelegate <NSObject>

- (void)showPicTool;

@end

@interface DDCircleDetailCell : UITableViewCell

@property(nonatomic,weak)IBOutlet BaseHeaderButton * headerBtn;
@property(nonatomic,weak)IBOutlet UILabel * nameLabel;
@property(nonatomic,weak)IBOutlet UILabel * detailLabel;

@property(nonatomic,weak)id<DDCircleDetailCellDelegate>delegate;

@end
