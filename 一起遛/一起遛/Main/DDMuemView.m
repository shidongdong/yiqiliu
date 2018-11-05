//
//  DDMuemView.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/24.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDMuemView.h"
#import "DDMenuCell.h"
#import "GlobConfig.h"
#import "UIColor+DDColor.h"
#import "UIButton+WebCache.h"
#import "BaseHeaderButton.h"
#import "DDHTTPClient.h"
#import "DDSetWalkTypeArg.h"
#import "DDUserAck.h"
#import "GlobData.h"
#import "Masonry.h"
#import "GlobConfig.h"
static NSString * ddMuenCellID = @"ddMuenCellID";

@interface DDMuemView()<UITableViewDelegate,UITableViewDataSource,DDMenuCellDelegate>
{
    NSInteger walkType;
}
@property(nonatomic,strong)UIView * meunView;
@property(nonatomic,strong)UITableView * tableView;
@property(nonatomic,strong)BaseHeaderButton * headerButton;
@property(nonatomic,strong)UILabel * nameLabel;
@property(nonatomic,strong)NSMutableArray * muemDatas;
@end

@implementation DDMuemView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton * bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        bgBtn.frame = self.bounds;
        [bgBtn setBackgroundColor:[UIColor clearColor]];
        [bgBtn addTarget:self action:@selector(tapClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:bgBtn];
    }
    return self;
}


- (void)setContentWithHeaderURL:(NSURL *)url withNickName:(NSString *)name  withDogState:(NSInteger)state
{
    [self.headerButton sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"default-avatar"]];
    self.nameLabel.text = name;
    walkType = state;
    [self.tableView reloadData];
    
}

- (void)tapClick
{
    [self hideMenuWithAnimation:YES];
}

- (void)showMenuWithAnimation:(BOOL)bAnimation
{
    if (bAnimation)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        }];
    }
    else
    {
        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
}

- (void)hideMenuWithAnimation:(BOOL)bAnimation
{
    if (bAnimation)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
        }];
    }
    else
    {
        self.frame = CGRectMake(-self.frame.size.width, 0, self.frame.size.width, self.frame.size.height);
    }
}

#pragma mark -
#pragma mark UITableViewDelegate && UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    return 6;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 55.0;
    }
    return 45.0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDMenuCell * cell = [tableView dequeueReusableCellWithIdentifier:ddMuenCellID];
    cell.backgroundColor = [UIColor clearColor];
    [cell clearContent];
    if (indexPath.section == 0)
    {
        [cell setShopContent];
    }
    else
    {
        DDMuem * muem = [self.muemDatas objectAtIndex:indexPath.row];
        [cell setContent:muem];
        
        if (indexPath.row == 4)
        {
            [cell setDogWalkType:walkType == 2 ? YES : NO];
            cell.delegate = self;
            cell.selectionStyle =  UITableViewCellSelectionStyleNone;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(goShopWebView)])
        {
            [_delegate goShopWebView];
        }
    }
    else
    {
        if (indexPath.row == 4)
        {
            return;
        }
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        if (_delegate && [_delegate respondsToSelector:@selector(selectMuemType:)])
        {
            [_delegate selectMuemType:(MuemType)indexPath.row];
        }
    }
    
}

- (void)updateDogWalkState:(BOOL)state
{
    DDSetWalkTypeArg * arg = [[DDSetWalkTypeArg alloc] init];
    DDUserAck * user = [[GlobData shareInstance] user];
    arg.userId = user.content.id;
    if (state)
    {
        arg.walkType = 2;
    }
    else
    {
        arg.walkType = 1;
    }
    
    [[DDHTTPClient shareInstance] beginHttpRequest:arg parse:@"BaseAck" completion:^(BOOL bSuccess, BaseAck *response, NSString *error) {
        if (!bSuccess)
        {
            DDMenuCell * cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
            [cell setDogWalkType:!state];
        }
        else
        {
            if (_delegate && [_delegate respondsToSelector:@selector(updateWalkType:)])
            {
                [_delegate updateWalkType:state];
            }
        }
    }];
}

- (void)headerClick
{
    if (_delegate && [_delegate respondsToSelector:@selector(goUserInfoAction)])
    {
        [_delegate goUserInfoAction];
    }
}

#pragma mark -
#pragma mark getter

- (UITableView *)tableView
{
    if (!_tableView)
    {
        CGFloat height;
        if (325 + self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 80 + 40 > [[UIScreen mainScreen] bounds].size.height)
        {
            height = [[UIScreen mainScreen] bounds].size.height - (self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 80 + 40) ;
        }
        else
        {
            height = 325;
        }
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.nameLabel.frame.origin.y + self.nameLabel.frame.size.height + 80, self.meunView.frame.size.width,height ) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[DDMenuCell class] forCellReuseIdentifier:ddMuenCellID];
        [self.meunView addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)meunView
{
    if (!_meunView)
    {
        _meunView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280 , self.frame.size.height)];
        _meunView.backgroundColor = [UIColor mainColor];
        [self addSubview:_meunView];
    }
    return _meunView;
}

- (BaseHeaderButton *)headerButton
{
    if (!_headerButton)
    {
        _headerButton = [BaseHeaderButton buttonWithType:UIButtonTypeCustom];
        _headerButton.frame = CGRectMake((self.meunView.frame.size.width - 94) / 2, 50, 94, 94);
        _headerButton.imageView.layer.borderColor = [UIColor imageborderColor].CGColor;
        _headerButton.imageView.layer.borderWidth = 2.0;
        [_headerButton addTarget:self action:@selector(headerClick) forControlEvents:UIControlEventTouchUpInside];
        [self.meunView addSubview:_headerButton];
    }
    return _headerButton;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.meunView.frame.size.width - 200) / 2, self.headerButton.frame.origin.y + self.headerButton.frame.size.height + 18, 200, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:18.0];
        _nameLabel.textColor = [UIColor  whiteColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.meunView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (NSMutableArray *)muemDatas
{
    if (!_muemDatas)
    {
        //准备原始数据
        _muemDatas = [[NSMutableArray alloc] init];
        DDMuem * muem1 = [[DDMuem alloc] init];
        muem1.image = IMG(@"bug");
        muem1.text = @"有毒报警";
        [_muemDatas addObject:muem1];
        
        DDMuem * muem2 = [[DDMuem alloc] init];
        muem2.image = IMG(@"alarm");
        muem2.text = @"城管报警";
        [_muemDatas addObject:muem2];
        
        DDMuem * muem3 = [[DDMuem alloc] init];
        muem3.image = IMG(@"building-site");
        muem3.text = @"建立地盘";
        [_muemDatas addObject:muem3];
        
        DDMuem * muem4 = [[DDMuem alloc] init];
        muem4.image = IMG(@"lost");
        muem4.text = @"狗狗走失";
        [_muemDatas addObject:muem4];
        
        DDMuem * muem5 = [[DDMuem alloc] init];
        muem5.image = IMG(@"hand");
        muem5.text = @"手动遛狗";
        [_muemDatas addObject:muem5];
        
        DDMuem * muem6 = [[DDMuem alloc] init];
        muem6.image = IMG(@"setting");
        muem6.text = @"设      置";
        [_muemDatas addObject:muem6];
        
    }
    return _muemDatas;
}

@end
