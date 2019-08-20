
//  VicFaceViewController.m
//  VicCameraKit
//
//  Created by Dodgson on 1/21/19.
//  Copyright © 2019 Dodgson. All rights reserved.
//

#import "VicFaceViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CMMetadata.h>
#import <Photos/Photos.h>

#import "CCImagePreviewController.h"
#import "CCCameraView.h"
#import "CCCameraManager.h"
#import "CCMotionManager.h"
#import "CCMovieManager.h"
#import "VicCameraKit.h"
//#import <VicPopupKit/VicPopupKit.h>
#import "VicClipPhotoView.h"
#import "VicAnimationPopTool.h"
#import "VicFaceAuthManager.h"
#import "NSDictionary+VicExt.h"

#define ISIOS9 __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0

@interface VicFaceViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate, AVCaptureAudioDataOutputSampleBufferDelegate, CCCameraViewDelegate>
{
    // 会话
    AVCaptureSession          *_session;
    
    // 输入
    AVCaptureDeviceInput      *_deviceInput;
    
    // 输出
    AVCaptureConnection       *_videoConnection;
    AVCaptureConnection       *_audioConnection;
    AVCaptureVideoDataOutput  *_videoOutput;
    AVCaptureStillImageOutput *_imageOutput;
    
    // 录制
    BOOL                       _recording;
}
@property(nonatomic, strong) CCCameraView *cameraView;          // 界面布局
@property(nonatomic, strong) CCMovieManager  *movieManager;     // 视频管理
@property(nonatomic, strong) CCCameraManager *cameraManager;    // 相机管理
@property(nonatomic, strong) CCMotionManager *motionManager;    // 陀螺仪管理
@property(nonatomic, strong) AVCaptureDevice *activeCamera;     // 当前输入设备
@property(nonatomic, strong) AVCaptureDevice *inactiveCamera;   // 不活跃的设备(这里指前摄像头或后摄像头，不包括外接输入设备)

@property (nonatomic, strong) NSMutableArray *dataArray;

//@property (nonatomic, strong) dispatch_source_t commitTimer;

@property (nonatomic, strong) dispatch_source_t checkTimer;

//@property (nonatomic, strong) dispatch_source_t hintTimer;


@property (nonatomic, assign) BOOL isCheckModel;

@property (nonatomic, assign) BOOL isValidateModel;

@property (nonatomic, assign) BOOL isLoadTimer;

@property (nonatomic, assign) BOOL isLoadCheckTimer;

@property (nonatomic, assign) BOOL isLoadHintTimer;

@property (nonatomic, assign) NSInteger checkTime;

@property (nonatomic, assign) NSInteger hintTime;

@property (nonatomic, assign) NSInteger allTime;

@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock successBlock;
@end

