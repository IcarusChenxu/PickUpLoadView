//
//  ViewController.m
//  PicUpLoadView
//
//  Created by lcarus on 16/9/26.
//  Copyright © 2016年 chenxu. All rights reserved.
//

#import "ViewController.h"
#import "PickUpLoadView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //头像
    PickUpLoadView *imgview = [[PickUpLoadView alloc] initWithSystemHead:[UIImage imageNamed:@"heard.jpg"] UserSetUpHeadImg:nil IsRound:YES];
    imgview.center = CGPointMake(self.view.center.x, 80);
    [self.view addSubview:imgview];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
