//
//  VicAnimationPopTool.m
//  AiLiao
//
//  Created by Phil Xhc on 25/10/2017.
//  Copyright © 2017 AiLiao. All rights reserved.
//

#import "VicAnimationPopTool.h"
#import "VicCameraKit.h"

#define EmitterColor_Red      [UIColor colorWithRed:255/255.0 green:0 blue:139/255.0 alpha:1]
#define EmitterColor_Yellow   [UIColor colorWithRed:251/255.0 green:197/255.0 blue:13/255.0 alpha:1]
#define EmitterColor_Blue     [UIColor colorWithRed:50/255.0 green:170/255.0 blue:207/255.0 alpha:1]

@interface VicAnimationPopTool()<CAAnimationDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,weak)      UIView *view;                  //需要弹出的视图

@property (nonatomic,copy)      NSString *key;                 //key

@property (nonatomic,strong)      UIView *transparentView;       //添加的透明视图

@property (nonatomic,assign)      float animationTime;           //动画时间

@property (nonatomic,assign)      ViewStatus status;             //动画运行的状态

@property (nonatomic,assign)      AnimationOrientation orientation;   //动画方向

@end


@implementation VicAnimationPopTool

+ (instancetype)shareInstance{
    static VicAnimationPopTool *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VicAnimationPopTool alloc] init];
        instance.disappeared = YES;
        instance.appeared = NO;
    });
    return instance;
}

+ (void)animationCoverWindow:(UIView *)view duration:(float)duration orientation:(AnimationOrientation)orientation{
    [self animationShowView:view coverColor:RGBA16COLOR(0x000000, 0.3f) duration:duration orientation:orientation];
}

+ (void)animationCleanWindow:(UIView *)view time:(CGFloat)duration orientation:(AnimationOrientation)orientation{
    [self animationShowView:view coverColor:[UIColor clearColor] duration:duration orientation:orientation];
}

+ (void)animationShowView:(UIView *)view coverColor:(UIColor *)color duration:(CGFloat)duration orientation:(AnimationOrientation)orientation{
    VicAnimationPopTool *tool = [VicAnimationPopTool shareInstance];
    
    tool.transparentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, MAINSCREEN_WIDTH > MAINSCREEN_HEIGHT ? MAINSCREEN_WIDTH:MAINSCREEN_HEIGHT, MAINSCREEN_WIDTH > MAINSCREEN_HEIGHT ? MAINSCREEN_WIDTH:MAINSCREEN_HEIGHT)];
    [tool.transparentView setBackgroundColor:color];
    [[UIApplication sharedApplication].keyWindow addSubview:tool.transparentView];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    //其实设置初始状态.
    tool.status = ViewStatus_WillPop;
    tool.animationTime = duration > 0 ? duration : 0.3f;
    tool.view = view;
    tool.orientation = orientation;
    
    CGPoint toLocation;
    CABasicAnimation *basicAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
    NSString *key = [NSStringFromClass([view class]) stringByAppendingString:CurrentTimeStamp];
    tool.key = key;
    
    
    switch (tool.orientation) {
        case AnimationOrientation_Top:{
            toLocation = CGPointMake(view.frame.origin.x + view.frame.size.width/2, view.frame.size.height/2);
        }
            break;
        case AnimationOrientation_Left:{
            toLocation = CGPointMake(view.frame.size.width/2,view.frame.origin.y + view.frame.size.height/2);
        }
            break;
        case AnimationOrientation_Right:{
            toLocation = CGPointMake(VicScreenWidth - view.frame.size.width/2,view.frame.origin.y + view.frame.size.height/2);
        }
            break;
        case AnimationOrientation_Bottom:
        default:{
            toLocation = CGPointMake(view.frame.origin.x + view.frame.size.width/2, VicScreenHeight - view.frame.size.height/2);
        }
            break;
    }
    
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationPortrait:{
            [tool.transparentView setFrame:CGRectMake(0.f,0.f, VicScreenWidth, VicScreenHeight)];
        }
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:{
            [tool.transparentView setFrame:CGRectMake(view.frame.size.height/2,0, VicScreenWidth,VicScreenHeight)];
        }
            break;
        default:{
            
        }
            break;
    }
    
    basicAnimation.toValue = [NSValue valueWithCGPoint:toLocation];
    //设置其他动画属性
    basicAnimation.duration = duration > 0 ? duration : 0.3f;
    //运行一次是否移除动画
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.delegate = tool;
    basicAnimation.fillMode = kCAFillModeForwards;
    //存储当前位置在动画结束后使用
    [basicAnimation setValue:[NSValue valueWithCGPoint:toLocation] forKey:key];
    
    [view.layer addAnimation:basicAnimation forKey:key];

}

