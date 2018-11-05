//
//  DDCustomAnnotationView.m
//  一起遛
//
//  Created by 栋栋 施 on 16/8/24.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDCustomAnnotationView.h"

#define kWidth  40.f
#define kHeight 40.f

@interface DDCustomAnnotationView()
{
    
}
@property(nonatomic,strong)UIImageView * bgImageView;
@end

@implementation DDCustomAnnotationView

- (void)setBgImage:(UIImage *)bgImage
{
    self.bgImageView.image = bgImage;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    [super setSelected:selected animated:animated];
}

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    BOOL inside = [super pointInside:point withEvent:event];
//    /* Points that lie outside the receiver’s bounds are never reported as hits,
//     even if they actually lie within one of the receiver’s subviews.
//     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
//     */
//    if (!inside && self.selected)
//    {
//        inside = [self pointInside:[self convertPoint:point toView:self] withEvent:event];
//    }
//    
//    return inside;
//}

#pragma mark -
#pragma mark Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
        self.backgroundColor = [UIColor clearColor];
        
        
        self.bgImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.bgImageView];
        
    }
    return self;
}


@end
