//
//  VicClipPhotoView.m
//  VicCameraKit
//
//  Created by Dodgson on 2018/11/29.
//  Copyright © 2018 Dodgson. All rights reserved.
//

#import "VicClipPhotoView.h"
#import <Masonry/Masonry.h>
#import "YasicClipAreaLayer.h"
#import "YasicPanGestureRecognizer.h"
#import "VicAnimationPopTool.h"
#import "VicCameraKit.h"



typedef NS_ENUM(NSInteger, ACTIVEGESTUREVIEW) {
    CROPVIEWLEFT,
    CROPVIEWRIGHT,
    CROPVIEWTOP,
    CROPVIEWBOTTOM,
    BIGIMAGEVIEW
};


@interface VicClipPhotoView()

@property (nonatomic, strong) UIView *topBgView;

@property (nonatomic, strong) UIView *bottomBgView;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) UIImageView *clipLimitImgView;

@property (strong, nonatomic) UIImage *targetImage;
@property(strong, nonatomic) UIImageView *bigImageView;
@property(strong, nonatomic) UIView *cropView;

@property(assign, nonatomic) ACTIVEGESTUREVIEW activeGestureView;

// 图片 view 原始 frame
@property(assign, nonatomic) CGRect originalFrame;

// 裁剪区域属性
@property(assign, nonatomic) CGFloat cropAreaX;
@property(assign, nonatomic) CGFloat cropAreaY;
@property(assign, nonatomic) CGFloat cropAreaWidth;
@property(assign, nonatomic) CGFloat cropAreaHeight;

@property(nonatomic, assign) CGFloat clipHeight;
@property(nonatomic, assign) CGFloat clipWidth;


@end

@implementation VicClipPhotoView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self topBgView];
        [self bottomBgView];
        [self cancelBtn];
        [self confirmBtn];
        [self clipLimitImgView];
        
    }
    return self;
}

- (void)updateViewWith:(UIImage *)image{
    self.targetImage = image;
    [self viewDidLoad];
    [self viewWillAppear:YES];
    [self viewDidAppear:YES];
    
    [self bringSubviewToFront:self.topBgView];
    [self bringSubviewToFront:self.bottomBgView];
    [self bringSubviewToFront:self.clipLimitImgView];
}

- (void)cancelClick{
    [VicAnimationPopTool animationDismissView:self duration:0.3f orientation:AnimationOrientation_Right];
}

- (void)confirmClick{
    [VicAnimationPopTool animationDismissView:self duration:0.3f orientation:AnimationOrientation_Right];
    UIImage *image = [self cropImage];
}

- (void)viewDidLoad {

//    self.backgroundColor = [UIColor whiteColor];
//    self.targetImage = [UIImage imageNamed:@"TARGET_IMG"];
    
    self.clipWidth = MAINSCREEN_WIDTH;
    self.clipHeight = MAINSCREEN_WIDTH * 9/16;
    
    self.cropAreaX = 48.f;
    self.cropAreaY = 50.f + 64.f;
    self.cropAreaWidth = MAINSCREEN_WIDTH - 96.f;
    self.cropAreaHeight = MAINSCREEN_WIDTH - 96.f;
    
    self.bigImageView.image = self.targetImage;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self addSubview:self.cropView];
    [self addSubview:self.bigImageView];
    [self.cropView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    
    CGFloat tempWidth = 0.0;
    CGFloat tempHeight = 0.0;
    
    if (self.targetImage.size.width/self.cropAreaWidth <= self.targetImage.size.height/self.cropAreaHeight) {
        tempWidth = self.cropAreaWidth;
        tempHeight = (tempWidth/self.targetImage.size.width) * self.targetImage.size.height;
    } else if (self.targetImage.size.width/self.cropAreaWidth > self.targetImage.size.height/self.cropAreaHeight) {
        tempHeight = self.cropAreaHeight;
        tempWidth = (tempHeight/self.targetImage.size.height) * self.targetImage.size.width;
    }
    
    [self.bigImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0.f);
        make.top.mas_equalTo(0.f);
        make.width.mas_equalTo(MAINSCREEN_WIDTH);
        make.height.mas_equalTo(MAINSCREEN_HEIGHT);
    }];
    self.originalFrame = self.bounds;
    [self addAllGesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self setUpCropLayer];
}

