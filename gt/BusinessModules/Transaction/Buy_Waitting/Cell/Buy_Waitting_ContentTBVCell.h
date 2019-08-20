//
//  Buy_Waitting_ContentTBVCell.h
//  gt
//
//  Created by Administrator on 03/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 买币 - 等待放行
 */
@interface Buy_Waitting_ContentTBVCell : UITableViewCell

@property(nonatomic,strong)NSString *orderNo;//订单号

@property(nonatomic,strong)NSString *orderAmount;//订单金额

@property(nonatomic,strong)NSString *orderNumber;//成交数量

@property(nonatomic,strong)NSString *createdTime;//订单创建时间

-(instancetype)initWithStyle:(UITableViewCellStyle)style
               requestParams:(id)requestParams
             reuseIdentifier:(NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
