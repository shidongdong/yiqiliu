//
//  DDUserPageAck.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/19.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "BaseAck.h"

@interface DDUserPagePet : DDJSONModel

@property(nonatomic)long birthday;
@property(nonatomic,copy)NSString * breed;
@property(nonatomic)NSInteger breedId;
@property(nonatomic)NSInteger gender;
@property(nonatomic,copy)NSString * header;
@property(nonatomic)NSInteger id;
@property(nonatomic,copy)NSString * nick;
@property(nonatomic)NSInteger petAge;
@property(nonatomic)NSInteger status;
@end


@interface DDUserPageContent : DDJSONModel

@property(nonatomic)NSInteger gender;
@property(nonatomic)NSInteger id;
@property(nonatomic)NSInteger isAttention;
@property(nonatomic)NSInteger isComplete;
@property(nonatomic,copy)NSString * mobile;
@property(nonatomic,copy)NSString * nick;
@property(nonatomic,strong)DDUserPagePet * pet;
@property(nonatomic)NSInteger status;
@property(nonatomic)NSInteger walkType;

@end


@interface DDUserPageAck : BaseAck

@property(nonatomic,strong)DDUserPageContent * content;

@end