-(void)addAllGesture
{
    // 捏合手势
    UIPinchGestureRecognizer *pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handleCenterPinGesture:)];
    [self addGestureRecognizer:pinGesture];
    
    // 拖动手势
    YasicPanGestureRecognizer *panGesture = [[YasicPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleDynamicPanGesture:) inview:self.cropView];
    [self.cropView addGestureRecognizer:panGesture];
}

-(void)handleDynamicPanGesture:(YasicPanGestureRecognizer *)panGesture
{
    UIView * view = self.bigImageView;
    CGPoint translation = [panGesture translationInView:view.superview];
    
    CGPoint beginPoint = panGesture.beginPoint;
    CGPoint movePoint = panGesture.movePoint;
    CGFloat judgeWidth = 20;
    
    // 开始滑动时判断滑动对象是 ImageView 还是 Layer 上的 Line
    if (panGesture.state == UIGestureRecognizerStateBegan) {
        if (beginPoint.x >= self.cropAreaX - judgeWidth && beginPoint.x <= self.cropAreaX + judgeWidth && beginPoint.y >= self.cropAreaY && beginPoint.y <= self.cropAreaY + self.cropAreaHeight && self.cropAreaWidth >= 50) {
            return;
            self.activeGestureView = CROPVIEWLEFT;
        } else if (beginPoint.x >= self.cropAreaX + self.cropAreaWidth - judgeWidth && beginPoint.x <= self.cropAreaX + self.cropAreaWidth + judgeWidth && beginPoint.y >= self.cropAreaY && beginPoint.y <= self.cropAreaY + self.cropAreaHeight &&  self.cropAreaWidth >= 50) {
            return;
            self.activeGestureView = CROPVIEWRIGHT;
        } else if (beginPoint.y >= self.cropAreaY - judgeWidth && beginPoint.y <= self.cropAreaY + judgeWidth && beginPoint.x >= self.cropAreaX && beginPoint.x <= self.cropAreaX + self.cropAreaWidth && self.cropAreaHeight >= 50) {
            return;
            self.activeGestureView = CROPVIEWTOP;
        } else if (beginPoint.y >= self.cropAreaY + self.cropAreaHeight - judgeWidth && beginPoint.y <= self.cropAreaY + self.cropAreaHeight + judgeWidth && beginPoint.x >= self.cropAreaX && beginPoint.x <= self.cropAreaX + self.cropAreaWidth && self.cropAreaHeight >= 50) {
            return;
            self.activeGestureView = CROPVIEWBOTTOM;
        } else {
            self.activeGestureView = BIGIMAGEVIEW;
            [view setCenter:CGPointMake(view.center.x + translation.x, view.center.y + translation.y)];
            [panGesture setTranslation:CGPointZero inView:view.superview];
        }
    }
    
    // 滑动过程中进行位置改变
    if (panGesture.state == UIGestureRecognizerStateChanged) {
        CGFloat diff = 0;
        switch (self.activeGestureView) {
            case CROPVIEWLEFT: {
                diff = movePoint.x - self.cropAreaX;
                if (diff >= 0 && self.cropAreaWidth > 50) {
                    return;
                    self.cropAreaWidth -= diff;
                    self.cropAreaX += diff;
                } else if (diff < 0 && self.cropAreaX > self.bigImageView.frame.origin.x && self.cropAreaX >= 15) {
                    return;
                    self.cropAreaWidth -= diff;
                    self.cropAreaX += diff;
                }
                [self setUpCropLayer];
                break;
            }
            case CROPVIEWRIGHT: {
                diff = movePoint.x - self.cropAreaX - self.cropAreaWidth;
                if (diff >= 0 && (self.cropAreaX + self.cropAreaWidth) < MIN(self.bigImageView.frame.origin.x + self.bigImageView.frame.size.width, self.cropView.frame.origin.x + self.cropView.frame.size.width - 15)){
                    return;
                    self.cropAreaWidth += diff;
                } else if (diff < 0 && self.cropAreaWidth >= 50) {
                    return;
                    self.cropAreaWidth += diff;
                }
                [self setUpCropLayer];
                break;
            }
            case CROPVIEWTOP: {
                diff = movePoint.y - self.cropAreaY;
                if (diff >= 0 && self.cropAreaHeight > 50) {
                    return;
                    self.cropAreaHeight -= diff;
                    self.cropAreaY += diff;
                } else if (diff < 0 && self.cropAreaY > self.bigImageView.frame.origin.y && self.cropAreaY >= 15) {
                    return;
                    self.cropAreaHeight -= diff;
                    self.cropAreaY += diff;
                }
                [self setUpCropLayer];
                break;
            }
            case CROPVIEWBOTTOM: {
                diff = movePoint.y - self.cropAreaY - self.cropAreaHeight;
                if (diff >= 0 && (self.cropAreaY + self.cropAreaHeight) < MIN(self.bigImageView.frame.origin.y + self.bigImageView.frame.size.height, self.cropView.frame.origin.y + self.cropView.frame.size.height - 15)){
                    return;
                    self.cropAreaHeight += diff;
                } else if (diff < 0 && self.cropAreaHeight >= 50) {
                    return;
                    self.cropAreaHeight += diff;
                }
                [self setUpCropLayer];
                break;
            }
            case BIGIMAGEVIEW: {
                [view setCenter:CGPointMake(view.center.x + translation.x, view.center.y + translation.y)];
                [panGesture setTranslation:CGPointZero inView:view.superview];
                break;
            }
            default:
                break;
        }
    }
    
    // 滑动结束后进行位置修正
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        switch (self.activeGestureView) {
            case CROPVIEWLEFT: {
                if (self.cropAreaWidth < 50) {
                    self.cropAreaX -= 50 - self.cropAreaWidth;
                    self.cropAreaWidth = 50;
                }
                if (self.cropAreaX < MAX(self.bigImageView.frame.origin.x, 15)) {
                    CGFloat temp = self.cropAreaX + self.cropAreaWidth;
                    self.cropAreaX = MAX(self.bigImageView.frame.origin.x, 15);
                    self.cropAreaWidth = temp - self.cropAreaX;
                }
                [self setUpCropLayer];
                break;
            }
            case CROPVIEWRIGHT: {
                if (self.cropAreaWidth < 50) {
                    self.cropAreaWidth = 50;
                }
                if (self.cropAreaX + self.cropAreaWidth > MIN(self.bigImageView.frame.origin.x + self.bigImageView.frame.size.width, self.cropView.frame.origin.x + self.cropView.frame.size.width - 15)) {
                    self.cropAreaWidth = MIN(self.bigImageView.frame.origin.x + self.bigImageView.frame.size.width, self.cropView.frame.origin.x + self.cropView.frame.size.width - 15) - self.cropAreaX;
                }
                [self setUpCropLayer];
                break;
            }
            case CROPVIEWTOP: {
                if (self.cropAreaHeight < 50) {
                    self.cropAreaY -= 50 - self.cropAreaHeight;
                    self.cropAreaHeight = 50;
                }
                if (self.cropAreaY < MAX(self.bigImageView.frame.origin.y, 15)) {
                    CGFloat temp = self.cropAreaY + self.cropAreaHeight;
                    self.cropAreaY = MAX(self.bigImageView.frame.origin.y, 15);
                    self.cropAreaHeight = temp - self.cropAreaY;
                }
                [self setUpCropLayer];
                break;
            }
            case CROPVIEWBOTTOM: {
                if (self.cropAreaHeight < 50) {
                    self.cropAreaHeight = 50;
                }
                if (self.cropAreaY + self.cropAreaHeight > MIN(self.bigImageView.frame.origin.y + self.bigImageView.frame.size.height, self.cropView.frame.origin.y + self.cropView.frame.size.height - 15)) {
                    self.cropAreaHeight = MIN(self.bigImageView.frame.origin.y + self.bigImageView.frame.size.height, self.cropView.frame.origin.y + self.cropView.frame.size.height - 15) - self.cropAreaY;
                }
                [self setUpCropLayer];
                break;
            }
            case BIGIMAGEVIEW: {
                CGRect currentFrame = view.frame;
                
                if (currentFrame.origin.x >= self.cropAreaX) {
                    currentFrame.origin.x = self.cropAreaX;
                    
                }
                if (currentFrame.origin.y >= self.cropAreaY) {
                    currentFrame.origin.y = self.cropAreaY;
                }
                if (currentFrame.size.width + currentFrame.origin.x < self.cropAreaX + self.cropAreaWidth) {
                    CGFloat movedLeftX = fabs(currentFrame.size.width + currentFrame.origin.x - (self.cropAreaX + self.cropAreaWidth));
                    currentFrame.origin.x += movedLeftX;
                }
                if (currentFrame.size.height + currentFrame.origin.y < self.cropAreaY + self.cropAreaHeight) {
                    CGFloat moveUpY = fabs(currentFrame.size.height + currentFrame.origin.y - (self.cropAreaY + self.cropAreaHeight));
                    currentFrame.origin.y += moveUpY;
                }
                [UIView animateWithDuration:0.3 animations:^{
                    
                    [view setFrame:currentFrame];
                }];
                break;
            }
            default:
                break;
        }
    }
}

