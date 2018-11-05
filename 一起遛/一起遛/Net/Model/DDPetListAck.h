//
//  DDPetListAck.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/13.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "BaseAck.h"
#import "DDCircleDetailAck.h"

@interface DDPetListAck : BaseAck

@property(nonatomic,strong)NSArray<DDCircleDetailData> * content;

@end
