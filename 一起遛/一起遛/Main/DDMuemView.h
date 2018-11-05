//
//  DDMuemView.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/24.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger , MuemType) {
    poisonousWarnning_Type = 0,
    policeWarnning_Type,
    buildPart_Type,
    dogLost_Type,
    autoDog_Type,
    setting_Type,
};

@protocol DDMuemViewDelegate <NSObject>

- (void)selectMuemType:(MuemType)type;

- (void)goUserInfoAction;

- (void)goShopWebView;

- (void)updateWalkType:(BOOL)bAuto;

@end


@interface DDMuemView : UIView

@property(nonatomic,weak)id<DDMuemViewDelegate>delegate;

- (void)showMenuWithAnimation:(BOOL)bAnimation;

- (void)hideMenuWithAnimation:(BOOL)bAnimation;

- (void)setContentWithHeaderURL:(NSURL *)url withNickName:(NSString *)name  withDogState:(NSInteger)state;

@end
