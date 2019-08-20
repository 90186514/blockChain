//
//  OfficialRemindPopUpView.h
//  gt
//
//  Created by Administrator on 16/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OfficialRemindPopUpView : UIView

- (void)actionBlock:(ActionBlock)block;
- (void)showInApplicationKeyWindow;
- (void)showInView:(UIView *)view;


@end

NS_ASSUME_NONNULL_END
