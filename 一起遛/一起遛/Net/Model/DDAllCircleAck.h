//
//  DDAllCircleAck.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/10.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "BaseAck.h"

@interface DDAllCircleUser : DDJSONModel

@property(nonatomic)NSInteger id;

@end


@protocol DDAllCirclePet <NSObject>

@end

@interface DDAllCirclePet : DDJSONModel

@property(nonatomic,copy)NSString * header;
@property(nonatomic)NSInteger id;
@property(nonatomic)NSInteger isFollow;
@property(nonatomic)double latitude;
@property(nonatomic)double longitude;
@property(nonatomic,copy)NSString * nick;
@property(nonatomic,strong)DDAllCircleUser * user;

@end


@protocol DDAllCircleContent <NSObject>
@end

@interface DDAllCircleContent : DDJSONModel

@property(nonatomic,copy)NSString * address;
@property(nonatomic)NSInteger id;
@property(nonatomic)NSInteger isJoin;
@property(nonatomic)double latitude;
@property(nonatomic)double longitude;
@property(nonatomic,copy)NSString * name;
@property(nonatomic)NSInteger petNum;
@property(nonatomic,strong)NSArray<DDAllCirclePet> * pet;
- (BOOL)isEqualContnet:(DDAllCircleContent *)content;

@end


@interface DDAllCircleAck : BaseAck

@property(nonatomic,strong)NSArray<DDAllCircleContent> * content;

@end
