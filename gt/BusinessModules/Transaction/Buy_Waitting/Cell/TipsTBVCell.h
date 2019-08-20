//
//  Buy_Waitting_TipTBVCell.h
//  gt
//
//  Created by Administrator on 03/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TipsTBVCell : UITableViewCell

@property(nonatomic,copy)void(^MyBlock)(void);

-(instancetype)initWithStyle:(UITableViewCellStyle)style
                     dataDic:(NSDictionary *)dataDic
             reuseIdentifier:(NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
