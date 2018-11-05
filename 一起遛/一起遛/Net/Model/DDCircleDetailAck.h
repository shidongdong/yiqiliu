//
//  DDCircleDetailAck.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/12.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "BaseAck.h"

@interface DDCircleDetailDataUser : DDJSONModel

@property(nonatomic)NSInteger gender;
@property(nonatomic)NSInteger id;
@property(nonatomic,copy)NSString * mobile;
@property(nonatomic,copy)NSString * nick;
@end


@protocol DDCircleDetailData <NSObject>

@end

@interface DDCircleDetailData : DDJSONModel

@property(nonatomic,copy)NSString * breed;
@property(nonatomic)NSInteger breedId;
@property(nonatomic)NSInteger dogStatus;
@property(nonatomic)NSInteger gender;
@property(nonatomic,copy)NSString * header;
@property(nonatomic)NSInteger id;
@property(nonatomic,copy)NSString * nick;
@property(nonatomic,strong)DDCircleDetailDataUser * user;

@end


@interface DDCircleDetailContent : DDJSONModel

@property(nonatomic,copy)NSString * address;
@property(nonatomic,copy)NSString * announcement;
@property(nonatomic)long createDate;
@property(nonatomic,copy)NSString * createUser;
@property(nonatomic)NSInteger id;
@property(nonatomic)NSInteger isCreateUser;
@property(nonatomic,copy)NSString * name;
@property(nonatomic)NSInteger petNum;
@property(nonatomic,copy)NSString * pic;
@property(nonatomic,strong)NSArray<DDCircleDetailData> * data;
@end


@interface DDCircleDetailAck : BaseAck

@property(nonatomic,strong)DDCircleDetailContent * content;

@end
