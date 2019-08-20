//
//  VertifyVC.h
//  gt
//
//  Created by GT on 2019/1/18.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface VertifyVC : UIViewController
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block;
- (void)actionBlock:(ActionBlock)block;
@end

NS_ASSUME_NONNULL_END
