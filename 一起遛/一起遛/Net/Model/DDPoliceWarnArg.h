//
//  DDPoliceWarnArg.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/5.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "BaseArg.h"

@interface DDPoliceWarnArg : BaseArg

@property(nonatomic)NSInteger userId;
@property(nonatomic)double longitude;
@property(nonatomic)double latitude;
@property(nonatomic)NSInteger circleId;

@end
