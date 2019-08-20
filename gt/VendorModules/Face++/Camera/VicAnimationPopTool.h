//
//  VicAnimationPopTool.h
//  AiLiao
//
//  Created by Phil Xhc on 25/10/2017.
//  Copyright © 2017 AiLiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AnimationToolProtocol.h"

@interface VicAnimationPopTool : NSObject

@property (nonatomic,assign) BOOL appeared;

@property (nonatomic,assign) BOOL disappeared;

@property (nonatomic,weak)     id<AnimationToolProtocol> delegate;

+ (void)animationCoverWindow:(UIView *)view duration:(float)duration orientation:(AnimationOrientation)orientation;

+ (void)animationCleanWindow:(UIView *)view time:(CGFloat)duration orientation:(AnimationOrientation)orientation;

+ (void)animationShowView:(UIView *)view
               coverColor:(UIColor *)color
                 duration:(CGFloat)duration
              orientation:(AnimationOrientation)orientation;

+ (void)animationDismissView:(UIView *)view duration:(float)time orientation:(AnimationOrientation)orientation;

+ (void)show:(UIView *)giftView;

- (void)showCenter:(UIView *)view;

+ (instancetype)shareInstance;

+ (void)showAnimationPopView:(UIView *)view duration:(float)time orientation:(AnimationOrientation)orientation;

@end
