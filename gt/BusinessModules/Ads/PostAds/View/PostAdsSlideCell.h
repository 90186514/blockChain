//  Created by Aalto on 2018/12/23.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WItem;
@interface PostAdsSlideCell : UITableViewCell

+(CGFloat)cellHeightWithModel;
+(instancetype)cellWith:(UITableView*)tabelView;
- (void)richElementsInCellWithModel:(NSDictionary*)model;
- (void)actionBlock:(TwoDataBlock)block;
@end
