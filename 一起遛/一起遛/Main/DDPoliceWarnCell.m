//
//  DDPoliceWarnCell.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/2.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDPoliceWarnCell.h"
#import "Masonry.h"
#import "GlobConfig.h"
#import "UIColor+DDColor.h"
@implementation DDPoliceWarnCell

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (BaseHeaderImageView *)headerImageView
{
    
    if (!_headerImageView)
    {
        WS(weakSelf)
        _headerImageView = [[BaseHeaderImageView alloc] init];
        [self addSubview:_headerImageView];
        [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.mas_top).with.offset(18);
            make.left.equalTo(weakSelf.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(weakSelf.frame.size.width, self.frame.size.width));
        }];
    }
    return _headerImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        WS(weakSelf)
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14.0];
        _nameLabel.textColor = [UIColor text3Color];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(weakSelf.mas_bottom).with.offset(0);
            make.left.equalTo(weakSelf.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(weakSelf.frame.size.width, 20));
            
        }];
    }
    return _nameLabel;
}

- (UIImageView *)seletedImageView
{
    if (!_seletedImageView)
    {
        WS(weakSelf)
        _seletedImageView = [[UIImageView alloc] init];
        _seletedImageView.image = [UIImage imageNamed:@"circleSelected"];
        _seletedImageView.hidden = YES;
        [self addSubview:_seletedImageView];
        [_seletedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakSelf.headerImageView.mas_centerX);
            make.centerY.equalTo(weakSelf.headerImageView.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
    }
    return _seletedImageView;
}


@end