+ (void)animationDismissView:(UIView *)view duration:(float)time orientation:(AnimationOrientation)orientation{
    VicAnimationPopTool *tool = [VicAnimationPopTool shareInstance];
    if (!view || tool.key.length == 0) {
        return;
    }
    tool.status = ViewStatus_WillDismiss;
    tool.orientation = orientation;
    tool.animationTime = time;
    NSString *key = [NSStringFromClass([view class]) stringByAppendingString:CurrentTimeStamp];
    tool.key = key;
    CGPoint toLocation;
    CABasicAnimation *basicAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
    
    switch (tool.orientation) {
        case AnimationOrientation_Top:{
            toLocation = CGPointMake(view.frame.origin.x + view.frame.size.width/2, -view.frame.size.height/2);
        }
            break;
        case AnimationOrientation_Left:{
            toLocation = CGPointMake(-view.frame.size.width/2,view.frame.origin.y + view.frame.size.height/2);
        }
            break;
        case AnimationOrientation_Right:{
            toLocation = CGPointMake(VicScreenWidth + view.frame.size.width/2,view.frame.origin.y + view.frame.size.height/2);
        }
            break;
        case AnimationOrientation_Bottom:
        default:{
            toLocation = CGPointMake(view.frame.origin.x + view.frame.size.width/2, VicScreenHeight + view.frame.size.height/2);
        }
            break;
    }
    
    basicAnimation.toValue = [NSValue valueWithCGPoint:toLocation];
    basicAnimation.duration = time > 0 ? time : 0.3f;
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.delegate= tool;
    [basicAnimation setValue:[NSValue valueWithCGPoint:toLocation] forKey:key];
    basicAnimation.fillMode = kCAFillModeForwards;
    
    [view.layer addAnimation:basicAnimation forKey:key];
}

#pragma mark -
#pragma mark CAAnimationDelegate

- (void)tapTransparent{
    [VicAnimationPopTool animationDismissView:self.view duration:self.animationTime orientation:self.orientation];
}

- (void)animationDidStart:(CAAnimation *)anim{
    self.view.userInteractionEnabled = NO;
    //动画开始,若是弹出
    if (self.status == ViewStatus_WillPop) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTransparent)];
        tap.enabled = NO;
        [self.transparentView addGestureRecognizer:tap];
        if(self.delegate && [self.delegate respondsToSelector:@selector(viewWillPop:)]){
            [self.delegate viewWillPop:self.view];
        }
    }
    //动画开始,若是消失
    else if(self.status == ViewStatus_WillDismiss){
        UITapGestureRecognizer *tap = [self.transparentView.gestureRecognizers firstObject];
        tap.enabled = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(viewWillDismiss:)]) {
            [self.delegate viewWillDismiss:self.view];
        }
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    self.view.userInteractionEnabled = YES;
    [CATransaction begin];                      //开启事务
    [CATransaction setDisableActions:YES];      //禁用隐式动画
    self.view.layer.position = [[anim valueForKey:self.key] CGPointValue];      //固定position
    [CATransaction commit];                                                     //提交事务
    [self.view.layer removeAnimationForKey:self.key];
    
    if (self.status == ViewStatus_WillPop) {
        self.status = ViewStatus_CompletePop;
        if(self.delegate && [self.delegate respondsToSelector:@selector(viewDidPop:)]){
            [self.delegate viewDidPop:self.view];
        }
    }
    else if(self.status == ViewStatus_WillDismiss){
        self.status = ViewStatus_CompleteDismiss;
        [self.transparentView removeFromSuperview];
        self.transparentView = nil;
        [self.view removeFromSuperview];
        if(self.delegate && [self.delegate respondsToSelector:@selector(viewDidDismiss:)]){
            [self.delegate viewDidDismiss:self.view];
        }
        self.view = nil;
    }
    UITapGestureRecognizer *tap = [self.transparentView.gestureRecognizers firstObject];
    tap.enabled = YES;
}

