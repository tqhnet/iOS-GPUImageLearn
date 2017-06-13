//
//  FilterVideoViewController.m
//  GPUImage_Learn
//
//  Created by tqh on 2017/6/13.
//  Copyright © 2017年 tqn. All rights reserved.
//

#import "FilterVideoViewController.h"
#import "GPUImage.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface FilterVideoViewController ()

@property (nonatomic , strong) GPUImageVideoCamera *videoCamera;        //相机
@property (nonatomic , strong) GPUImageOutput<GPUImageInput> *filter;   //滤镜
@property (nonatomic , strong) GPUImageMovieWriter *movieWriter;        //视频写入
@property (nonatomic , strong) GPUImageView *filterView;                //输出视图
    
@property (nonatomic , strong) UIButton *mButton;                       //按钮
@property (nonatomic , strong) UILabel  *mLabel;                        //文本
@property (nonatomic , strong) UISlider *slider;                        //滑动条
@property (nonatomic , assign) long     mLabelTime;                     //时间
@property (nonatomic , strong) NSTimer  *mTimer;                        //定时器
@property (nonatomic , strong) CADisplayLink *mDisplayLink;             //屏幕刷新频率定时器

@end

@implementation FilterVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.filterView];
    [self.view addSubview:self.mButton];
    [self.view addSubview:self.mLabel];
    [self.view addSubview:self.slider];
    
    [self.videoCamera addTarget:self.filter];
    [self.filter addTarget:self.filterView];
    [self.videoCamera startCameraCapture];
    
    
    //视频的方向
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidChangeStatusBarOrientationNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        self.videoCamera.outputImageOrientation = [UIApplication sharedApplication].statusBarOrientation;
    }];
    
    //开启测试定时器
    [self.mDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

#pragma mark - 事件监听

- (void)displaylink:(CADisplayLink *)displaylink {
    NSLog(@"test");
}

- (void)updateSliderValue:(id)sender
{
    [(GPUImageSepiaFilter *)self.filter setIntensity:[(UISlider *)sender value]];
}

- (void)onTimer:(id)sender {
    self.mLabel.text  = [NSString stringWithFormat:@"录制时间:%lds", _mLabelTime++];
    [self.mLabel sizeToFit];
}
    
- (void)onClick:(UIButton *)sender {
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie4.m4v"];
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    if([sender.currentTitle isEqualToString:@"录制"]) {
        [sender setTitle:@"结束" forState:UIControlStateNormal];
        NSLog(@"Start recording");
        unlink([pathToMovie UTF8String]); // 如果已经存在文件，AVAssetWriter会有异常，删除旧文件
        _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:movieURL size:CGSizeMake(480.0, 640.0)];
        _movieWriter.encodingLiveVideo = YES;
        [_filter addTarget:_movieWriter];
        _videoCamera.audioEncodingTarget = _movieWriter;
        [_movieWriter startRecording];
        
        _mLabelTime = 0;
        _mLabel.hidden = NO;
        [self onTimer:nil];
        _mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
    }
    else {
        [sender setTitle:@"录制" forState:UIControlStateNormal];
        NSLog(@"End recording");
        _mLabel.hidden = YES;
        if (_mTimer) {
            [_mTimer invalidate];
        }
        [_filter removeTarget:_movieWriter];
        _videoCamera.audioEncodingTarget = nil;
        [_movieWriter finishRecording];
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(pathToMovie))
        {
            [library writeVideoAtPathToSavedPhotosAlbum:movieURL completionBlock:^(NSURL *assetURL, NSError *error)
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     if (error) {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存失败" message:nil
                                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alert show];
                     } else {
                         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"视频保存成功" message:nil
                                                                        delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alert show];
                     }
                 });
             }];
        }
        
    }

}
#pragma mark - 懒加载
    
- (GPUImageVideoCamera *)videoCamera {
    if (!_videoCamera) {
        _videoCamera = [[GPUImageVideoCamera alloc]initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionBack];
        _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    }
    return _videoCamera;
}
    
- (GPUImageOutput<GPUImageInput> *)filter {
    if (!_filter) {
        _filter = [[GPUImageSepiaFilter alloc] init];
    }
    return _filter;
}

- (GPUImageView *)filterView {
    if (!_filterView) {
        _filterView = [[GPUImageView alloc]initWithFrame:self.view.bounds];
    }
    return _filterView;
}
    
- (UIButton *)mButton {
    if (!_mButton) {
        _mButton = [UIButton new];
        _mButton.frame = CGRectMake(10, 100, 50, 50);
        [_mButton setTitle:@"录制" forState:UIControlStateNormal];
        [_mButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _mButton;
}

- (UILabel *)mLabel {
    if (!_mLabel) {
        _mLabel = [UILabel new];
        _mLabel.frame = CGRectMake(80, 110, 50, 100);
    }
    return _mLabel;
}
    
- (UISlider *)slider {
    if (!_slider) {
        _slider = [[UISlider alloc]init];
        _slider.frame = CGRectMake(20, 110+50, 300, 40);
        [_slider addTarget:self action:@selector(updateSliderValue:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (CADisplayLink *)mDisplayLink {
    if (!_mDisplayLink) {
        _mDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displaylink:)];
       
    }
    return _mDisplayLink;
}
    
@end
