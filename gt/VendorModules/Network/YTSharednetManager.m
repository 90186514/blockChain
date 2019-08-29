//
//  YTSharednetManager.m
//  yitiangogo
//
//  Created by Tgs on 14-11-22.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "YTSharednetManager.h"

static YTSharednetManager *sharedManager = nil;
@implementation YTSharednetManager
@synthesize httpManager;
@synthesize statusBlock;


-(instancetype)init{
    if (self = [super init]) {
        
    }
    return self;
}

+(YTSharednetManager *)sharedNetManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[YTSharednetManager alloc]init];
    });
    return sharedManager;
}

-(void)setGetTheadNetworkWithUrl:(NSMutableDictionary *)dictionary
                       andReturn:(void (^)(NSDictionary *dic))block{
    
    httpManager = [AFHTTPRequestOperationManager manager];
    
    ((AFJSONResponseSerializer *)httpManager.responseSerializer).removesKeysWithNullValues = YES;
    
    RequestType type = [[dictionary objectForKey:@"userinfo"] intValue];
    
    httpManager.requestSerializer.timeoutInterval = 30;
    
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    WS(weakSelf);
    [httpManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        weakSelf.selectNetStatus = status;
        
        managerAFNetworkStatus ownStatus = managerAFNetworkNotReachable;
        
        switch (status) {
                
            case AFNetworkReachabilityStatusNotReachable:     // 无连线
                ownStatus = managerAFNetworkNotReachable;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                ownStatus = managerAFNetworkReachableViaWWAN;
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WiFi
                ownStatus = managerAFNetworkReachableViaWiFi;
                break;
                
            case AFNetworkReachabilityStatusUnknown:          // 未知网络
            default:
                ownStatus = managerAFNetworkUnknown;
                break;
        }
        if (weakSelf.statusBlock) {
            
            weakSelf.statusBlock(ownStatus);
        }
    }];
    // 开始监听
    [httpManager.reachabilityManager startMonitoring];
    //    设置cookie
    if (type != GetCookie) {
        
        [httpManager.requestSerializer setValue:GetUserDefaultWithKey(@"mUserDefaultsCookie")
                             forHTTPHeaderField:@"Cookie"];
    }
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
    
    NSDictionary *postDic = [[NSDictionary alloc]initWithDictionary:[dictionary valueForKey:@"parameters"]];
    
    [httpManager GET:[dictionary valueForKey:@"url"]
          parameters:postDic
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
        NSData *data = [operation responseData];
                 
        [dataDic setValue:@"Success" forKey:@"info"];
                 
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:NSJSONReadingMutableContainers
                                                                    error:nil];
//        NSLog(@"%@",[operation responseString]);
        [dataDic setValue:resultDic forKey:@"result"];
                 
        if (block) {
            
            block(dataDic);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        if (type==PayService&&[operation responseData]!=nil) {
//            NSData *data = [operation responseData];
//            [dataDic setValue:@"Success" forKey:@"info"];
//            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//            [dataDic setValue:resultDic forKey:@"result"];
//        }else{
//            
//        }
        if (weakSelf.selectNetStatus!=AFNetworkReachabilityStatusNotReachable) {
            managerAFNetworkStatus ownStatus = managerAFNetworkServiceError;
            
            if (weakSelf.statusBlock) {
                
                weakSelf.statusBlock(ownStatus);
            }
        }
        NSData *data = [operation responseData];
        if (data) {
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:nil];
            
            if ([[NSString isValueNSStringWith:[resultDic objectForKey:@"code"]] integerValue]==600&&resultDic!=nil) {
//                AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//                [delegate getNetworkCookie];
            }
        }
        [dataDic setValue:@"Fail"
                   forKey:@"info"];
        
        [dataDic setValue:nil
                   forKey:@"result"];
        if (block) {
            block(dataDic);
        }
    }];
}


//Post请求
-(void)setPostReturnNetWorkWith:(NSDictionary *)dictionary
                      andReturn:(void (^)(NSDictionary *dic))block{
    //    AFNetWorking下载数据
    httpManager = [AFHTTPRequestOperationManager manager];
    
    ((AFJSONResponseSerializer *)httpManager.responseSerializer).removesKeysWithNullValues = YES;
    
    RequestType type = [[dictionary objectForKey:@"userinfo"] intValue];
    
    httpManager.requestSerializer.timeoutInterval = 30;
    
    httpManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    WS(weakSelf);
    [httpManager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        weakSelf.selectNetStatus = status;
        
        managerAFNetworkStatus ownStatus = managerAFNetworkNotReachable;
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:     // 无连线
                ownStatus = managerAFNetworkNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
                ownStatus = managerAFNetworkReachableViaWWAN;
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi: // WiFi
                ownStatus = managerAFNetworkReachableViaWiFi;
                break;
            case AFNetworkReachabilityStatusUnknown:          // 未知网络
            default:
                ownStatus = managerAFNetworkUnknown;
                break;
        }
        if (weakSelf.statusBlock&&type!=Default) {
            
            weakSelf.statusBlock(ownStatus);
        }
    }];
    // 开始监听
    [httpManager.reachabilityManager startMonitoring];
