//
//  DDPoliceWarnCell.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/2.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseHeaderImageView.h"
@interface DDPoliceWarnCell : UICollectionViewCell

@property (strong, nonatomic) BaseHeaderImageView *headerImageView;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIImageView *seletedImageView;

@end
