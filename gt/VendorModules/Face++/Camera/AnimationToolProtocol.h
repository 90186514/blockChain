//
//  AnimationToolProtocol.h
//  OSLive
//
//  Created by xhc on 9/26/16.
//  Copyright © 2016 gltrip. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define CurrentTimeStamp [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSinceReferenceDate]]

typedef NS_ENUM(NSInteger, AnimationOrientation){
    AnimationOrientation_Left  = 1,
    AnimationOrientation_Right = 2,
    AnimationOrientation_Top   = 3,
    AnimationOrientation_Bottom= 4,
};

typedef NS_ENUM(NSInteger, ViewStatus){
    ViewStatus_WillPop = 1,
    ViewStatus_Poping  = 2,
    ViewStatus_CompletePop = 3,
    ViewStatus_WillDismiss = 4,
    ViewStatus_Dismissing  = 5,
    ViewStatus_CompleteDismiss = 6,
};

@protocol AnimationToolProtocol <NSObject>

@optional;

- (void)viewWillPop:(UIView *)view;

- (void)viewWillDismiss:(UIView *)view;

- (void)viewDidPop:(UIView *)view;

- (void)viewDidDismiss:(UIView *)view;


@end