@implementation VicFaceViewController
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    VicFaceViewController *vc = [[VicFaceViewController alloc] init];
    vc.successBlock = block;
    vc.requestParams = requestParams;
    //        UINavigationController *reNavCon = [[UINavigationController alloc]initWithRootViewController:vc];
    //        [rootVC presentViewController:reNavCon animated:YES completion:nil];
    
    //        [[YBNaviagtionViewController rootNavigationController] pushViewController:vc animated:true];
    
    [rootVC presentViewController:vc animated:YES completion:^{
    }];
    return vc;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        _motionManager = [[CCMotionManager alloc] init];
        _cameraManager = [[CCCameraManager alloc] init];
        self.hintTime = 3;
        self.allTime = 3;
        self.checkTime = 15;
        _dataArray = @[].mutableCopy;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.checkTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    //    self.hintTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    //    self.commitTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    
    self.cameraView = [[CCCameraView alloc] initWithFrame:self.view.bounds];
    self.cameraView.delegate = self;
    [self.view addSubview:self.cameraView];
    
    @weakify(self);
    self.cameraView.topView.leftClick = ^{
        @strongify(self);
        [self stopCaptureSession];
        self.navigationController.navigationBarHidden = NO;
        self.hintTime = -1;
        self.checkTime = -1;
        self.allTime = -1;
        //        if(self.commitTimer){
        //            dispatch_source_cancel(self.commitTimer);
        //        }
        //        if(self.hintTimer){
        //            dispatch_source_cancel(self.hintTimer);
        //        }
        
        if(self.checkTimer){
            dispatch_source_cancel(self.checkTimer);
        }
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cancelSystermSound) object:nil];
        AudioServicesDisposeSystemSoundID(0);
        
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(takePhotoAction:) object:self.cameraView];
        
        self.cameraView = nil;
        
        
        [[AFHTTPSessionManager manager].operationQueue cancelAllOperations];
        NSLog(@"VIC-%@",self);
        [self dismissViewControllerAnimated:YES completion:nil];
        
    };
    
    
    NSError *error;
    [self setupSession:&error];
    if (!error) {
        [self.cameraView.previewView setCaptureSessionsion:_session];
        [self startCaptureSession];
    }else{
        [self.view showError:error];
    }
    
    [self swicthCameraAction:_cameraView animation:NO handle:^(NSError *error) {
        @strongify(self);
        self.isCheckModel = YES;
        self.isValidateModel = NO;
        if(!error){
            [self startCheckModel];
        }else{
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (void)dealloc{
    NSLog(@"VIC-%@",self);
    NSLog(@"相机界面销毁了");
}

#pragma mark - -输入设备
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)activeCamera{
    return _deviceInput.device;
}

- (AVCaptureDevice *)inactiveCamera{
    AVCaptureDevice *device = nil;
    if ([[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1) {
        if ([self activeCamera].position == AVCaptureDevicePositionBack) {
            device = [self cameraWithPosition:AVCaptureDevicePositionFront];
        } else {
            device = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
    }
    return device;
}

#pragma mark - -相关配置
/// 会话
- (void)setupSession:(NSError **)error{
    _session = [[AVCaptureSession alloc]init];
    _session.sessionPreset = AVCaptureSessionPresetHigh;
    
    [self setupSessionInputs:error];
    [self setupSessionOutputs:error];
}

/// 输入
- (void)setupSessionInputs:(NSError **)error{
    // 视频输入
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:error];
    if (videoInput) {
        if ([_session canAddInput:videoInput]){
            [_session addInput:videoInput];
        }
    }
    _deviceInput = videoInput;
}

/// 输出
- (void)setupSessionOutputs:(NSError **)error{
    dispatch_queue_t captureQueue = dispatch_queue_create("com.cc.captureQueue", DISPATCH_QUEUE_SERIAL);
    
    // 视频输出
    AVCaptureVideoDataOutput *videoOut = [[AVCaptureVideoDataOutput alloc] init];
    [videoOut setAlwaysDiscardsLateVideoFrames:YES];
    [videoOut setVideoSettings:@{(id)kCVPixelBufferPixelFormatTypeKey: [NSNumber numberWithInt:kCVPixelFormatType_32BGRA]}];
    [videoOut setSampleBufferDelegate:self queue:captureQueue];
    if ([_session canAddOutput:videoOut]){
        [_session addOutput:videoOut];
    }
    _videoOutput = videoOut;
    _videoConnection = [videoOut connectionWithMediaType:AVMediaTypeVideo];
    
    // 静态图片输出
    AVCaptureStillImageOutput *imageOutput = [[AVCaptureStillImageOutput alloc] init];
    imageOutput.outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    if ([_session canAddOutput:imageOutput]) {
        [_session addOutput:imageOutput];
    }
    _imageOutput = imageOutput;
}

#pragma mark - -会话控制
// 开启捕捉
- (void)startCaptureSession{
    if (!_session.isRunning){
        [_session startRunning];
    }
}

- (void)cancelSystermSound {
    static SystemSoundID soundID = 0;
    if (soundID == 0) {
        NSString *path =[[NSBundle mainBundle] pathForResource:@"photoShutter2" ofType:@"caf"];
        NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    }
    AudioServicesPlaySystemSound(soundID);
}

// 停止捕捉
- (void)stopCaptureSession{
    if (_session.isRunning){
        [_session stopRunning];
    }
}

#pragma mark - -操作相机
// 缩放
-(void)zoomAction:(CCCameraView *)cameraView factor:(CGFloat)factor {
    NSError *error = [_cameraManager zoom:[self activeCamera] factor:factor];
    if (error) NSLog(@"%@", error);
}

// 聚焦
-(void)focusAction:(CCCameraView *)cameraView point:(CGPoint)point handle:(void (^)(NSError *))handle {
    NSError *error = [_cameraManager focus:[self activeCamera] point:point];
    handle(error);
    NSLog(@"%f", [self activeCamera].activeFormat.videoMaxZoomFactor);
}

// 曝光
-(void)exposAction:(CCCameraView *)cameraView point:(CGPoint)point handle:(void (^)(NSError *))handle {
    NSError *error = [_cameraManager expose:[self activeCamera] point:point];
    handle(error);
}

// 自动聚焦、曝光
-(void)autoFocusAndExposureAction:(CCCameraView *)cameraView handle:(void (^)(NSError *))handle {
    NSError *error = [_cameraManager resetFocusAndExposure:[self activeCamera]];
    handle(error);
}

// 闪光灯
-(void)flashLightAction:(CCCameraView *)cameraView handle:(void (^)(NSError *))handle {
    BOOL on = [_cameraManager flashMode:[self activeCamera]] == AVCaptureFlashModeOn;
    AVCaptureFlashMode mode = on ? AVCaptureFlashModeOff : AVCaptureFlashModeOn;
    NSError *error = [_cameraManager changeFlash:[self activeCamera] mode: mode];
    handle(error);
}

// 手电筒
-(void)torchLightAction:(CCCameraView *)cameraView handle:(void (^)(NSError *))handle {
    BOOL on = [_cameraManager torchMode:[self activeCamera]] == AVCaptureTorchModeOn;
    AVCaptureTorchMode mode = on ? AVCaptureTorchModeOff : AVCaptureTorchModeOn;
    NSError *error = [_cameraManager changeTorch:[self activeCamera] model:mode];
    handle(error);
}

// 转换摄像头
- (void)swicthCameraAction:(CCCameraView *)cameraView animation:(BOOL)animation handle:(void (^)(NSError *))handle{
    NSError *error;
    AVCaptureDevice *videoDevice = [self inactiveCamera];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if (videoInput) {
        // 动画效果
        if(animation){
            CATransition *animation = [CATransition animation];
            animation.type = @"oglFlip";
            animation.subtype = kCATransitionFromLeft;
            animation.duration = 0.5;
            [self.cameraView.previewView.layer addAnimation:animation forKey:@"flip"];
        }
        
        
        // 当前闪光灯状态
        AVCaptureFlashMode mode = [_cameraManager flashMode:[self activeCamera]];
        
        // 转换摄像头
        _deviceInput = [_cameraManager switchCamera:_session old:_deviceInput new:videoInput];
        
        // 重新设置视频输出链接
        _videoConnection = [_videoOutput connectionWithMediaType:AVMediaTypeVideo];
        
        // 如果后置转前置，系统会自动关闭手电筒(如果之前打开的，需要更新UI)
        if (videoDevice.position == AVCaptureDevicePositionFront) {
            //            [self.cameraView changeTorch:NO];
        }
        // 前后摄像头的闪光灯不是同步的，所以在转换摄像头后需要重新设置闪光灯
        [_cameraManager changeFlash:[self activeCamera] mode:mode];
    }
    handle(error);
}

#pragma mark - -拍摄照片
- (void)startAutoTakePhoto{
    @weakify(self);
    self.checkTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(self.checkTimer, dispatch_walltime(NULL, 0), 0.5*NSEC_PER_SEC, 0);
    //每秒执行
    dispatch_source_set_event_handler(self.checkTimer, ^{
        @strongify(self);
        if (self.allTime > 0){
            dispatch_async(dispatch_get_main_queue(), ^{
                if(self.allTime == 1 || self.allTime == 2 || self.allTime == 3){
                    [self.cameraView.bottomView updateViewWith:3 time:self.hintTime];
                }
                if(!self.isLoadTimer){
                    [self takePhotoAction:self.cameraView];
                    [self cancelSystermSound];
                    self.allTime = self.allTime - 0.5;
                }
            });
        }else{
            dispatch_source_cancel(self.checkTimer);
        }
    });
    dispatch_resume(self.checkTimer);
}

- (void)startCheckModel{
    dispatch_source_set_timer(self.checkTimer, dispatch_walltime(NULL, 0), 1*NSEC_PER_SEC, 0);
    //每秒执行
    @weakify(self);
    dispatch_source_set_event_handler(self.checkTimer, ^{
        @strongify(self);
        if(!self.isCheckModel){
            dispatch_source_cancel(self.checkTimer);
            self.checkTimer = nil;
        }
        else if (self.checkTime > 0){
            self.checkTime--;
            if(!self.isLoadCheckTimer){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self takePhotoAction:self.cameraView];
                    [self cancelSystermSound];
                });
            }
            
        }else{
            dispatch_source_cancel(self.checkTimer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self dismissViewControllerAnimated:YES completion:^{
                    [YKToastView showToastText:@"监测人脸超时"];
                }];
            });
            
        }
    });
    dispatch_resume(self.checkTimer);
}

