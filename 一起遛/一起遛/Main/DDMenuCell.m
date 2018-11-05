//
//  DDMenuCell.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/24.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDMenuCell.h"
#import "Masonry.h"
#import "GlobConfig.h"
#import "UIColor+DDColor.h"
@implementation DDMuem

@end


@interface DDMenuCell()

@property(nonatomic,strong)UIImageView * titleImageView;
@property(nonatomic,strong)UIImageView * shopImageView;
@property(nonatomic,strong)UILabel * titleLabel;
@property(nonatomic,strong)UIButton * dogStateButton;
@end

@implementation DDMenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    return self;
}

- (void)setContent:(DDMuem *)data
{
    self.titleImageView.image = data.image;
    self.titleLabel.text = data.text;
}

- (void)setShopContent
{
    self.shopImageView.image = [UIImage imageNamed:@"shop"];
    self.titleLabel.text = @"狗狗商城";
}

- (void)clearContent
{
    self.shopImageView.image = nil;
    self.titleImageView.image = nil;
    self.dogStateButton.hidden = YES;
}

- (void)setDogWalkType:(BOOL)bSelected
{
    self.dogStateButton.hidden = NO;
    self.dogStateButton.selected = bSelected;
}

- (void)switchDogWalkType:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (_delegate && [_delegate respondsToSelector:@selector(updateDogWalkState:)])
    {
        [_delegate updateDogWalkState:btn.selected];
    }
}

#pragma mark -
#pragma mark getter
- (UIImageView *)titleImageView
{
    if (!_titleImageView)
    {
        WS(weakSelf)
        _titleImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_titleImageView];
        [_titleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(13, 20));
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
            make.left.equalTo(weakSelf.contentView.mas_left).with.offset(68);
        }];
    }
    return _titleImageView;
}

- (UIImageView *)shopImageView
{
    if (!_shopImageView)
    {
        WS(weakSelf)
        _shopImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_shopImageView];
        [_shopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(25, 25));
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
            make.left.equalTo(weakSelf.contentView.mas_left).with.offset(65);
        }];
    }
    return _shopImageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        WS(weakSelf)
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf.titleImageView.mas_right).with.offset(27);
            make.centerY.equalTo(weakSelf.contentView.mas_centerY);
            make.right.equalTo(weakSelf.contentView.mas_right).with.offset(-80);
            make.height.mas_equalTo(30);
        }];
    }
    return _titleLabel;
}

- (UIButton *)dogStateButton
{
    if (!_dogStateButton)
    {
        WS(weakSelf)
        _dogStateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_dogStateButton setImage:[UIImage imageNamed:@"off"] forState:UIControlStateNormal];
        [_dogStateButton setImage:[UIImage imageNamed:@"on"] forState:UIControlStateSelected];
        [_dogStateButton addTarget:self action:@selector(switchDogWalkType:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_dogStateButton];
        [_dogStateButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(27, 19));
            make.left.equalTo(weakSelf.titleLabel.mas_right).with.offset(20);
            make.centerY.equalTo(weakSelf.contentView.mas_centerY).with.offset(5);
        }];
    }
    return _dogStateButton;
}


@end
