//
//  Buy_ContentTBVCell.h
//  gt
//
//  Created by Administrator on 31/03/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
    买币 -  提交订单
 */
@interface Buy_CommitOrder_ContentTBVCell : UITableViewCell

@property(nonatomic,strong)NSString *nameStr;//昵称
@property(nonatomic,strong)NSString *volumeOfBusinessStr;//交易量
@property(nonatomic,strong)NSString *successRateStr;//成功率
@property(nonatomic,strong)NSString *surplusPurchasableNumStr;//剩余可购买数量
@property(nonatomic,strong)NSString *oncePurchasableNumStr;//单次可购买数量
@property(nonatomic,strong)NSString *unitPriceStr;//单价
@property(nonatomic,assign)TransactionAmountType type;//金额类型 : 1、限额 2、固额

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                  amountType:(TransactionAmountType)type
                  paymentway:(NSString *)paymentway;

- (void)actionBlock:(ActionBlock)block;




@end

NS_ASSUME_NONNULL_END
