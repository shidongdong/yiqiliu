//
//  DDPetCircleAck.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/8.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "BaseAck.h"

@protocol DDPetCircleContent <NSObject>
@end

@interface DDPetCircleContent : DDJSONModel

@property(nonatomic,copy)NSString * address;
@property(nonatomic,copy)NSString * announcement;
@property(nonatomic)long createTime;
@property(nonatomic)NSInteger createUser;
@property(nonatomic)NSInteger distance;
@property(nonatomic)NSInteger id;
@property(nonatomic)double latitude;
@property(nonatomic)double longitude;
@property(nonatomic)long modifyTime;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * pic;
@property(nonatomic)NSInteger status;
@end

@interface DDPetCircleAck : BaseAck

@property(nonatomic,strong)NSArray<DDPetCircleContent> * content;

@end
