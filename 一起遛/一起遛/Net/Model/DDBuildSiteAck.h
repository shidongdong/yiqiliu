//
//  DDBuildSiteAck.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/20.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "BaseAck.h"

@interface DDBuildSiteContent : DDJSONModel

@property(nonatomic,copy)NSString * address;
@property(nonatomic,copy)NSString * announcement;
@property(nonatomic)long createDate;
@property(nonatomic)long createTime;
@property(nonatomic)NSInteger createUser;
@property(nonatomic)float distance;
@property(nonatomic)NSInteger id;
@property(nonatomic)long latitude;
@property(nonatomic)long longitude;
@property(nonatomic)long modifyTime;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * pic;
@property(nonatomic)NSInteger status;
@property(nonatomic)NSInteger totalDogNum;
@property(nonatomic,copy)NSString * userMobile;
@property(nonatomic,copy)NSString * userName;
@property(nonatomic)NSInteger walkDogNum;

@end

@interface DDBuildSiteAck : BaseAck

@property(nonatomic,strong)DDBuildSiteContent *content;

@end
