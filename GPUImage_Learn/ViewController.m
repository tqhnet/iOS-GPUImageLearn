//
//  ViewController.m
//  GPUImage_Learn
//
//  Created by tqh on 2017/5/31.
//  Copyright © 2017年 tqn. All rights reserved.
//

#import "ViewController.h"
#import "FilterSettingController.h"
#import "FilterTestController.h"
#import "FilterMovieViewController.h"
#import <GPUImage/GPUImage.h>

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSArray *classArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];  
    [self.view addSubview:self.tableView];
    self.title = @"GPUImage";    //创建输出视图

}

#pragma mark - <UITableViewDelegate,UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    cell.textLabel.text = self.classArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self push:self.classArray[indexPath.row]];
}

#pragma mark - 懒加载

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    }
    return _tableView;
}

- (NSArray *)classArray {
    if (!_classArray) {
        _classArray = @[@"FilterSettingController",@"FilterTestController",@"FilterMovieViewController",@"BlurredPictureViewController",@"FilterVideoViewController",@"VideoWatermarkingViewController",@"VideoWatermarkingViewController2",@"VideoMergeMixingViewController",@"ImageInputAndOutputController",@"MergeVideoController",@"FaceRecognitionController",@"SobelController",@"FaceGPUImageController",@"MARFaceBeautyController"];
    }
    return _classArray;
}

#pragma mark - others

- (void)push:(NSString *)className {
    Class getClass = NSClassFromString(className);
    if (getClass) {
        id createClass = [[getClass alloc]init];
        [self.navigationController pushViewController:createClass animated:YES];
//        [self presentViewController:createClass animated:YES completion:nil];
    }else {
        NSLog(@"没有class对象");
    }
}

@end
