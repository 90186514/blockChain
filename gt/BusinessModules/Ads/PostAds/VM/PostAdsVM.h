//
//  YBHomeDataCenter.h
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostAdsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface PostAdsVM : NSObject
- (void)network_sendAdsListWithNumber:(NSString *)number amountType:(NSString *)amountType limitMax:(NSString *)limitMax limitMin:(NSString *)limitMin fixedNumber:(NSString *)fixedNumber price:(NSString *)price type:(NSString *)type pamentWay:(NSString *)pamentWay coinId:(NSString *)coinId coinType:(NSString *)coinType prompt:(NSString *)prompt autoReplyContent:(NSString *)autoReplyContent isIDNumber:(NSString *)isIdNumber isSeniorCertification:(NSString *)isSeniorCertification  transactionPassword:(NSString *)transactionPassword googlesecret:(NSString *)googlesecret ugAdID:(NSString*)ugAdID success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;

- (void)network_getPostAdsListWithPage:(NSInteger)page WithRequestParams:(id)requestParams success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err;
@end

NS_ASSUME_NONNULL_END
