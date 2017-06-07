//
//  FilterTestController.m
//  GPUImage_Learn
//
//  Created by tqh on 2017/6/7.
//  Copyright © 2017年 tqn. All rights reserved.
//

#import "FilterTestController.h"
#import <GPUImage/GPUImage.h>

@interface FilterTestController ()

@property (strong, nonatomic) GPUImageView *mGPUImageView;
@property (nonatomic , strong) GPUImageVideoCamera *mGPUVideoCamera;

@end

@implementation FilterTestController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    //创建输出视图
    self.mGPUImageView = [[GPUImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:self.mGPUImageView];

    self.mGPUVideoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    self.mGPUVideoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;

    GPUImageSepiaFilter* filter = [[GPUImageSepiaFilter alloc] init];
    [self.mGPUVideoCamera addTarget:filter];
    [filter addTarget:self.mGPUImageView];

    [self.mGPUVideoCamera startCameraCapture];
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    UIInterfaceOrientation orientation = (UIInterfaceOrientation)[UIDevice currentDevice].orientation;
    self.mGPUVideoCamera.outputImageOrientation = orientation;
}

@end
