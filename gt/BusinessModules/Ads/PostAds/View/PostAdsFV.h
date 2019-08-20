//  gtp
//
//  Created by Aalto on 2018/12/23.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PostAdsFV : UIView

- (void)actionBlock:(TwoDataBlock)block;
- (void)richElementsInHeaderWithModel:(id)requestParams;
- (instancetype)initWithFrame:(CGRect)frame WithModel:(NSArray*)titleArray;
@end
