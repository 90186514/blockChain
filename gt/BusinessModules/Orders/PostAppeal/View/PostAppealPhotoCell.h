//
//  PostAppealPhotoCell.h
//  gt
//
//  Created by Administrator on 23/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostAppealPhotoCell : UITableViewCell

+(instancetype)cellWith:(UITableView *)tabelView;
- (void)actionBlock:(DataBlock)block;
@end

NS_ASSUME_NONNULL_END
