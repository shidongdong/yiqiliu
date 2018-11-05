//
//  DDUnfollowArg.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/22.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "BaseArg.h"

@interface DDUnfollowArg : BaseArg

@property(nonatomic)NSInteger userId;
@property(nonatomic)NSInteger otherId;
@property(nonatomic,copy)NSString * userNick;
@property(nonatomic)NSInteger userGender;

@end
