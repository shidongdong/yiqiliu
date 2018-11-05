//
//  TKPicSelectTool.m
//  tracedemo
//
//  Created by 罗田佳 on 15/12/10.
//  Copyright © 2015年 trace. All rights reserved.
//

#import "TKPicSelectTool.h"
#import "ZYQAssetPickerController.h"
#import "VPImageCropperViewController.h"
#import "GlobConfig.h"
#import "UIColor+DDColor.h"
@interface TKPicSelectTool()<ZYQAssetPickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,VPImageCropperDelegate>

@property (nonatomic ,assign) NSInteger selectMax; // 最大的选择数

@property (nonatomic ,assign) BOOL clipping;// 是否剪裁

@end

@implementation TKPicSelectTool




-(instancetype)init
{
    self = [super init];
    self.takePhotpTitle = @"拍照";
    self.cancelTitle = @"取消";
    self.chooseFromFileTitle = @"相册";
    return self;
}


/**
 选择图片
 **/
-(void)doSelectPic:(NSString * )titleTex clipping:(BOOL)clipping maxSelect:(NSInteger)max{
    
    _clipping = clipping;
    _selectMax = max;
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:titleTex delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [sheet addButtonWithTitle:_takePhotpTitle];
    }
    [sheet addButtonWithTitle:_chooseFromFileTitle];
    [sheet setCancelButtonIndex:[sheet addButtonWithTitle:_cancelTitle]];
    [sheet showInView:self.viewController.view];
    
}


/**
 从自定义相册选择多张图片
 **/
-(void)chooseArrayFromPhotoLibary{
    
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
    [[picker navigationBar]setTintColor:[UIColor mainColor]];
    picker.maximumNumberOfSelection = _selectMax;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups=NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
        {
            NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
            return duration >= 5;
        } else {
            return YES;
        }
    }];
    [self.viewController presentViewController:picker animated:YES completion:NULL];
}

/**
 从系统相册选择一张图片
 **/
- (void)chooseOneFormPhotoLibrary
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self.viewController presentViewController:imagePicker animated:YES completion:nil];
}

/**
 
 一张图片选择完成 需要根据情况判定是否需要 剪裁
 **/

-(void)onOneImageSelect:(UIImage *)image{
    
    if(_clipping){
        UIView * rootView = self.viewController.view;
        VPImageCropperViewController *imgEditorVC = [[VPImageCropperViewController alloc] initWithImage:[self fixOrientation:image] cropFrame:CGRectMake(0, 100.0f, rootView.frame.size.width, rootView.frame.size.width) limitScaleRatio:3.0];
        imgEditorVC.delegate = self;
        [self.viewController presentViewController:imgEditorVC animated:YES completion:^{}];
    }else{
        [self onOneImageBack:image];
    }
}

/**
 **/
-(void)onOneImageBack:(UIImage *)image{
    if(self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(onImageSelect:)])
    {
        [self.selectDelegate onImageSelect:image];
    }
}

/**
 多张图片选择耗时加载
 **/
-(void)onLoadingImage
{
    if(self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(onLoadingImage)])
    {
        [self.selectDelegate onLoadingImage];
    }
}

/**
 多张图片选择Ok
 **/

-(void)onImageArrayBack:(NSArray *)images{
    
    if(self.selectDelegate && [self.selectDelegate respondsToSelector:@selector(onImagesSelect:)])
    {
        [self.selectDelegate onImagesSelect:images];
    }
}



#pragma mark -
#pragma mark UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BOOL camera = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
    
    if(!camera){
        
        buttonIndex = buttonIndex +1;
    }
    if(buttonIndex == 0)
    {
        [self chooseFromCamera];
    }
    else if(buttonIndex == 1)
    {
        [self chooseArrayFromPhotoLibary];
    }
}

- (void)chooseFromCamera
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self.viewController presentViewController:imagePicker animated:YES completion:nil];
}

- (UIImage *)fixOrientation:(UIImage *)aImage
{
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    WS(weakSelf)
    [self.viewController dismissViewControllerAnimated:YES completion:^{
        UIImage *image = [info objectForKeyedSubscript:UIImagePickerControllerOriginalImage];
        UIImage * resultImage = [self fixOrientation:image];
        [weakSelf onOneImageSelect:resultImage];
    }];
}

- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage
{
    WS(weakSelf)
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        [weakSelf onOneImageBack:editedImage];
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController
{
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark -
#pragma mark ZYQAssetPickerControllerDelegate
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    if (assets.count==0) {
        return;
    }
    
    dispatch_queue_t queue = dispatch_queue_create("getAlarmPhoto", nil);
    // loading
    
    [self onLoadingImage];
    
    NSMutableArray * picArray = [[NSMutableArray alloc] init];
    
    dispatch_async(queue,^{
        
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset = [assets objectAtIndexedSubscript:i];
            
            ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
            CGImageRef fullScreenImage = [assetRepresentation fullScreenImage];
            UIImage *result = [UIImage imageWithCGImage:fullScreenImage];
            [picArray addObject:result];
            
//            ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
//            CGImageRef fullResImage = [assetRepresentation fullResolutionImage];
//            NSString *adjustment = [[assetRepresentation metadata] objectForKey:@"AdjustmentXMP"];
//            if (adjustment) {
//                NSData *xmpData = [adjustment dataUsingEncoding:NSUTF8StringEncoding];
//                CIImage *image = [CIImage imageWithCGImage:fullResImage];
//                
//                NSError *error = nil;
//                NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:xmpData
//                                                             inputImageExtent:image.extent
//                                                                        error:&error];
//                CIContext *context = [CIContext contextWithOptions:nil];
//                if (filterArray && !error) {
//                    for (CIFilter *filter in filterArray) {
//                        [filter setValue:image forKey:kCIInputImageKey];
//                        image = [filter outputImage];
//                    }
//                    fullResImage = [context createCGImage:image fromRect:[image extent]];
//                }
//            }
//            UIImage *result = [UIImage imageWithCGImage:fullResImage
//                                                  scale:[assetRepresentation scale]
//                                            orientation:(UIImageOrientation)[assetRepresentation orientation]];
//            
//            [picArray addObject:[UIKitTool fixOrientation:result]];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(_clipping){
                // 如果需要剪裁， 不论返回多少照片，都默认只剪裁第一张
                [self onOneImageSelect:[picArray objectAtIndex:0]];
            }else
            {
                [self onImageArrayBack:picArray];
            }
        });
        
    });
    
    
//    
//    
//    NSMutableArray * imageArray = [[NSMutableArray alloc] init];
//    for (int i=0; i<assets.count; i++) {
//        ALAsset *asset = [assets objectAtIndexedSubscript:i];
//        
//        ALAssetRepresentation *assetRepresentation = [asset defaultRepresentation];
//        CGImageRef fullResImage = [assetRepresentation fullResolutionImage];
//        NSString *adjustment = [[assetRepresentation metadata] objectForKey:@"AdjustmentXMP"];
//        if (adjustment) {
//            NSData *xmpData = [adjustment dataUsingEncoding:NSUTF8StringEncoding];
//            CIImage *image = [CIImage imageWithCGImage:fullResImage];
//            
//            NSError *error = nil;
//            NSArray *filterArray = [CIFilter filterArrayFromSerializedXMP:xmpData
//                                                         inputImageExtent:image.extent
//                                                                    error:&error];
//            CIContext *context = [CIContext contextWithOptions:nil];
//            if (filterArray && !error) {
//                for (CIFilter *filter in filterArray) {
//                    [filter setValue:image forKey:kCIInputImageKey];
//                    image = [filter outputImage];
//                }
//                fullResImage = [context createCGImage:image fromRect:[image extent]];
//            }
//        }
//        UIImage *result = [UIImage imageWithCGImage:fullResImage
//                                              scale:[assetRepresentation scale]
//                                        orientation:(UIImageOrientation)[assetRepresentation orientation]];
//        
//        [imageArray addObject:[UIKitTool fixOrientation:result]];
//        
//    }
//    if(_selectMax == 1){
//        [self onOneImageBack:imageArray.firstObject];
//    }else{
//        [self onImageArrayBack:imageArray];
//    }
}

@end
