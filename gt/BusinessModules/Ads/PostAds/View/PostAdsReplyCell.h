//  Created by Aalto on 2018/12/23.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WItem;
@interface PostAdsReplyCell : UITableViewCell
@property(nonatomic,assign) BOOL isHiddenLimitCount;
- (void)actionBlock:(DataBlock)block;
+(CGFloat)cellHeightWithModel:(NSDictionary*)model;
+(instancetype)cellWith:(UITableView*)tableView;
- (void)richElementsInBuyVCCellWithModel:(NSDictionary*)paysDic;
- (void)richElementsInCellWithModel:(NSDictionary*)paysDic;
@end
