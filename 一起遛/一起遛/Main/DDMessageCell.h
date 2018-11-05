//
//  DDMessageCell.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/5.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseHeaderImageView.h"
@interface DDMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet BaseHeaderImageView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end
