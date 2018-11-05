//
//  DDPickDateView.m
//  一起遛
//
//  Created by 栋栋 施 on 16/9/18.
//  Copyright © 2016年 栋栋 施. All rights reserved.
//

#import "DDPickDateView.h"
#import "UIColor+DDColor.h"
@interface DDPickDateView()
{
    UIDatePicker * datePicker;
}
@end


@implementation DDPickDateView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initUI];
    }
    return self;
}

- (void)pickerEvent:(UIButton *)button
{
    
    if (button.tag == 100)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(uploadBirthdayInfo:)])
        {
            [_delegate uploadBirthdayInfo:datePicker.date];
        }
    }
    else
    {
        [self hidePickView];
    }
}

- (void)showPickView
{
    self.hidden = NO;
}

- (void)hidePickView
{
    self.hidden = YES;
}

- (void)initUI
{
    datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 216, self.frame.size.width, 216)];
    datePicker.backgroundColor = [UIColor whiteColor];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker setDate:[NSDate date] animated:YES];
    [self addSubview:datePicker];
    
    
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, datePicker.frame.origin.y - 40, self.frame.size.width, 40)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    UIButton * cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(5, 5, 40, 30);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(pickerEvent:) forControlEvents:UIControlEventTouchUpInside];
    [cancel setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
    cancel.tag = 99;
    [bgView addSubview:cancel];
    
    
    UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake( (self.frame.size.width -100) / 2, 5, 100, 30)];
    title.text = @"时间";
    title.textAlignment =  NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:16.0];
    title.textColor = [UIColor textColor];
    [bgView addSubview:title];
    
    
    UIButton * finsih = [UIButton buttonWithType:UIButtonTypeCustom];
    finsih.frame = CGRectMake(self.frame.size.width - 45 , 5, 40, 30);
    [finsih setTitle:@"完成" forState:UIControlStateNormal];
    [finsih setTitleColor:[UIColor mainColor] forState:UIControlStateNormal];
    [finsih addTarget:self action:@selector(pickerEvent:) forControlEvents:UIControlEventTouchUpInside];
    finsih.tag = 100;
    [bgView addSubview:finsih];
}

@end
