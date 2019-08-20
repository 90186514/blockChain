//
//  Buy_WaittingVC.h
//  gt
//
//  Created by Administrator on 03/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@class PayModel;

@interface Buy_WaittingVC : BaseVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(id)requestParams
                 withModel:(PayModel *)model
                 orderType:(OrderType)orderType
                   success:(DataBlock)block;

@end

NS_ASSUME_NONNULL_END
