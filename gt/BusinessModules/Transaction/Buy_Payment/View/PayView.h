//
//  PostAdsView.h
//  gtp
//
//  Created by Aalto on 2018/12/23.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class PayView;

@protocol PayViewDelegate <NSObject>

@required

- (void)payView:(PayView *)view requestListWithPage:(NSInteger)page;

@end

@interface PayView : UIView

@property (nonatomic, weak) id<PayViewDelegate> delegate;
- (void)actionBlock:(TwoDataBlock)block;

- (void)requestListSuccessWithArray:(NSArray *)array WithPage:(NSInteger)page WithSec:(NSString*)sec;

- (void)requestListFailed;

@end

NS_ASSUME_NONNULL_END
