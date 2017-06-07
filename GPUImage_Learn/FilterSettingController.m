//
//  FilterSettingController.m
//  GPUImage_Learn
//
//  Created by tqh on 2017/6/7.
//  Copyright © 2017年 tqn. All rights reserved.
//

#import "FilterSettingController.h"
#import <GPUImage/GPUImage.h>

@interface FilterSettingController ()

@property (nonatomic,strong) UIImageView *imageView;

@end

@implementation FilterSettingController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageView];
    //设置滤镜
    GPUImageFilter *filter = [[GPUImageSepiaFilter alloc] init];
    UIImage *image = [UIImage imageNamed:@"face"];
    if (image) {
        //通过滤镜输出滤镜图像
        self.imageView.image = [filter imageByFilteringImage:image];
    }
}

#pragma mark - 懒加载

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _imageView.backgroundColor = [UIColor redColor];
    }
    return _imageView;
}


@end
