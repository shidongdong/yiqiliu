//
//  DDDogKindAck.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/24.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "BaseAck.h"

@protocol DDDog <NSObject>

@end

@interface DDDog : DDJSONModel

@property(nonatomic)NSInteger id;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * shortName;

@end


@interface DDDogKindAck : BaseAck

@property(nonatomic,strong)NSArray<DDDog> * content;

@end
