//
//  DDLogoutArg.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/7.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "BaseArg.h"

@interface DDLogoutArg : BaseArg

@property(nonatomic)NSInteger userId;
@property(nonatomic)NSInteger deviceType;
@property(nonatomic,copy)NSString * dvc;
@end
