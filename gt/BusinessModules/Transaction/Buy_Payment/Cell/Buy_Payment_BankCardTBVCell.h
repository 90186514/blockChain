//
//  Buy_Payment_BankCardTBVCell.h
//  gt
//
//  Created by Administrator on 05/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Buy_Payment_BankCardTBVCell : UITableViewCell

@property(nonatomic,strong)OrderDetailModel *orderDetailModel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                   orderType:(NSString *)orderType
                     dataDic:(NSDictionary *)dataDic;

@end

NS_ASSUME_NONNULL_END
