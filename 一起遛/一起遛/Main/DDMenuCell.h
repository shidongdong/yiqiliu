//
//  DDMenuCell.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/24.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDMuem : NSObject

@property(nonatomic,strong)NSString * text;
@property(nonatomic,strong)UIImage * image;

@end

@protocol DDMenuCellDelegate <NSObject>

- (void)updateDogWalkState:(BOOL)state;

@end

@interface DDMenuCell : UITableViewCell

@property(nonatomic,weak)id<DDMenuCellDelegate>delegate;
- (void)setContent:(DDMuem *)data;

- (void)clearContent;

- (void)setShopContent;

- (void)setDogWalkType:(BOOL)bSelected;
@end
