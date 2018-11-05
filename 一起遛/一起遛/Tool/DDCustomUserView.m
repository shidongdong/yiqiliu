//
//  DDCustomUserView.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/22.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDCustomUserView.h"
#import "UIColor+DDColor.h"
#define  kUserWidth  33.0
#define  kUserHeight 33.0

@interface DDCustomUserView()



@end

@implementation DDCustomUserView


- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, kUserWidth, kUserHeight);
        self.backgroundColor = [UIColor clearColor];
        self.layer.cornerRadius = kUserWidth / 2;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor mainColor].CGColor;
        self.clipsToBounds = YES;
        
        self.bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.bgImageView.layer.cornerRadius = kUserWidth / 2;
        [self addSubview:self.bgImageView];
        
    }
    return self;
}

@end