//    设置cookie
    if (type != GetCookie) {
        
        [httpManager.requestSerializer setValue:GetUserDefaultWithKey(@"mUserDefaultsCookie")
                             forHTTPHeaderField:@"Cookie"];
    }
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]init];
    
    NSDictionary *postDic = [[NSDictionary alloc]initWithDictionary:[dictionary valueForKey:@"parameters"]];
    
    [httpManager POST:[dictionary valueForKey:@"url"]
           parameters:postDic
              success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = [operation responseData];
        
        [dataDic setValue:@"Success" forKey:@"info"];
        
        if (type == GetCookie) {
            
            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage]cookiesForURL:[NSURL URLWithString:[dictionary valueForKey:@"url"]]];
            
            NSDictionary *Request = [[NSDictionary alloc]initWithDictionary:[NSHTTPCookie requestHeaderFieldsWithCookies:cookies]];
            
            SetUserDefaultKeyWithObject(@"mUserDefaultsCookie", [Request objectForKey:@"Cookie"]);
        }
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:NSJSONReadingMutableContainers
                                                                    error:nil];
        //        接口判断、数据处理、回调
//        lMenu_productApi_info

        if([kNeedNetLog isEqualToString:@"1"])NSLog(@"%@",[operation responseString]);


        [dataDic setValue:resultDic forKey:@"result"];
        if (block) {
            block(dataDic);
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (weakSelf.selectNetStatus!=AFNetworkReachabilityStatusNotReachable&&type!=Default) {
            managerAFNetworkStatus ownStatus = managerAFNetworkServiceError;
            
            if (weakSelf.statusBlock) {
                weakSelf.statusBlock(ownStatus);
            }
        }
        NSData *data = [operation responseData];
        if (data) {
            NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:NSJSONReadingMutableContainers
                                                                        error:nil];
            
            if ([[NSString isValueNSStringWith:[resultDic objectForKey:@"code"]] integerValue] == 600 && resultDic!=nil) {
//                AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//                [delegate getNetworkCookie];
            }
        }
        [dataDic setValue:@"Fail" forKey:@"info"];
        [dataDic setValue:nil forKey:@"result"];
        if (block) {
            block(dataDic);
        }
    }];
}
-(void)postNetInfoWithUrl:(NSString *)urlPath_Header
                  andType:(RequestType)type
                  andWith:(NSDictionary *)paramters
                  success:(void(^)(NSDictionary *dic))success
                    error:(void (^)(NSError *error))err{
    
    NSString *path = Nil;
    if (type == All) {
        
        path = (GetUserDefaultWithKey(URL_IP)!=nil)?GetUserDefaultWithKey(URL_IP):URL_IP;//URL_IP;
    }
    else if(type == LNService){
        
        path = LNURL_IP;
    }
    else if(type == Default){
        
        path = @"";
    }else{
        
        path = URL_IP;
    }
    
    NSString *titStr = [paramters mj_JSONString];
    NSLog(@"requestObject: %@", titStr);
    /*
     JSONEncoding.default是放在HttpBody内的，   比如post请求
     URLEncoding.default在GET中是拼接地址的，    比如get请求
     JSONEncoding的主要作用是把参数以JSON的形式编码到request之中，当然是通过request的httpBody进行赋值的。JSONEncoding提供了两种处理函数，一种是对普通的字典参数进行编码，另一种是对JSONObject进行编码
     
     */
    NSData *postData = [titStr dataUsingEncoding:NSUTF8StringEncoding
                            allowLossyConversion:YES];
    //nickname 中文出现过问题
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    /*图形验证码的数据流用这个
     httpSessionManager.responseSerializer = [AFHTTPRequestSerializer serializer];
     用完设置回
     httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/octet-stream",@"text/html",@"text/json",@"application/json",@"text/javascript",@"image/jpeg",@"image/png",@"text/plain",@"image/gif", nil];

     */
    /*有textFiled的cell不复用的设置
     NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%ld%ld", (long)[indexPath section], (long)[indexPath row]];
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
     
     cell = [[UITableViewCell alloc]initWithStyle:0 reuseIdentifier:CellIdentifier];
     */
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST"
                                                                                 URLString:[NSString stringWithFormat:@"%@%@",path,urlPath_Header]
                                                                                parameters:nil
                                                                                     error:nil];
    NSLog(@"requestUrl....: %@", request);
    request.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:postData];
    NSLog(@"request\\\\: %@", request);
    [[manager dataTaskWithRequest:request
                completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                    
        if (!error) {
            
            NSLog(@"responseObject: %@", responseObject);
            
            if ([responseObject isKindOfClass:[NSDictionary class]]){
                
                NSDictionary * dic = (NSDictionary *)responseObject;
                
                success(dic);
            }
        } else {
            
            NSLog(@"error: %@, %@, %@", error, response, responseObject);
            
            err(error);
        }
    }] resume];
}

