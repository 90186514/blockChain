//
//  PostAdsView.h
//  gtp
//
//  Created by Aalto on 2018/12/23.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@class PostAdsView;

@protocol PostAdsViewDelegate <NSObject>

@required

- (void)postAdsView:(PostAdsView *)view requestListWithPage:(NSInteger)page;

@end

@interface PostAdsView : UIView
@property (copy, nonatomic) void(^clickGridRowBlock)(NSDictionary * dataModel);
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) id<PostAdsViewDelegate> delegate;
- (void)actionBlock:(EightDataBlock)block;
- (void)requestListSuccessWithArray:(NSArray *)array withRequestParams:(id)requestParams;

- (void)requestListFailed;
-(void)refeshPayCellInPostAds:(NSArray *)array;
@end

NS_ASSUME_NONNULL_END
