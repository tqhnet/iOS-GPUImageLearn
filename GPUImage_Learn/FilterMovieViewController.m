//
//  FilterMovieViewController.m
//  GPUImage_Learn
//
//  Created by tqh on 2017/6/7.
//  Copyright © 2017年 tqn. All rights reserved.
//

#import "FilterMovieViewController.h"
#import <GPUImage/GPUImage.h>
#import "GPUImageBeautifyFilter.h"
#import <AssetsLibrary/ALAssetsLibrary.h>

@interface FilterMovieViewController ()

@property (nonatomic,strong) GPUImageView *filterView;          //输出视图
@property (nonatomic,strong) GPUImageVideoCamera *videoCamera;  //视频相机
@property (nonatomic,strong) GPUImageMovieWriter *movieWriter;  //视频写入

@end

@implementation FilterMovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.filterView];
    
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathToMovie UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    
    self.videoCamera.audioEncodingTarget = self.movieWriter;
    [self.videoCamera startCameraCapture];
    
    GPUImageBeautifyFilter *beautifyFilter = [[GPUImageBeautifyFilter alloc] init];
    [self.videoCamera addTarget:beautifyFilter];
    [beautifyFilter addTarget:self.filterView];
    [beautifyFilter addTarget:self.movieWriter];
    [_movieWriter startRecording];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [beautifyFilter removeTarget:_movieWriter];
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
                                                                        delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                         [alert show];
                     }
                 });
             }];
        }
        else {
            NSLog(@"error mssg)");
        }
    });
    
}

#pragma mark - 懒加载

- (GPUImageView *)filterView {
    if (!_filterView) {
        _filterView = [[GPUImageView alloc]initWithFrame:self.view.bounds];
    }
    return _filterView;
}

- (GPUImageVideoCamera *)videoCamera {
    if (!_videoCamera) {
        _videoCamera = [[GPUImageVideoCamera alloc] initWithSessionPreset:AVCaptureSessionPreset640x480 cameraPosition:AVCaptureDevicePositionFront];
        _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        _videoCamera.horizontallyMirrorFrontFacingCamera = YES;
    }
    return _videoCamera;
}

- (GPUImageMovieWriter *)movieWriter {
    if (!_movieWriter) {
        _movieWriter = [[GPUImageMovieWriter alloc] initWithMovieURL:[self outputMovieURL] size:CGSizeMake(480, 640.0)];
        _movieWriter.encodingLiveVideo = YES;
    }
    return _movieWriter;
}

#pragma mark - other

//视频输出地址
- (NSURL *)outputMovieURL {
    
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    unlink([pathToMovie UTF8String]);
    NSURL *movieURL = [NSURL fileURLWithPath:pathToMovie];
    return movieURL;
}

@end
