//
//  DDDBCenter.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/26.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DDMessage.h"


@interface DDDBCenter : NSObject

+ (instancetype)shareInstance;

- (NSArray *)getDDMessageList;

- (void)addDDMessage:(DDMessage *)message;

- (void)deleteDDMessage:(DDMessage *)message;

@end
