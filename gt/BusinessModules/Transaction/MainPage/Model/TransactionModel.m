//
//  HomeModel.m
//  LiNiuYang
//
//  Created by Aalto on 2017/3/30.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "TransactionModel.h"
#define kTransactionAmountTypeLimit @"1"
#define kTransactionAmountTypeFixed @"2"

@implementation TransactionSubPageData

@end


@implementation TransactionData
- (BOOL) isBuyAvailable{
    
    if (GetUserDefaultBoolWithKey(kIsLogin)) {
        LoginModel* loginModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
        LoginData* loginData = loginModel.userinfo;
        
        if (![loginData.valiidnumber isEqualToString:@"3"]){//实名认证审核未通过（0-未审核，1-待审核，2-审核未通过，3-审核通过）
            
            if ([self.isSellerIdNumber isEqualToString:@"1"]
                &&[self.isSellerSeniorAuth isEqualToString:@"1"]) {
                return NO;
            }
            
            if ([self.isSellerIdNumber isEqualToString:@"1"]
                &&![self.isSellerSeniorAuth isEqualToString:@"1"]) {
                return NO;
            }
            if (![self.isSellerIdNumber isEqualToString:@"1"]
                &&![self.isSellerSeniorAuth isEqualToString:@"1"]) {
                return YES;
            }
            if (![self.isSellerIdNumber isEqualToString:@"1"]
                &&[self.isSellerSeniorAuth isEqualToString:@"1"]) {
                
                return NO;
            }
            
            
        }else{//实名认证审核通过（0-未审核，1-待审核，2-审核未通过，3-审核通过）
            
            if ([loginData.isSeniorCertification isEqualToString:@"1"]) {
                return YES;
            }else if (![loginData.isSeniorCertification isEqualToString:@"1"]) {
                if ([self.isSellerSeniorAuth isEqualToString:@"1"]) {
                    return NO;
                }else{
                    return YES;
                }
                
            }
        }
    }
    
    return NO;
}

- (NSString*) getPriorityImageName{
    NSString * titleTxt = @"";
    if (![self.isSellerIdNumber isEqualToString:@"3"]){
        titleTxt = @"";
    }else{
        if ([self.isSellerSeniorAuth isEqualToString:@"1"]) {
            titleTxt = @"isSeniorAuth_icon";
        }else if (![self.isSellerSeniorAuth isEqualToString:@"1"]) {
            titleTxt = @"isRealNameAuth_icon";
        }
    }
    return titleTxt;
}
- (NSString*) getRateName{
    NSString * titleTxt = @"1 CNY = 1 BUB";
//    [NSString stringWithFormat:@"1 CNY = %.2f AB",[self.number floatValue]/[self.price floatValue] ];
    return titleTxt;
}
- (NSString*) getPaymentwayName{
    NSString * titleTxt;
    //1.微信 2.支付宝 3.银行卡
    if ([self.paymentway containsString:@"1"]) {
        if ([self.paymentway containsString:@"2"]) {
            if ([self.paymentway containsString:@"3"]) {
                titleTxt = @"微信 支付宝 银行卡";
            }else{
                titleTxt = @"微信 支付宝";
            }
        }else{
            if ([self.paymentway containsString:@"3"]) {
                titleTxt = @"微信 银行卡";
            }else{
                titleTxt = @"微信";
            }
        }
    }else{
        if ( [self.paymentway containsString:@"2"]) {
            if ([self.paymentway containsString:@"3"]) {
                titleTxt = @"支付宝 银行卡";
            }else{
                titleTxt = @"支付宝";
            }
        }else{
            if ([self.paymentway containsString:@"3"]) {
                titleTxt = @"银行卡";
            }else{
                titleTxt = @"";
            }
        }
    }
    return titleTxt;
}
- (NSString *) getTransactionAmountTypeName
{
    NSString* title = @"";
    TransactionAmountType useType = [self getTransactionAmountType];
    
    switch (useType) {
        case TransactionAmountTypeLimit:
            title = [NSString stringWithFormat:@"%@ %@~%@ CNY",@"单笔限额：",self.limitMinAmount,self.limitMaxAmount];
            break;
        case TransactionAmountTypeFixed:
            title = [NSString stringWithFormat:@"%@ %@ CNY",@"单笔固额：",self.fixedAmount];
            break;
        default:
            break;
    }
    
    return title;
}

- (TransactionAmountType) getTransactionAmountType
{
    TransactionAmountType type = TransactionAmountTypeNone;
    NSString *tag = self.amountType;
    if ([tag isEqualToString:kTransactionAmountTypeLimit])
    {
        type = TransactionAmountTypeLimit;
    }
//    else if ([tag isEqualToString:kTransactionAmountTypeFixed])
    else
    {
        type = TransactionAmountTypeFixed;
    }
    
    
    return type;
}
@end

@implementation TransactionModel
+(NSDictionary *)objectClassInArray
{
    return @{
             @"advert" : [TransactionData class]
             };
}
@end
