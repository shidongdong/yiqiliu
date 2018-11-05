//
//  DDBuildSiteArg.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/30.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "BaseArg.h"

@interface DDBuildSiteArg : BaseArg

@property(nonatomic)NSInteger userId;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * address;
@property(nonatomic,copy)NSString * pic;
@property(nonatomic)double longitude;
@property(nonatomic)double latitude;
@property(nonatomic,copy)NSString * announcement;
@property(nonatomic)NSInteger distance;

@end