-(void)handleCenterPinGesture:(UIPinchGestureRecognizer *)pinGesture
{
    CGFloat scaleRation = 3;
    UIView * view = self.bigImageView;
    
    // 缩放开始与缩放中
    if (pinGesture.state == UIGestureRecognizerStateBegan || pinGesture.state == UIGestureRecognizerStateChanged) {
        // 移动缩放中心到手指中心
        CGPoint pinchCenter = [pinGesture locationInView:view.superview];
        CGFloat distanceX = view.frame.origin.x - pinchCenter.x;
        CGFloat distanceY = view.frame.origin.y - pinchCenter.y;
        CGFloat scaledDistanceX = distanceX * pinGesture.scale;
        CGFloat scaledDistanceY = distanceY * pinGesture.scale;
        CGRect newFrame = CGRectMake(view.frame.origin.x + scaledDistanceX - distanceX, view.frame.origin.y + scaledDistanceY - distanceY, view.frame.size.width * pinGesture.scale, view.frame.size.height * pinGesture.scale);
        view.frame = newFrame;
        pinGesture.scale = 1;
    }
    
    // 缩放结束
    if (pinGesture.state == UIGestureRecognizerStateEnded) {
        CGFloat ration =  view.frame.size.width / self.originalFrame.size.width;
        
        // 缩放过大
        if (ration > 5) {
            CGRect newFrame = CGRectMake(0, 0, self.originalFrame.size.width * scaleRation, self.originalFrame.size.height * scaleRation);
            view.frame = newFrame;
        }
        
        // 缩放过小
        if (ration < 0.25) {
            view.frame = self.originalFrame;
        }
        // 对图片进行位置修正
        CGRect resetPosition = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, view.frame.size.height);
        
        if (resetPosition.origin.x >= self.cropAreaX) {
            resetPosition.origin.x = self.cropAreaX;
        }
        if (resetPosition.origin.y >= self.cropAreaY) {
            resetPosition.origin.y = self.cropAreaY;
        }
        if (resetPosition.size.width + resetPosition.origin.x < self.cropAreaX + self.cropAreaWidth) {
            CGFloat movedLeftX = fabs(resetPosition.size.width + resetPosition.origin.x - (self.cropAreaX + self.cropAreaWidth));
            resetPosition.origin.x += movedLeftX;
        }
        if (resetPosition.size.height + resetPosition.origin.y < self.cropAreaY + self.cropAreaHeight) {
            CGFloat moveUpY = fabs(resetPosition.size.height + resetPosition.origin.y - (self.cropAreaY + self.cropAreaHeight));
            resetPosition.origin.y += moveUpY;
        }
        view.frame = resetPosition;
        
        // 对图片缩放进行比例修正，防止过小
        if (self.cropAreaX < self.bigImageView.frame.origin.x
            || ((self.cropAreaX + self.cropAreaWidth) > self.bigImageView.frame.origin.x + self.bigImageView.frame.size.width)
            || self.cropAreaY < self.bigImageView.frame.origin.y
            || ((self.cropAreaY + self.cropAreaHeight) > self.bigImageView.frame.origin.y + self.bigImageView.frame.size.height)) {
            view.frame = self.originalFrame;
        }
    }
}

