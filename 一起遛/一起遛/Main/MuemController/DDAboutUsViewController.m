//
//  DDAboutUsViewController.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/30.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDAboutUsViewController.h"
#import "UIViewController+Customize.h"
#import "DDAboutUsCell.h"
@interface DDAboutUsViewController()<UITableViewDelegate,UITableViewDataSource>

@end


@implementation DDAboutUsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addDefaultLeftBarItem];
    self.title = @"关于我们";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 182.0;
    }
    return 48.0;
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0,0,0,0)];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0,0,0,0)];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDAboutUsCell * cell;
    if (indexPath.row == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DDAboutUsHeaderCellID"];
    }
    else
    {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DDAboutUsInfoCellID"];
        if (indexPath.row == 1)
        {
            cell.titleLabel.text = @"公司名称";
            cell.detailLabel.text = @"一起遛工作室";
        }
        else
        {
            cell.titleLabel.text = @"联系我们";
            cell.detailLabel.text = @"guqung6@gmail.com";
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
