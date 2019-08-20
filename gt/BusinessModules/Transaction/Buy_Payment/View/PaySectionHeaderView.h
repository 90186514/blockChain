//  Created by Aalto on 2018/12/28.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *PaySectionHeaderReuseIdentifier = @"PaySectionHeaderView";


@interface PaySectionHeaderView : UITableViewHeaderFooterView

- (void)richElementsInViewWithModel:(NSDictionary*)model;
+ (void)sectionHeaderViewWith:(UITableView*)tableView;

+ (CGFloat)viewHeight;
@end