// 裁剪图片并调用返回Block
- (UIImage *)cropImage
{
    CGFloat imageScale = MIN(self.bigImageView.frame.size.width/self.targetImage.size.width, self.bigImageView.frame.size.height/self.targetImage.size.height);
    CGFloat cropX = (self.cropAreaX - self.bigImageView.frame.origin.x)/imageScale;
    CGFloat cropY = (self.cropAreaY - self.bigImageView.frame.origin.y)/imageScale;
    CGFloat cropWidth = self.cropAreaWidth/imageScale;
    CGFloat cropHeight = self.cropAreaHeight/imageScale;
    CGRect cropRect = CGRectMake(cropX, cropY, cropWidth -5 , cropHeight -5);
    
    UIImage *originImage = [self fixOrientation:self.targetImage];
    CGImageRef sourceImageRef = [originImage CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, cropRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}

- (void)setUpCropLayer
{
    self.cropView.layer.sublayers = nil;
    YasicClipAreaLayer * layer = [[YasicClipAreaLayer alloc] init];
    
    CGRect cropframe = CGRectMake(self.cropAreaX, self.cropAreaY, self.cropAreaWidth, self.cropAreaHeight);
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0.f, 0.f, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT) cornerRadius:0];
    UIBezierPath * cropPath = [UIBezierPath bezierPathWithRect:cropframe];
    [path appendPath:cropPath];
    layer.path = path.CGPath;
    
    layer.fillRule = kCAFillRuleEvenOdd;
    layer.fillColor = [[UIColor whiteColor] CGColor];
    layer.opacity = 0.5;
    
    layer.frame = self.cropView.bounds;
    [layer setCropAreaLeft:self.cropAreaX CropAreaTop:self.cropAreaY CropAreaRight:self.cropAreaX + self.cropAreaWidth CropAreaBottom:self.cropAreaY + self.cropAreaHeight];
    
    
    [self.cropView.layer addSublayer:layer];
    [self bringSubviewToFront:self.cropView];
}

