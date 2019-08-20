//
//  HomeModel.m
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "HomeModel.h"
@implementation UserAssertModel

@end

@implementation HomeBannerData

@end
@implementation HomeData

@end



@implementation HomeModel
+(NSDictionary *)objectClassInArray
{
    return @{
             @"marketList" : [HomeData class],
             @"banner": [HomeBannerData class]
             };
}
@end
