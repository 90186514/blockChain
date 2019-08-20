//
//  UIView+Extension.h
//  MJRefreshExample
//
//  Created by Aalto on 14-5-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ActionBlock)(id data);
@interface UIView (Extras)
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGFloat bottom;
@property (assign, nonatomic) CGFloat right;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint origin;
- (void)gradientLayerAboveView:(UIView*)view withShallowColor:(UIColor*)shallowC withDeepColor:(UIColor*)deepC isVerticalOrHorizontal:(BOOL)isVertical;
-(void)removeAllSubViews;

@property (nonatomic, copy) ActionBlock leftLittleButtonEventBlock;
@property (nonatomic, copy) ActionBlock leftButtonEventBlock;
@property (nonatomic, copy) ActionBlock rightButtonEventBlock;
- (void)loginRightButtonInSuperView:(UIView*)superView withTitle:(NSString*)title rightButtonEvent:(ActionBlock)rightButtonEventBlock;

- (void)goBackButtonInSuperView:(UIView*)superView leftButtonEvent:(ActionBlock)leftButtonEventBlock;

- (void)goBackBlackButtonInSuperView:(UIView*)superView leftButtonEvent:(ActionBlock)leftButtonEventBlock;

- (void)goBackEmptyContentButtonInSuperView:(UIView*)superView leftButtonEvent:(ActionBlock)leftButtonEventBlock;

- (UIView*)setDataEmptyViewInSuperView:(UIView*)superView withTopMargin:(NSInteger)topMargin withCustomTitle:(NSString*)customTitle;

- (UIView*)setDataEmptyViewInSuperView:(UIView*)superView withTopMargin:(NSInteger)topMargin;
- (UIView*)setServiceErrorViewInSuperView:(UIView*)superView leftButtonEvent:(ActionBlock)leftButtonEventBlock;
- (UIView*)setNetworkErrorViewInSuperView:(UIView*)superView leftButtonEvent:(ActionBlock)leftButtonEventBlock;
- (void)bottomSingleButtonInSuperView:(UIView*)superView WithButtionTitles:(NSString*)btnTitle withBottomMargin:(NSInteger)bottomMargin  isHidenLine:(BOOL)isHidenLine leftButtonEvent:(ActionBlock)leftButtonEventBlock;

- (void)bottomSingleButtonInSuperView:(UIView*)superView WithButtionTitles:(NSString*)btnTitle leftButtonEvent:(ActionBlock)leftButtonEventBlock;

- (void)bottomDoubleButtonInSuperView:(UIView*)superView WithButtionTitles:(NSArray*)btnTitles leftButtonEvent:(ActionBlock)leftButtonEventBlock rightButtonEvent:(ActionBlock)rightButtonEventBlock;

- (void)bottomDoubleButtonInSuperView:(UIView*)superView leftButtonEvent:(ActionBlock)leftButtonEventBlock rightButtonEvent:(ActionBlock)rightButtonEventBlock;

- (void)bottomTripleButtonInSuperView:(UIView*)superView leftLittleButtonEvent:(ActionBlock)leftLittleButtonEventBlock leftButtonEvent:(ActionBlock)leftButtonEventBlock rightButtonEvent:(ActionBlock)rightButtonEventBlock;
@end
