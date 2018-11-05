//
//  DDModifyCircleArg.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/13.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "BaseArg.h"

@interface DDModifyCircleArg : BaseArg

@property(nonatomic)NSInteger userId;
@property(nonatomic)NSInteger id;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * announcement;
@property(nonatomic,copy)NSString * pic;

@end
