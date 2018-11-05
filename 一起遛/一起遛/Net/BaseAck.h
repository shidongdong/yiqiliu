//
//  BaseAck.h
//  一起遛
//
//  Created by 栋栋 施 on 16/8/22.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "DDJSONModel.h"
@interface BaseAck : DDJSONModel

@property(nonatomic)NSInteger state;
@property(nonatomic)NSString * content;

@end
