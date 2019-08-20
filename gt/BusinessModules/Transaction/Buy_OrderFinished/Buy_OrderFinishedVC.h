//
//  Buy_FinishedVC.h
//  gt
//
//  Created by Administrator on 04/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "BaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@class PayModel;

@interface Buy_OrderFinishedVC : BaseVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC
             requestParams:(id)requestParams
              withPayModel:(PayModel *)model
                   success:(DataBlock)block;

@end

NS_ASSUME_NONNULL_END