// 拍照
- (void)takePhotoAction:(CCCameraView *)cameraView{
    self.isLoadTimer = YES;
    self.isLoadCheckTimer = YES;
    
    AVCaptureConnection *connection = [_imageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (connection.isVideoOrientationSupported) {
        connection.videoOrientation = [self currentVideoOrientation];
    }
    __weak typeof(self) weakSelf = self;
    [_imageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
        if (error) {
            //            [self.view showError:error];
            return;
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *image = [[UIImage alloc]initWithData:imageData];
        [VicFaceAuthManager faceRecognitionWithImage:image landmark:VicLandmark_Not attributes:@"blur" calculate_all:YES face_rectangle:CGRectZero successCompletion:^(id  _Nonnull data) {
            if([data isKindOfClass:[NSDictionary class]]){
                NSDictionary *dict = (NSDictionary *)data;
                NSArray *arr = [dict objectOrNilForKey:@"faces"];
                if(arr.count > 0){
                    NSDictionary *attributesDict = [[arr firstObject] objectOrNilForKey:@"attributes"];
                    NSString *face_token = [[arr firstObject] objectForKey:@"face_token"];
                    NSDictionary *blurDict = [attributesDict objectOrNilForKey:@"blur"];
                    NSDictionary *blurnessDict = [blurDict objectOrNilForKey:@"blurness"];
                    NSDictionary *gaussianblurDict = [blurDict objectOrNilForKey:@"gaussianblur"];
                    NSDictionary *motionblurDict = [blurDict objectOrNilForKey:@"motionblur"];
                    NSString *blurnessValue = [blurnessDict objectOrNilForKey:@"value"];
                    NSString *gaussianblurValue = [gaussianblurDict objectOrNilForKey:@"value"];
                    NSString *motionblurValue = [motionblurDict objectOrNilForKey:@"value"];
                    float value = ([blurnessValue floatValue] + [gaussianblurValue floatValue] + [motionblurValue floatValue])/3;
                    NSDictionary *dataDict = @{};
                    dataDict = [dataDict vic_appendKey:@"face_token" value:face_token];
                    dataDict = [dataDict vic_appendKey:@"value" value:[NSString stringWithFormat:@"%.4f",value]];
                    if(weakSelf.isCheckModel){
                        if(value < 1){
                            if(weakSelf.isCheckModel){
                                [weakSelf startAutoTakePhoto];
                                weakSelf.isCheckModel = NO;
                                weakSelf.isValidateModel = YES;
                            }else{
                                //                                weakSelf ;
                            }
                        }
                    }
                    if(weakSelf.isValidateModel){
                        [weakSelf.dataArray addObject:dataDict];
                    }
                }else{
                    if(weakSelf.isValidateModel){
                        [weakSelf.dataArray addObject:@{}];
                    }
                }
                if(weakSelf.dataArray.count == FaceAuthAutoPhotoCount){
                    [weakSelf faceAuth];
                }
            }
            weakSelf.isLoadTimer = NO;
            weakSelf.isLoadCheckTimer = NO;
        } errorCompletion:^(NSError * _Nonnull error) {
            if(weakSelf.isValidateModel){
                [weakSelf.dataArray addObject:@{}];
            }
            if(weakSelf.dataArray.count == FaceAuthAutoPhotoCount){
                [weakSelf faceAuth];
            }
            weakSelf.isLoadTimer = NO;
            weakSelf.isLoadCheckTimer = NO;
        }];
    }];
}

// 取消拍照
- (void)cancelAction:(CCCameraView *)cameraView{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - -录制视频
// 开始录像
-(void)startRecordVideoAction:(CCCameraView *)cameraView{
    _recording = YES;
    _movieManager.currentDevice = [self activeCamera];
    _movieManager.currentOrientation = [self currentVideoOrientation];
    [_movieManager start:^(NSError * _Nonnull error) {
        if (error) [self.view showError:error];
    }];
}

// 停止录像
-(void)stopRecordVideoAction:(CCCameraView *)cameraView{
    _recording = NO;
    @weakify(self)
    [_movieManager stop:^(NSURL * _Nonnull url, NSError * _Nonnull error) {
        @strongify(self);
        if (error) {
            [self.view showError:error];
        } else {
            [self.view showAlertView:@"是否保存到相册" ok:^(UIAlertAction *act) {
                [self saveMovieToCameraRoll: url];
            } cancel:nil];
        }
    }];
}

// 保存视频
- (void)saveMovieToCameraRoll:(NSURL *)url{
    [self.view showLoadHUD:@"保存中..."];
    @weakify(self)
    if (ISIOS9) {
        [PHPhotoLibrary requestAuthorization:^( PHAuthorizationStatus status ) {
            @strongify(self);
            if (status != PHAuthorizationStatusAuthorized) return;
            [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                PHAssetCreationRequest *videoRequest = [PHAssetCreationRequest creationRequestForAsset];
                [videoRequest addResourceWithType:PHAssetResourceTypeVideo fileURL:url options:nil];
            } completionHandler:^( BOOL success, NSError * _Nullable error ) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [self.view hideHUD];
                });
                success?:[self.view showError:error];
            }];
        }];
    } else {
        @strongify(self);
        ALAssetsLibrary *lab = [[ALAssetsLibrary alloc]init];
        [lab writeVideoAtPathToSavedPhotosAlbum:url completionBlock:^(NSURL *assetURL, NSError *error) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.view hideHUD];
            });
            !error?:[self.view showError:error];
        }];
    }
}

