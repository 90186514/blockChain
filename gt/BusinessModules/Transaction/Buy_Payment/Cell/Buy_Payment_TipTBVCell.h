//
//  Buy_Payment_TipTBVCell.h
//  gt
//
//  Created by Administrator on 03/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Buy_Payment_TipTBVCell : UITableViewCell

@property(nonatomic,strong)OrderDetailModel *orderDetailModel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style
                     dataDic:(NSDictionary *)dataDic
             reuseIdentifier:(NSString *)reuseIdentifier;

- (void)actionBlock:(TwoDataBlock)block;

@end

NS_ASSUME_NONNULL_END
