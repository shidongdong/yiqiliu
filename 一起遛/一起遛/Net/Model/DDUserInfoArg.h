//
//  BaseUserInfoArg.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/22.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "BaseArg.h"
//完善用户信息
@interface DDUserInfoArg : BaseArg

@property(nonatomic)NSInteger userId;
@property(nonatomic,copy)NSString * userNick;
@property(nonatomic)NSInteger userGender;
@property(nonatomic,copy)NSString * petNick;
@property(nonatomic,copy)NSString * petHeader;
@property(nonatomic)NSInteger petGender;
@property(nonatomic)NSInteger petBreadId;
@property(nonatomic,copy)NSString * petBreed;
@property(nonatomic)long petBirthday;

@end