#pragma mark - -输出代理
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    if (_recording) {
        [_movieManager writeData:connection video:_videoConnection audio:_audioConnection buffer:sampleBuffer];
    }
}

#pragma mark - -其它方法
// 当前设备取向
- (AVCaptureVideoOrientation)currentVideoOrientation{
    AVCaptureVideoOrientation orientation;
    switch (self.motionManager.deviceOrientation) {
        case UIDeviceOrientationPortrait:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeLeft:
            orientation = AVCaptureVideoOrientationLandscapeRight;
            break;
        case UIDeviceOrientationLandscapeRight:
            orientation = AVCaptureVideoOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            orientation = AVCaptureVideoOrientationPortraitUpsideDown;
            break;
        default:
            orientation = AVCaptureVideoOrientationPortrait;
            break;
    }
    return orientation;
}



- (void)faceAuth{
    float minValue = 1000;
    NSString *token;
    for (NSDictionary *dict in _dataArray) {
        float value = [[dict objectOrNilForKey:@"value"] floatValue];
        if(value > 0){
            if(value < minValue){
                minValue = value;
                token = [dict objectOrNilForKey:@"face_token"];
            }
        }
    }
    
    [VicFaceAuthManager compareFaceWithFirstFaceURL:self.requestParams firstFaceToken:token firstRectangle:CGRectZero successCompletion:^(id  _Nonnull data) {
        NSDictionary *dict = (NSDictionary *)data;
        NSString *confidence = [dict objectOrNilForKey:@"confidence"];
        NSString *thresholds = [[dict objectOrNilForKey:@"thresholds"] jsonStringEncoded];
        NSString *imageIdA = token;
        NSString *imageIdB = [dict objectOrNilForKey:@"image_id2"];
        if(confidence.floatValue < 80){
            [self.cameraView.bottomView updateViewWith:1 time:0];
            [YKToastView showToastText:@"认证失败"];
            
            
        }else{
            
            
            NSDictionary *param = @{};
            param = [param vic_appendKey:@"confidence" value:confidence];
            param = [param vic_appendKey:@"thresholds" value:thresholds];
            param = [param vic_appendKey:@"imageIdA" value:imageIdA];
            param = [param vic_appendKey:@"imageIdB" value:imageIdB];
            
            [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_FaceIdentity] andType:All andWith:param success:^(NSDictionary *dic) {
                if ([NSString getDataSuccessed:dic]) {
                    [self.cameraView.bottomView updateViewWith:4 time:0];
                }
                else{
                    [self.cameraView.bottomView updateViewWith:1 time:0];
                    [YKToastView showToastText:@"服务器或者网络异常"];
                }
            } error:^(NSError *error) {
                [self.cameraView.bottomView updateViewWith:1 time:0];
            }];
            
            
        }
        
        
    } errorCompletion:^(NSError * _Nonnull error) {
        [self.cameraView.bottomView updateViewWith:1 time:0];
    }];
    
}



@end
