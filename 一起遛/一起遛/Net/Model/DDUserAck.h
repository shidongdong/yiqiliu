//
//  DDLoginAck.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/22.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "BaseAck.h"

@interface DDPet : DDJSONModel

@property(nonatomic)NSInteger status;
@property(nonatomic,copy)NSString * header;
@property(nonatomic,copy)NSString * longitude;
@property(nonatomic,copy)NSString * latitude;
@property(nonatomic,copy)NSString * nick;
@property(nonatomic)NSInteger userId;
@property(nonatomic)NSInteger breedId;
@property(nonatomic,copy)NSString * breed;
@property(nonatomic)NSInteger createTime;
@property(nonatomic)NSInteger gender;
@property(nonatomic,copy)NSString * birthday;
@property(nonatomic)NSInteger modifyTime;
@property(nonatomic)NSInteger id;

@end

@interface DDUserContent : DDJSONModel

@property(nonatomic)NSInteger id;
@property(nonatomic)NSInteger status;
@property(nonatomic,copy)NSString * nick;
@property(nonatomic,copy)NSString * mobile;
@property(nonatomic)NSInteger gender;
@property(nonatomic)NSInteger walkType;
@property(nonatomic)NSInteger isComplete;
@property(nonatomic,strong)DDPet * pet;

@end


@interface DDUserAck : BaseAck

@property(nonatomic,strong)DDUserContent * content;

@end
