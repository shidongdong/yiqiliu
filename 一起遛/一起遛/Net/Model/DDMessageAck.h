//
//  DDMessageAck.h
//  一起遛
//
//  Created by 栋栋 施 on 16/9/28.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "BaseAck.h"

@protocol DDMessageContent <NSObject>

@end

@interface DDMessageContent : DDJSONModel

@property(nonatomic,copy)NSString * cid;
@property(nonatomic,copy)NSString * content;
@property(nonatomic)long createTime;
@property(nonatomic,copy)NSString * header;
@property(nonatomic)NSInteger id;
@property(nonatomic)NSInteger type;
@property(nonatomic,copy)NSString * url;

@end


@interface DDMessageAck : BaseAck

@property(nonatomic,strong)NSArray<DDMessageContent> * content;

@end