-(void)getGETNetInfoWithUrl:(NSString *)urlPath_Header
                    andType:(RequestType)type
                    andWith:(NSDictionary *)paramters
                  andReturn:(void (^)(NSDictionary *dic))block{
    
    NSNumber *index = [NSNumber numberWithInteger:type];
    
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]initWithCapacity:5];
    NSString *path = Nil;
    
    if (type == All) {
        
        path = URL_IP;
    }
    else if(type == LNService){
        
        path = LNURL_IP;
    }else if(type == PayService){
        
//        path = URL_PAY_IP;
    }else if(type == UpayService){
        
//        path = URL_UPAY_IP;
    }else if(type == Default){
        
        path = @"";
    }else{
        
        path = URL_IP;
    }
    [dataDic setObject:[NSString stringWithFormat:@"%@%@",path,urlPath_Header]
                forKey:@"url"];
    
    [dataDic setObject:index
                forKey:@"userinfo"];
    
    if (paramters.allKeys.count > 0) {
        
        [dataDic setObject:paramters
                    forKey:@"parameters"];
    }
//    NSLog(@"%@",dataDic);
    [self setGetTheadNetworkWithUrl:dataDic
                          andReturn:^(NSDictionary *dic) {
        if (block) {
            block(dic);
        }
    }];
}

#pragma mark--通用网络接口 --Post
-(void)getNetInfoWithUrl:(NSString *)urlPath_Header
                 andType:(RequestType)type
                 andWith:(NSDictionary *)paramters
               andReturn:(void (^)(NSDictionary *dic))block{
    
    NSNumber *index = [NSNumber numberWithInteger:type];
    NSMutableDictionary *dataDic = [[NSMutableDictionary alloc]initWithCapacity:5];
    NSString *path;
    if (type == All) {
        path = URL_IP;
    }else if(type == LNService){
        path = LNURL_IP;
    }
    else if(type == Default){
        path = @"";
    }else{
        path = URL_IP;
    }
    [dataDic setObject:[NSString stringWithFormat:@"%@%@",path,urlPath_Header]
                forKey:@"url"];
    
    [dataDic setObject:index
                forKey:@"userinfo"];
    
    if (paramters.allKeys.count>0) {
        
        [dataDic setObject:paramters
                    forKey:@"parameters"];
    }
    if([kNeedNetLog isEqualToString:@"1"])NSLog(@"wnagluo------>>%@",dataDic);
    
    [self setPostReturnNetWorkWith:dataDic
                         andReturn:^(NSDictionary *dic) {
        if (block) {
            block(dic);
        }
    }];
}

//设置网络监听
-(void)setAFNetStatusChangeBlock:(void(^)(managerAFNetworkStatus status))block{
    self.statusBlock = [block copy];
}
#pragma mark afnetworking请求，文件上传
-(void)requestAFNetWorkingByUrl:(NSString *)url
                     parameters:(id)parameters
                          files:(NSDictionary *) files
                        success:(void (^)(AFHTTPRequestOperation *operation, id data))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    [self initAFNetWorkingByUrl:url
                     parameters:parameters
                           head:nil
                          files:files
                        success:success
                        failure:failure
                           type:1];
    
}

//type:1为Post；0为Get
-(void)initAFNetWorkingByUrl:(NSString *) url
                  parameters:(id)parameters
                        head:(NSDictionary *)headers
                       files:(NSDictionary *) files
                     success:(void (^)(AFHTTPRequestOperation *operation, id data))success
                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                        type:(NSInteger)type{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
    
    manager.requestSerializer.timeoutInterval = 60;
    //    设置cookie
    [manager.requestSerializer setValue:GetUserDefaultWithKey(@"mUserDefaultsCookie") forHTTPHeaderField:@"Cookie"];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionaryWithDictionary:parameters];
    
    if (headers) {
        
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    [manager.requestSerializer setValue:@"client/json" forHTTPHeaderField:@"Exception-With"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/png",@"multipart/form-data", nil];
    
    AFHTTPRequestOperation *result = Nil;
    
    if (type == 1) {
        
        if (files) {
            
            result =  [manager POST:url
                         parameters:params
          constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
              
                [files enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    
                    [formData appendPartWithFileData:obj
                                                name:key
                                            fileName:[NSString stringWithFormat:@"%@.png",key]
                                            mimeType:@"image/png"];
                }];
            } success:success failure:failure ];
        }else{
            
            result = [manager POST:url
                        parameters:params
                           success:success
                           failure:failure];
        }
    }
    else{
        
        result =[manager GET:url
                  parameters:parameters
                     success:success
                     failure:failure];
    }
}

@end
