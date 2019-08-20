//
//  AccountCell.h
//  gt
//
//  Created by 钢镚儿 on 2018/12/19.
//  Copyright © 2018年 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class PaymentAccountData;
@interface MyAccountCell : UITableViewCell

+(CGFloat)cellHeightWithModel;
+(instancetype)cellWith:(UITableView*)tabelView;
- (void)richElementsInCellWithModel:(PaymentAccountData*)model;
- (void)actionBlock:(DataBlock)block;
- (void)deleteActionBlock:(DataBlock)block;
@end

NS_ASSUME_NONNULL_END
