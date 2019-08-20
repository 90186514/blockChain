//
//  HomeModel.m
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "AssetsModel.h"

#define kUserAssetsTypeAll  @"0"
#define kUserAssetsTypeTransferIn  @"1"
#define kUserAssetsTypeTransferOut  @"2"
#define kUserAssetsTypeBuyIn  @"3"
#define kUserAssetsTypeSellOut  @"4"
#define kUserAssetsTypeExchange  @"5"
@implementation AssetsSubPageData

@end

@implementation AssetsData
- (UIColor*)getUserAssetsNumColor{
    UIColor* color = kBlackColor;
    UserAssetsType type = [self getUserAssetsType];
    switch (type) {
        case UserAssetsTypeTransferIn:
        case UserAssetsTypeBuyIn:
            color = HEXCOLOR(0x006151);
            break;
        case UserAssetsTypeTransferOut:
        case UserAssetsTypeSellOut:
        case UserAssetsTypeExchange:
            color = HEXCOLOR(0xd02a2a);
            break;
        default:
            break;
    }
    return color;
}
- (NSString*)getUserAssetsNum{
    NSString* title = @"";
    UserAssetsType type = [self getUserAssetsType];
    switch (type) {
        case UserAssetsTypeTransferIn:
        case UserAssetsTypeBuyIn:
            title = [NSString stringWithFormat:@"+%.2f",[self.number floatValue]];
            break;
        case UserAssetsTypeTransferOut:
        case UserAssetsTypeSellOut:
        case UserAssetsTypeExchange:
            title = [NSString stringWithFormat:@"-%.2f",[self.number floatValue]];
            break;
        default:
            break;
    }
    return title;
}
- (NSString*)getUserAssetsTypeName{
    NSString* title = @"";
    UserAssetsType type = [self getUserAssetsType];
    switch (type) {
        case UserAssetsTypeAll:
            title = @"";
            break;
        case UserAssetsTypeTransferIn:
        case UserAssetsTypeTransferOut:
            title = @"转账";
            break;
        case UserAssetsTypeBuyIn:
            title = @"买入";
            break;
        case UserAssetsTypeSellOut:
            title = @"卖出";
            break;
        case UserAssetsTypeExchange:
            title = @"兑换比特币";
            break;
        default:
            title = @"";
            break;
    }
    return title;
}

- (UserAssetsType)getUserAssetsType{
    UserAssetsType type = UserAssetsTypeAll;
    NSString* tag = self.resource ;
    if ([tag isEqualToString:kUserAssetsTypeAll])
    {
        type = UserAssetsTypeAll;
    }
    else if ([tag isEqualToString:kUserAssetsTypeTransferIn])
    {
        type = UserAssetsTypeTransferIn;
    }
    else if ([tag isEqualToString: kUserAssetsTypeTransferOut])
    {
        type = UserAssetsTypeTransferOut;
    }
    else if ([tag isEqualToString:kUserAssetsTypeBuyIn])
    {
        type = UserAssetsTypeBuyIn;
    }
    else if ([tag isEqualToString: kUserAssetsTypeSellOut])
    {
        type = UserAssetsTypeSellOut;
    }
    else if ([tag isEqualToString: kUserAssetsTypeExchange])
    {
        type = UserAssetsTypeExchange;
    }
    return type;
}
@end



@implementation AssetsModel
+(NSDictionary *)objectClassInArray
{
    return @{
             @"accountChange" : [AssetsData class]
             
             };
}
@end
