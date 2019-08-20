//
//  Buy_Payment_QRCodeTBVCell.h
//  gt
//
//  Created by Administrator on 03/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Buy_Payment_QRCodeTBVCell : UITableViewCell

@property(nonatomic,strong)OrderDetailModel *orderDetailModel;

@property(nonatomic,copy)void(^MyBlock)(PaywayType);

-(instancetype)initWithStyle:(UITableViewCellStyle)style
                paymentStyle:(PaywayType)paymentStyle
             reuseIdentifier:(NSString *)reuseIdentifier
                   orderType:(NSString *)orderType
                     dataDic:(NSDictionary *)dataDic;

@end

NS_ASSUME_NONNULL_END
