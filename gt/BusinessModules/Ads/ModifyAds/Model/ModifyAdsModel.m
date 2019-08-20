//
//  HomeModel.m
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 . All rights reserved.
//

#import "ModifyAdsModel.h"

#define kOccurAdsTypeTypeAll @"0"
#define kOccurAdsTypeTypeOnline @"1"
#define kOccurAdsTypeTypeOutline @"2"
#define kOccurAdsTypeTypeSellOut @"3"


@implementation ModifyAdsModel
- (NSString *) getOccurAdsTypeName
{
    NSString* title = @"";
    OccurAdsType useType = [self getOccurAdsType];
    
    switch (useType) {
        case OccurAdsTypeTypeOnline:
            title = @"上架中";
            break;
        case OccurAdsTypeTypeSellOut:
            title = @"售罄";
            break;
        case OccurAdsTypeTypeOutline:
            title = @"已下架";
            break;
        default:
            break;
    }
    
    return title;
}

- (OccurAdsType) getOccurAdsType
{
    OccurAdsType type = OccurAdsTypeTypeAll;
    NSString *tag = self.status;
    if ([tag isEqualToString:kOccurAdsTypeTypeAll])
    {
        type = OccurAdsTypeTypeAll;
    }
    else if ([tag isEqualToString:kOccurAdsTypeTypeOnline]){
        type = OccurAdsTypeTypeOnline;
    }
    else if ([tag isEqualToString:kOccurAdsTypeTypeSellOut]){
        type = OccurAdsTypeTypeSellOut;
    }
    else if ([tag isEqualToString:kOccurAdsTypeTypeOutline]){
        type = OccurAdsTypeTypeOutline;
    }
    
    return type;
}
@end