+ (void)centerShowAnimation:(UIView *)view duration:(CGFloat)duration{
    view.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    [view setAlpha:1.f];
    [UIView animateWithDuration:duration
                     animations:^{
                         view.transform = CGAffineTransformMakeScale(1.f, 1.f);
                     }completion:^(BOOL finish){
                         
                         [UIView animateWithDuration:duration
                                          animations:^{
                                              view.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
                                          }completion:^(BOOL finish){
                                              view.transform = CGAffineTransformMakeScale(0.f, 0.f);
                                              [view setAlpha:0.f];
                                          }];
                     }];
}


- (void)showCenter:(UIView *)view{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:window.bounds];
    backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [window addSubview:backgroundView];
    
    [view setCenter:CGPointMake(window.bounds.size.width/2, window.bounds.size.height/2)];
    [backgroundView addSubview:view];
    
    //缩放
    view.transform=CGAffineTransformMakeScale(0.01f, 0.01f);
    view.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        view.alpha = 1;
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHideClick:)];
    [tap setDelegate:self];
    [backgroundView addGestureRecognizer:tap];
}

- (void)tapHideClick:(UITapGestureRecognizer *)tap{
    UIView *view = [[tap.view subviews] firstObject];
    [UIView animateWithDuration:0.4 animations:^{
        view.transform = CGAffineTransformMakeScale(.3f, .3f);
        view.alpha = 0;
    }completion:^(BOOL finished) {
        [tap.view removeFromSuperview];
    }];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    UIView *view = [[gestureRecognizer.view subviews] firstObject];
    if ([touch.view isDescendantOfView:view]) {
        return NO;
    }
    return YES;
}

+ (void)show:(UIView *)giftView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:window.bounds];
    backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [window addSubview:backgroundView];
    
    [backgroundView addSubview:giftView];
    
    //缩放
    giftView.transform=CGAffineTransformMakeScale(0.01f, 0.01f);
    giftView.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        
        giftView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        giftView.alpha = 1;
    }];
    
    //3s 消失
    double delayInSeconds = 3.0;
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delayInNanoSeconds, dispatch_get_main_queue(), ^(void){
        
        [UIView animateWithDuration:0.4 animations:^{
            
            giftView.transform = CGAffineTransformMakeScale(.3f, .3f);
            giftView.alpha = 0;
            
        }completion:^(BOOL finished) {
            
            [backgroundView removeFromSuperview];
        }];
    });
    
//    开始粒子效果
    CAEmitterLayer *emitterLayer = addEmitterLayer(backgroundView,giftView);
    startAnimate(emitterLayer);
}

+ (void)showAnimationPopView:(UIView *)view duration:(float)time orientation:(AnimationOrientation)orientation{
    VicAnimationPopTool *tool = [VicAnimationPopTool shareInstance];
    tool.transparentView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 0.f, VicScreenWidth > VicScreenHeight ? VicScreenWidth:VicScreenHeight, VicScreenWidth > VicScreenHeight ? VicScreenWidth:VicScreenHeight)];
    [tool.transparentView setBackgroundColor:RGBA16COLOR(0x000000, 0.6)];
    [[UIApplication sharedApplication].keyWindow addSubview:tool.transparentView];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
    //其实设置初始状态.
    tool.status = ViewStatus_WillPop;
    tool.animationTime = 0.3f;
    tool.view = view;
    tool.orientation = orientation;
    
    CGPoint toLocation;
    CABasicAnimation *basicAnimation=[CABasicAnimation animationWithKeyPath:@"position"];
    NSString *key = [NSStringFromClass([view class]) stringByAppendingString:CurrentTimeStamp];
    tool.key = key;
    toLocation = CGPointMake(view.frame.origin.x + view.frame.size.width/2, view.frame.size.height/2 + 128.f);
    
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationFaceUp:
        case UIDeviceOrientationPortrait:{
            [tool.transparentView setFrame:CGRectMake(0.f,0.f, VicScreenWidth, VicScreenHeight)];
        }
            break;
        case UIDeviceOrientationLandscapeLeft:
        case UIDeviceOrientationLandscapeRight:{
            [tool.transparentView setFrame:CGRectMake(view.frame.size.height/2,0, VicScreenWidth,VicScreenHeight)];
        }
            break;
        default:{
            
        }
            break;
    }
    
    basicAnimation.toValue = [NSValue valueWithCGPoint:toLocation];
    //设置其他动画属性
    basicAnimation.duration = 0.3f;
    //运行一次是否移除动画
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.delegate = tool;
    basicAnimation.fillMode = kCAFillModeForwards;
    //存储当前位置在动画结束后使用
    [basicAnimation setValue:[NSValue valueWithCGPoint:toLocation] forKey:key];
    
    [view.layer addAnimation:basicAnimation forKey:key];

}


