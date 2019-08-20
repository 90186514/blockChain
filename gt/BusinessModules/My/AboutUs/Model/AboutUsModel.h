//
//  ModifyLoginRequestModel.h
//  gt
//
//  Created by GT on 2019/1/31.
//  Copyright © 2019 GT. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface AboutUsData : NSObject
@property (nonatomic, copy) NSString * versionId;
@property (nonatomic, copy) NSString * about;
@property (nonatomic, copy) NSString * contact;
@end

@interface AboutUsModel : NSObject
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString * err_code;
@property (nonatomic, copy) NSString * msg;
@property (nonatomic, strong) AboutUsData * versioninfo;
@property (nonatomic, copy) NSString *weiXin;
@property (nonatomic, copy) NSString *qq;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *rongCloudId;
@property (nonatomic, copy) NSString *rongCloudName;
@end

NS_ASSUME_NONNULL_END
