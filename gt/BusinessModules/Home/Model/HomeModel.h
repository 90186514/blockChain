//
//  HomeModel.h
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface UserAssertModel : NSObject

@property (nonatomic, copy) NSString * errcode;
@property (nonatomic, copy) NSString * msg;
@property (nonatomic, copy) NSString * usableFund;
@property (nonatomic, copy) NSString * frozenFund;
@property (nonatomic, copy) NSString * amount;
@property (nonatomic, copy) NSString * convertRmb;
@end

@interface HomeBannerData : NSObject
@property (nonatomic, copy) NSString * bannerId;
@property (nonatomic, copy) NSString * sort;
@property (nonatomic, copy) NSString * clickUrl;
@property (nonatomic, copy) NSString * imageUrl;
@end

@interface HomeData : NSObject
@property (nonatomic, copy) NSString * tradeId;
@property (nonatomic, copy) NSString * coinId;
@property (nonatomic, copy) NSString *coinImageUrl;
@property (nonatomic, copy) NSString * rmbPrice;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * upAndDown;
@property (nonatomic, copy) NSString * sort;
@end

@interface HomeModel : NSObject
@property (nonatomic, copy) NSString * errcode;
@property (nonatomic, copy) NSString * msg;
@property (nonatomic, copy) NSArray * marketList;
@property (nonatomic, copy) NSArray *banner;
+(NSDictionary *)objectClassInArray;
@property (nonatomic, copy) NSString * price;
@property (nonatomic, copy) NSString * optionPrice;
@end
