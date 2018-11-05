//
//  DDAppealDogLostArg.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/22.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "BaseArg.h"

@interface DDAppealDogLostArg : BaseArg

@property(nonatomic)NSInteger userId;
@property(nonatomic,copy)NSString * pic1;
@property(nonatomic,copy)NSString * pic2;
@property(nonatomic,copy)NSString * pic3;
@property(nonatomic,copy)NSString * nick;
@property(nonatomic)NSInteger breedId;
@property(nonatomic)NSInteger gender;
@property(nonatomic,copy)NSString * lostArea;
@property(nonatomic)NSInteger lostTime;
@property(nonatomic,copy)NSString * contactPhone;
@property(nonatomic)double longitude;
@property(nonatomic)double  latitude;
@property(nonatomic,copy)NSString * remark;
@end