- (UIImageView *)bigImageView
{
    if (!_bigImageView) {
        _bigImageView = [[UIImageView alloc] init];
        _bigImageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _bigImageView;
}

- (UIView *)cropView
{
    if (!_cropView) {
        _cropView = [[UIView alloc] init];
    }
    return _cropView;
}


- (UIImageView *)clipLimitImgView
{
    if (!_clipLimitImgView) {
        _clipLimitImgView = [[UIImageView alloc] initWithFrame:CGRectMake(48.f,50.f+64.f,MAINSCREEN_WIDTH - 96.f, MAINSCREEN_WIDTH - 96.f)];
        [_clipLimitImgView setImage:[UIImage imageNamed:@"photoRect"]];
        [self addSubview:_clipLimitImgView];
    }
    return _clipLimitImgView;
}




- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(40.f, self.bottomBgView.frame.size.height/2 - 35.f, 70.f, 70.f)];
            [self.bottomBgView addSubview:button];
            [button setImage:[UIImage imageNamed:@"cancelBtn"] forState:0];
            [button addTarget:self action:@selector(cancelClick) forControlEvents:1<<6];
            button;
        });
    }
    return _cancelBtn;
}

- (UIButton *)confirmBtn{
    if (!_confirmBtn) {
        _confirmBtn = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(self.frame.size.width - 40.f - 70.f, self.bottomBgView.frame.size.height/2 - 35.f, 70.f, 70.f)];
            [self.bottomBgView addSubview:button];
            [button setImage:[UIImage imageNamed:@"confirmBtn"] forState:0];
            [button addTarget:self action:@selector(confirmClick) forControlEvents:1<<6];
            button;
        });
    }
    return _confirmBtn;
}

- (UIView *)topBgView{
    if(!_topBgView){
        _topBgView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, self.frame.size.width, 64.f)];
        [_topBgView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_topBgView];
    }
    return _topBgView;
}

- (UIView *)bottomBgView{
    if(!_bottomBgView){
        _bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(0.f, self.frame.size.height - 130.f, self.frame.size.width, 130.f)];
        [_bottomBgView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_bottomBgView];
    }
    return _bottomBgView;
}

- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}



@end
