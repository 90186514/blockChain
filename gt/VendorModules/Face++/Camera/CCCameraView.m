//
//  CCCameraView.m
//  CCCamera
//
//  Created by 佰道聚合 on 2017/7/5.
//  Copyright © 2017年 cyd. All rights reserved.
//

#import "CCCameraView.h"
#import "VicCameraKit.h"


#import "VicClipPhotoView.h"
//#import <VicPopupKit/VicPopupKit.h>

@interface CCCameraView()

@property(nonatomic, assign) NSInteger type; // 1：拍照 2：视频
@property(nonatomic, strong) CCVideoPreview *previewView;



@property (nonatomic, strong) UIImageView *photoRectImgView;

@property(nonatomic, strong) UIView *transparentView;

@property(nonatomic, strong) UIView *focusView;    // 聚焦动画view
@property(nonatomic, strong) UIView *exposureView; // 曝光动画view



@property(nonatomic, strong) UISlider *slider;
@end

@implementation CCCameraView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _type = 1;
        [self setupUI];
    }
    return self;
}

-(VicNavTopView *)topView{
    if (_topView == nil) {
        _topView = [[VicNavTopView alloc]initWithFrame:CGRectMake(0, 0, self.width, [YBSystemTool isIphoneX]?[YBFrameTool statusBarHeight]+VicNavigationHeight:VicNavigationHeight)];//VicNavigationHeight
    }
    return _topView;
}

-(VicCameraBottomView *)bottomView{
    if (_bottomView == nil) {
        CGFloat height = [YBSystemTool isIphoneX]?[YBFrameTool iphoneBottomHeight]+VicRateH(225.f):VicRateH(225.f);
        _bottomView = [[VicCameraBottomView alloc]initWithFrame:CGRectMake(0, self.height-height, self.width, height)];
    }
    return _bottomView;
}

- (UIView *)transparentView{
    if(!_transparentView){
        _transparentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, CGRectGetMaxY(self.topView.frame), self.frame.size.width,self.frame.size.height - CGRectGetHeight(self.bottomView.frame) - CGRectGetHeight(self.topView.frame))];
        [_transparentView setBackgroundColor:UIColor(0xffffff, 0.5)];
    }
    return _transparentView;
}

-(void)setupUI{
    self.previewView = [[CCVideoPreview alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:self.previewView];
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
    //    [self addSubview:self.transparentView];
    [self addSubview:self.photoRectImgView];
    [self bindOperation];
    
}

- (void)bindOperation{
    @weakify(self);
    self.topView.rightButtonClick = ^{
        @strongify(self);
        if([self.delegate respondsToSelector:@selector(flashLightAction:handle:)]){
            [self.delegate flashLightAction:self handle:^(NSError *error) {
                
            }];
        }
    };
    
    self.bottomView.returnClick = ^{
        @strongify(self);
        if([self.delegate respondsToSelector:@selector(cancelAction:)]){
            [self.delegate cancelAction:self];
        }
    };
    
    self.bottomView.takePhotoClick = ^{
        @strongify(self);
        if([self.delegate respondsToSelector:@selector(takePhotoAction:)]){
            [self.delegate takePhotoAction:self];
        }
    };
    
    self.bottomView.switchPhotoClick = ^{
        @strongify(self);
        
        if ([self.delegate respondsToSelector:@selector(swicthCameraAction:animation:handle:)]) {
            [self.delegate swicthCameraAction:self animation:YES handle:^(NSError *error) {
                if (error){
                    [self showError:error];
                }
                
            }];
        }
        
    };
}



// 自动聚焦和曝光
-(void)focusAndExposureClick:(UIButton *)button {
    if ([_delegate respondsToSelector:@selector(autoFocusAndExposureAction:handle:)]) {
        [self runResetAnimation];
        [_delegate autoFocusAndExposureAction:self handle:^(NSError *error) {
            if (error) [self showError:error];
        }];
    }
}


// 取消
-(void)cancel:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(cancelAction:)]) {
        [_delegate cancelAction:self];
    }
}


// 转换摄像头
-(void)switchCameraClick:(UIButton *)btn {
    if ([_delegate respondsToSelector:@selector(swicthCameraAction:animation:handle:)]) {
        [_delegate swicthCameraAction:self animation:YES handle:^(NSError *error) {
            if (error) [self showError:error];
        }];
    }
}
#pragma mark - Private methods
// 聚焦、曝光动画
-(void)runFocusAnimation:(UIView *)view point:(CGPoint)point {
    view.center = point;
    view.hidden = NO;
    [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
    } completion:^(BOOL complete) {
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            view.hidden = YES;
            view.transform = CGAffineTransformIdentity;
        });
    }];
}

// 自动聚焦、曝光动画
- (void)runResetAnimation {
    self.focusView.center = CGPointMake(self.previewView.width/2, self.previewView.height/2);
    self.exposureView.center = CGPointMake(self.previewView.width/2, self.previewView.height/2);;
    self.exposureView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
    self.focusView.hidden = NO;
    self.focusView.hidden = NO;
    [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.focusView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
        self.exposureView.layer.transform = CATransform3DMakeScale(0.7, 0.7, 1.0);
    } completion:^(BOOL complete) {
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.focusView.hidden = YES;
            self.exposureView.hidden = YES;
            self.focusView.transform = CGAffineTransformIdentity;
            self.exposureView.transform = CGAffineTransformIdentity;
        });
    }];
}

- (UIImageView *)photoRectImgView{
    if (!_photoRectImgView) {
        _photoRectImgView = ({
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView setContentMode:UIViewContentModeScaleAspectFill];
            [imgView setClipsToBounds:YES];
            [imgView setImage:[UIImage imageNamed:@"ic_user_auth_all"]];
            [self addSubview:imgView];
            [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.left.mas_equalTo(self);
                make.bottom.mas_equalTo(self.bottomView.mas_top);
                make.top.mas_equalTo(self.topView.mas_bottom);
            }];
            imgView;
        });
    }
    return _photoRectImgView;
}

@end
