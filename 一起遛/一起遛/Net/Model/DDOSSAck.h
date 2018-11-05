//
//  DDOSSAck.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/8.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "BaseAck.h"

@interface DDOSSContent : DDJSONModel

@property(nonatomic,copy)NSString * accessKeyId;
@property(nonatomic,copy)NSString * accessKeySecret;
@property(nonatomic,copy)NSString * ossHost;
@property(nonatomic,copy)NSString * bucketName;

@end


@interface DDOSSAck : BaseAck

@property(nonatomic,strong)DDOSSContent * content;

@end
