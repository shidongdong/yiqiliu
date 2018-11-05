//
//  TKPicSelectTool.h
//  tracedemo
//
//  Created by 罗田佳 on 15/12/10.
//  Copyright © 2015年 trace. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol TKPicSelectDelegate <NSObject>

@optional
-(void)onImageSelect:(UIImage *)image;
-(void)onImagesSelect:(NSArray *)images;
-(void)onLoadingImage;

@end

@interface TKPicSelectTool : NSObject


@property (nonatomic,strong)NSString *  takePhotpTitle;
@property (nonatomic,strong)NSString *  chooseFromFileTitle;
@property (nonatomic,strong)NSString *  cancelTitle;
@property (nonatomic,weak) UIViewController * viewController;
@property (nonatomic,weak)id<TKPicSelectDelegate> selectDelegate;



/**
 选择图片
 **/
-(void)doSelectPic:(NSString * )titleTex clipping:(BOOL)clipping maxSelect:(NSInteger)max;


/**
 **/
-(void)onOneImageBack:(UIImage *)image;

/**
 多张图片选择Ok
 **/
-(void)onImageArrayBack:(NSArray *)images;

@end
