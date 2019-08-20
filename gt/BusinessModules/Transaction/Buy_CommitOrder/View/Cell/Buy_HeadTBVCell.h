//
//  Buy_HeadTBVCell.h
//  gt
//
//  Created by Administrator on 31/03/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Buy_HeadTBVCell : UITableViewCell

@property(nonatomic,strong)OrderDetailModel *orderDetailModel;

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                     dataDic:(NSDictionary *)dataDic;

@end

NS_ASSUME_NONNULL_END
