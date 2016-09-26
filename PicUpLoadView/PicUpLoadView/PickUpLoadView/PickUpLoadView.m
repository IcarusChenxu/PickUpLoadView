//
//  PickUpLoadView.m
//  PicUpLoadView
//
//  Created by lcarus on 16/9/26.
//  Copyright © 2016年 chenxu. All rights reserved.
//

#import "PickUpLoadView.h"
#import <MobileCoreServices/UTCoreTypes.h>
@implementation PickUpLoadView

-(instancetype)initWithSystemHead:(UIImage *)sysimg UserSetUpHeadImg:(UIImage *)userimg  IsRound:(BOOL)isRound {
    if (self = [super init]) {
        self.userInteractionEnabled = YES;
        self.sysimg     = sysimg;
        self.userimg    = userimg;
#pragma 设置圆形
        if (isRound) {
            self.frame = CGRectMake(20, 20, 60, 60);
            [self.layer setCornerRadius:CGRectGetHeight([self bounds]) / 2];
            self.layer.masksToBounds = YES;
        }
        
        
        if (userimg == nil) {
            self.image = sysimg;
            
        }else{
            self.image = userimg;
            
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(PictureClick)];
        [self addGestureRecognizer:tap];
        
        
        
    }
    
    return self;
}
//遍历该View的树形结构，获取到其所属的ViewController
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}


//弹出actionsheet。选择获取头像的方式
//从相册获取图片
-(void)PictureClick
{
    
   
    UIActionSheet* actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"请选择文件来源"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"照相机",@"摄像机",@"本地相簿",@"本地视频",nil];
    [actionSheet showInView:[self viewController].view];
    
    
}
#pragma mark -
#pragma UIActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
  
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.allowsEditing = YES;
    
    switch (buttonIndex) {
        case 0://照相机
        {
            
            
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            
        }
            break;
        case 1://摄像机
        {
            
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            self.imagePicker.videoQuality = UIImagePickerControllerQualityTypeLow;
            
        }
            break;
        case 2://本地相簿
        {
            
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
        }
            break;
        case 3://本地视频
        {
            
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
        }
            break;
        default:
            break;
    }
    
    [[self viewController] presentViewController:self.imagePicker animated:YES completion:nil];
    
    
}

#pragma mark -
#pragma UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *str = @"1234";
    printf("%s",[str UTF8String]);
    
    NSString* type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
        NSString *videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        self.fileData = [NSData dataWithContentsOfFile:videoPath];
    }
    //	[picker dismissModalViewControllerAnimated:YES];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//
    self.image = selfPhoto;
    //[self.img.layer setCornerRadius:CGRectGetHeight([self.img bounds]) / 2];  //修改半径，实现头像的圆形化
    // self.img.layer.masksToBounds = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //	[picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
    NSLog(@"保存头像！");
    // 需要将照片保存至应用程序沙箱，由于涉及到数据存储，同时与界面无关
    // 可以使用多线程来保存图像
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //	[userPhotoButton setImage:image forState:UIControlStateNormal];
        BOOL success;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
        NSLog(@"imageFile->>%@",imageFilePath);
      
        
        success = [fileManager fileExistsAtPath:imageFilePath];
        if(success) {
            success = [fileManager removeItemAtPath:imageFilePath error:&error];
        }
        UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
        // UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(93, 93)];
        // UIImageJPEGRepresentation(<#UIImage *image#>, <#CGFloat compressionQuality#>)
        [UIImageJPEGRepresentation(smallImage, 1.0f)  writeToFile:imageFilePath atomically:YES];//写入文件
        UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
        //	[userPhotoButton setImage:selfPhoto forState:UIControlStateNormal];
        self.image = selfPhoto;
    });
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
