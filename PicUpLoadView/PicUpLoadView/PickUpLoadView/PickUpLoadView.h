//
//  PickUpLoadView.h
//  PicUpLoadView
//
//  Created by lcarus on 16/9/26.
//  Copyright © 2016年 chenxu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PickUpLoadView : UIImageView<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>



/**
 -----上传头像-----
 @param   sysimg     默认头像
 @param   userimg    用户设置过的头像（从服务器获取的）
 @param   isRound    是否圆形头像

 
 */
-(instancetype)initWithSystemHead:(UIImage *)sysimg UserSetUpHeadImg:(UIImage *)userimg  IsRound:(BOOL)isRound ;
/**
  sysimg 默认头像
 */
@property(nonatomic,strong)UIImage *sysimg;
/**
   userimg    用户设置过的头像（从服务器获取的）
 */
@property(nonatomic,strong)UIImage *userimg;


@property (nonatomic,strong) UIViewController *controller;
@property (nonatomic,strong) NSData *fileData;
@property (nonatomic,strong) UIImagePickerController *imagePicker;




@end
