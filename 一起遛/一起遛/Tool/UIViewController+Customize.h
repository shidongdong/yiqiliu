//
//  UIViewController+Customize.h
//  GuanHealth
//
//  Created by hermit on 15/2/28.
//  Copyright (c) 2015年 wensihaihui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Customize)

- (void)addDefaultLeftBarItem;//默认返回按钮
- (void)addLeftBarItemWithTitle:(NSString*)title;//返回按钮－－文字
- (void)addLeftBarItemWithImageName:(NSString *)imageName highlightImageName:(NSString *)highlightImageName;//返回按钮－－图片
- (void)addLeftBarItemWithCustomView:(UIView *)view;//自定义左侧按钮
- (void)leftBarItemAction:(id)sender;//返回执行动作

- (void)addRightBarItemWithTitle:(NSString*)title;//右侧导航按钮－－文字

- (void)addRightBarItemWithTitle:(NSString*)title color:(UIColor *)color;//右侧导航栏按钮 文字 文字颜色

- (void)addRightBarItemWithImageName:(NSString *)imageName;//右侧导航按钮－－图片
- (void)addRightBarItemWithCustomView:(UIView *)view;//自定义右侧按钮
- (void)rightBarItemAction:(id)sender;//右侧按钮执行动作

- (void)addNavigationTitle:(NSString*)title;//导航title
- (void)setNavigationTitleView:(UIView *)titleView;//设置导航的titleView

@end