CAEmitterLayer *addEmitterLayer(UIView *view,UIView *window)
{
    
    //色块粒子
    CAEmitterCell *subCell1 = subCell(imageWithColor(EmitterColor_Red));
    subCell1.name = @"red";
    CAEmitterCell *subCell2 = subCell(imageWithColor(EmitterColor_Yellow));
    subCell2.name = @"yellow";
    CAEmitterCell *subCell3 = subCell(imageWithColor(EmitterColor_Blue));
    subCell3.name = @"blue";
    CAEmitterCell *subCell4 = subCell([UIImage imageNamed:@"success_star"]);
    subCell4.name = @"star";
    
    CAEmitterLayer *emitterLayer = [CAEmitterLayer layer];
    emitterLayer.emitterPosition = window.center;
    emitterLayer.emitterPosition = window.center;
    emitterLayer.emitterSize    = window.bounds.size;
    emitterLayer.emitterMode    = kCAEmitterLayerOutline;
    emitterLayer.emitterShape    = kCAEmitterLayerRectangle;
    emitterLayer.renderMode        = kCAEmitterLayerOldestFirst;
    
    emitterLayer.emitterCells = @[subCell1,subCell2,subCell3,subCell4];
    [view.layer addSublayer:emitterLayer];
    
    return emitterLayer;
    
}

void startAnimate(CAEmitterLayer *emitterLayer)
{
    CABasicAnimation *redBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.red.birthRate"];
    redBurst.fromValue        = [NSNumber numberWithFloat:30];
    redBurst.toValue            = [NSNumber numberWithFloat:  0.0];
    redBurst.duration        = 0.5;
    redBurst.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *yellowBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.yellow.birthRate"];
    yellowBurst.fromValue        = [NSNumber numberWithFloat:30];
    yellowBurst.toValue            = [NSNumber numberWithFloat:  0.0];
    yellowBurst.duration        = 0.5;
    yellowBurst.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *blueBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.blue.birthRate"];
    blueBurst.fromValue        = [NSNumber numberWithFloat:30];
    blueBurst.toValue            = [NSNumber numberWithFloat:  0.0];
    blueBurst.duration        = 0.5;
    blueBurst.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CABasicAnimation *starBurst = [CABasicAnimation animationWithKeyPath:@"emitterCells.star.birthRate"];
    starBurst.fromValue        = [NSNumber numberWithFloat:30];
    starBurst.toValue            = [NSNumber numberWithFloat:  0.0];
    starBurst.duration        = 0.5;
    starBurst.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[redBurst,yellowBurst,blueBurst,starBurst];
    
    [emitterLayer addAnimation:group forKey:@"heartsBurst"];
}

CAEmitterCell *subCell(UIImage *image)
{
    CAEmitterCell * cell = [CAEmitterCell emitterCell];
    
    cell.name = @"heart";
    cell.contents = (__bridge id _Nullable)image.CGImage;
    
    // 缩放比例
    cell.scale      = 0.6;
    cell.scaleRange = 0.6;
    // 每秒产生的数量
    //    cell.birthRate  = 40;
    cell.lifetime   = 20;
    // 每秒变透明的速度
    //    snowCell.alphaSpeed = -0.7;
    //    snowCell.redSpeed = 0.1;
    // 秒速
    cell.velocity      = 200;
    cell.velocityRange = 200;
    cell.yAcceleration = 9.8;
    cell.xAcceleration = 0;
    //掉落的角度范围
    cell.emissionRange  = M_PI;
    
    cell.scaleSpeed        = -0.05;
    ////    cell.alphaSpeed        = -0.3;
    cell.spin            = 2 * M_PI;
    cell.spinRange        = 2 * M_PI;
    
    return cell;
}

UIImage *imageWithColor(UIColor *color)
{
    CGRect rect = CGRectMake(0, 0, 13, 17);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}




@end
