//
//  SobelController.m
//  GPUImage_Learn
//
//  Created by tqh on 2017/6/16.
//  Copyright © 2017年 tqn. All rights reserved.
//

#import "SobelController.h"

@interface SobelController ()

@property (nonatomic , strong) GPUImageVideoCamera *videoCamera;
@property (nonatomic , strong) GPUImageSobelEdgeDetectionFilter *filter;
@property (nonatomic , strong) GPUImageMovieWriter *movieWriter;
@property (nonatomic , strong) GPUImageView *filterView;
@property (nonatomic , strong) CADisplayLink *mDisplayLink;

@end

@implementation SobelController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
    _videoCamera.outputImageOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    _filter = [[GPUImageSobelEdgeDetectionFilter alloc] init];
    _filter.edgeStrength = 2;
    //    _filter.texelWidth = _filter.texelWidth * 2;
    //    _filter.texelHeight = _filter.texelHeight * 2;
    
    _filterView = [[GPUImageView alloc] initWithFrame:self.view.frame];
    self.view = _filterView;
    
    [_videoCamera addTarget:_filter];
    [_filter addTarget:_filterView];
    [_videoCamera startCameraCapture];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidChangeStatusBarOrientationNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        _videoCamera.outputImageOrientation = [UIApplication sharedApplication].statusBarOrientation;
    }];
    
    self.mDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displaylink:)];
    [self.mDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)displaylink:(CADisplayLink *)displaylink {
}


@end
