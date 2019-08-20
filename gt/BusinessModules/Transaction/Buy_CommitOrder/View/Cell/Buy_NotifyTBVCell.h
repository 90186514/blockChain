//
//  Buy_NotifyTBVCell.h
//  gt
//
//  Created by Administrator on 31/03/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Buy_NotifyTBVCell : UITableViewCell

@property(nonatomic,strong)UIButton *submitBtn;

@property(nonatomic,copy)void(^myBlock)(void);

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END
