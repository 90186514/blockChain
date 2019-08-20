//
//  YBHomeDataCenter.m
//  Aa
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "HomeVM.h"

@interface HomeVM()
@property (strong,nonatomic)NSMutableArray   *listData;
@property (nonatomic,strong) HomeModel* model;
@property (nonatomic,strong) UserAssertModel* usModel;

@property (nonatomic,strong) NSMutableDictionary* zeroSectionDic;
@end

@implementation HomeVM
- (void)network_getTrendsListWithPage:(NSInteger)page success:(void (^)(NSArray * _Nonnull))success failed:(void (^)(void))failed {
    
    _listData = [NSMutableArray array];
    
    NSArray* gridSectionNames = @[@"Location",@"Quickening",@"CircleAnimation",@"TagRun",@"ModelFilter"];
    NSMutableArray* gridParams = [NSMutableArray array];
    
    for (int i=0; i<gridSectionNames.count; i++) {
        
        NSDictionary * param = @{kArr:gridSectionNames[i],
                                 kImg:[NSString stringWithFormat:@"home_grid_%i",i],
                                 kUrl:@""};
        [gridParams addObject:param];
    }
    
    
    
    [self removeContentWithType:IndexSectionTwo];
    [self.listData addObject: gridParams];
    success(self.listData);
    //    NSString* v =  [YBSystemTool appVersion];
    //    NSString* s =  [YBSystemTool appSource];
    //    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    //
    //
    //    WS(weakSelf);
    //    [[YTSharednetManager sharedNetManager]getNetInfoWithUrl:API_HOMES andType:All andWith:@{@"version":v,@"source":s} andReturn:^(NSDictionary *dic) {
    //        NSDictionary* result = dic[@"result"];
    //        if ([NSString getDataSuccessed:result]) {
    //            weakSelf.model = [HomeModel mj_objectWithKeyValues:dic];
    //            [self assembleApiData:weakSelf.model.result.data];
    //            success(weakSelf.listData);
    //        }
    //        [SVProgressHUD dismiss];
    //    }];
}

- (void)network_checkFixedPricesSuccess:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err {
    
    NSDictionary* proDic =@{};
    
    //    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_TransactionsOptionsCheck] andType:All andWith:proDic success:^(NSDictionary *dic) {
        HomeModel* pricemodel  = [HomeModel mj_objectWithKeyValues:dic];
        //        [SVProgressHUD dismiss];
        if ([NSString getDataSuccessed:dic]) {
            if (pricemodel.price!=nil) {
                [self setPriceData:pricemodel.price];
                
            }
        }
        else{
            //            [YKToastView showToastText:self.model.msg];
            failed(weakSelf.model);
        }
    } error:^(NSError *error) {
        //        [SVProgressHUD dismiss];
        //        [YKToastView showToastText:error.description];
        err(error);
        
    }];
}
- (void)setPriceData:(NSString*)priceOptions{
    if (priceOptions!=nil) {
        
        NSArray  *prices = [NSArray array];
        if ([priceOptions containsString:@","]) {
            prices = [priceOptions componentsSeparatedByString:@","];
        }else{
            prices = @[priceOptions];
        }
        
        //    NSArray  *optionPrices = [NSArray array];
        //    if ([model.optionPrice containsString:@","]) {
        //        optionPrices = [model.optionPrice componentsSeparatedByString:@","];
        //    }else{
        //        optionPrices = @[model.optionPrice,@""];
        //    }
        
        SetUserDefaultKeyWithObject(kFixedAccountsInTransactions,prices);
        
        UserDefaultSynchronize;
    }
}

- (void)network_getBannerSuccess:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err{
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_HomeBanner] andType:All andWith:@{} success:^(NSDictionary *dic) {
        
        
        self.model = [HomeModel mj_objectWithKeyValues:dic];
        if ([NSString getDataSuccessed:dic]) {
            // 数据缓存
            NSArray *banneAr = dic[@"banner"];
            if (banneAr && banneAr.count > 0) {
                [self entDataWith:kHomeBannerDataKey data:banneAr];
            }
            success(weakSelf.model);
        }
        else{
            failed(weakSelf.model);
        }
        
    } error:^(NSError *error) {
        err(error);
    }];
    //    [SVProgressHUD dismiss];
}
- (void)network_getUserAssertSuccess:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err{
    WS(weakSelf);
    [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_UserAssert] andType:All andWith:@{} success:^(NSDictionary *dic) {
        self.usModel = [UserAssertModel mj_objectWithKeyValues:dic];
        if ([NSString getDataSuccessed:dic]) {
            success(weakSelf.usModel);
        }
        else{
            failed(weakSelf.usModel);
        }
        //        [YKToastView showToastText:weakSelf.item.msg];
        
    } error:^(NSError *error) {
        err(error);
        //        [YKToastView showToastText:error.description];
        
    }];
    //    [SVProgressHUD dismiss];
}

- (void)network_getHomeListWithPage:(NSInteger)page success:(DataBlock)success failed:(DataBlock)failed error:(DataBlock)err {
    
    _listData = [NSMutableArray array];
    
    [self removeContentWithType:IndexSectionZero];
    if (page==1) {
        NSArray *bannerDicAr = (NSArray*)[self getOldeDataAndKey:kHomeBannerDataKey];
        NSMutableArray *banners = [NSMutableArray array];
        if (bannerDicAr && bannerDicAr.count > 0 ) {
            for (NSDictionary *bannerDic in bannerDicAr) {
                HomeBannerData *bannerData = [HomeBannerData mj_objectWithKeyValues:bannerDic];
                [banners addObject:bannerData];
            }
        }
        NSDictionary* dic = @{kIndexInfo:@"",
                              kTip:@"BUB",
                              kArr:banners
                              };
        [self.listData addObject:@{
                                   kIndexSection: @(IndexSectionZero),
                                   kIndexRow: @[dic]}];
    }
    
    [self removeContentWithType:IndexSectionOne];
    NSArray* gridSectionNames = @[@"扫码转账",@"买币",@"我的订单",@"兑换比特币",@"卖币",@"帮助中心"];
    NSMutableArray* gridParams = [NSMutableArray array];
    NSArray* gridTypes = @[@(EnumActionTag0),@(EnumActionTag1),@(EnumActionTag2),@(EnumActionTag3),@(EnumActionTag4),@(EnumActionTag5)];//,@(IndexSectionFour)
    for (int i=0; i<gridSectionNames.count; i++) {
        NSDictionary * param = @{kArr:gridSectionNames[i],
                                 kImg:[NSString stringWithFormat:@"chome_grid_%i",i],
                                 kType:gridTypes[i]
                                 };
        [gridParams addObject:param];
    }
    if (page==1){
        [self.listData addObject:@{kIndexSection: @(IndexSectionOne),
                                   kIndexInfo:@[@"待处理订单",@"icon_bank"],
                                   kIndexRow: @[gridParams]}];
    }
    
    
    [self removeContentWithType:IndexSectionTwo];
    NSArray *coinDicAr = (NSArray*)[self getOldeDataAndKey:kHomeCoinListDataKey];
    if (coinDicAr && coinDicAr.count > 0 && page ==1) {
        
        NSMutableArray *coins = [NSMutableArray array];
        
        for (NSDictionary *coinDic in coinDicAr) {
            HomeData *bannerData = [HomeData mj_objectWithKeyValues:coinDic];
            [coins addObject:bannerData];
        }
        [self.listData addObject:@{
                                   kIndexSection: @(IndexSectionTwo),
                                   kIndexRow: coins}//data.t.arr
         ];
    }
    [self sortData];
    success(self.listData);
    
    [SVProgressHUD showWithStatus:@"加载中..." maskType:SVProgressHUDMaskTypeNone];
    WS(weakSelf);
    
    BOOL valueLogin = GetUserDefaultBoolWithKey(kIsLogin);
    if (!valueLogin) {
        [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_Home] andType:All andWith:@{} success:^(NSDictionary *dic) {
            if ([NSString getDataSuccessed:dic]) {
                NSArray *coinAr = dic[@"marketList"];
                if (coinAr && coinAr.count > 0 && page == 1) {
                    [self entDataWith:kHomeCoinListDataKey data:coinAr];
                }
                self.model = [HomeModel mj_objectWithKeyValues:dic];
                [self assembleCoinListData:self.model WithPage:1];
                success(weakSelf.listData);
            }
            else{
                
                //                    [YKToastView showToastText:weakSelf.model.msg];
                failed(weakSelf.model);
            }
            
            
        } error:^(NSError *error) {
            
        }];
        
        [self network_getBannerSuccess:^(id data) {
            HomeModel* bannerModel = data;
            [self assembleBanners:bannerModel.banner WithPage:1];
            success(weakSelf.listData);
        } failed:^(id data) {
            
        } error:^(id data) {
            
        }];
        
        [SVProgressHUD dismiss];
        
    }else{
        
        [[YTSharednetManager sharedNetManager]postNetInfoWithUrl:[ApiConfig getAppApi:ApiType_Home] andType:All andWith:@{} success:^(NSDictionary *dic) {
            if ([NSString getDataSuccessed:dic]) {
                NSArray *coinAr = dic[@"marketList"];
                if (coinAr && coinAr.count > 0 && page == 1) {
                    [self entDataWith:kHomeCoinListDataKey data:coinAr];
                }
                self.model = [HomeModel mj_objectWithKeyValues:dic];
                [self assembleCoinListData:self.model WithPage:page];
                success(weakSelf.listData);
            }
            else{
                
                //                failed(weakSelf.model);
            }
            
            
        } error:^(NSError *error) {
            
        }];
        
        [self network_getBannerSuccess:^(id data) {
            HomeModel* bannerModel = data;
            [self assembleBanners:bannerModel.banner WithPage:page];
            success(weakSelf.listData);
        } failed:^(id data) {
            
        } error:^(id data) {
            
        }];
        
        
        [self network_getUserAssertSuccess:^(id data) {
            UserAssertModel* item = data;
            
            SetUserDefaultKeyWithObject(kUserAssert, [item mj_keyValues]);
            UserDefaultSynchronize;
            
            [self assembleUserAssert:item WithPage:page];
            success(weakSelf.listData);
        } failed:^(id data) {
            UserAssertModel* item = data;
            NSInteger errorI = [item.errcode integerValue];
            if (errorI != 1) {
                SetUserBoolKeyWithObject(kIsLogin, NO);
                
                DeleUserDefaultWithKey(kUserInfo);
                
                UserDefaultSynchronize;
                failed(@(errorI));
            }
        } error:^(id data) {
            
        }];
        [SVProgressHUD dismiss];
    }
    
}

- (void)assembleCoinListData:(HomeModel*)data  WithPage:(NSInteger)page{
    [self removeContentWithType:IndexSectionTwo];
    
    if (data.marketList !=nil && data.marketList.count>0) {
        [self.listData addObject:@{
                                   
                                   kIndexSection: @(IndexSectionTwo),
                                   kIndexRow: data.marketList}//data.t.arr
         ];
    }
    [self sortData];
}

- (void)assembleUserAssert:(UserAssertModel*)usModel WithPage:(NSInteger)page{
    [self removeContentWithType:IndexSectionZero];
    
    [self.zeroSectionDic addEntriesFromDictionary:@{kIndexInfo:usModel!=nil?usModel:@"",
                                                    }];
    
    if (page==1) {
        
        [self.listData addObject:@{
                                   kIndexSection: @(IndexSectionZero),
                                   kIndexRow: @[self.zeroSectionDic]}];
    }
    [self sortData];
}

- (void)assembleBanners:(NSArray*)banners WithPage:(NSInteger)page{
    [self removeContentWithType:IndexSectionZero];
    
    [self.zeroSectionDic addEntriesFromDictionary: @{
                                                     kArr:banners!=nil?banners:
                                                         @[
                                                             //                                 @{kImg:@"banner1",kTit:@"https://www.baidu.com"},
                                                             //                                  @{kImg:@"banner2",kTit:@"https://news.baidu.com"},
                                                             //                                 @{kImg:@"banner3",kTit:@"http://music.taihe.com"}
                                                             ]
                                                     }];
    
    if (page==1) {
        
        [self.listData addObject:@{
                                   kIndexSection: @(IndexSectionZero),
                                   kIndexRow: @[self.zeroSectionDic]}];
    }
    [self sortData];
}

- (void)assembleApiData:(HomeModel*)data WithUserAssert:(UserAssertModel*)usModel WithBanners:(NSArray*)banners WithPage:(NSInteger)page{
    [self removeContentWithType:IndexSectionZero];
    
    NSDictionary* dic = @{kIndexInfo:usModel!=nil?usModel:@"",
                          kTip:@"BUB",
                          kArr:banners!=nil?banners:
                              @[
                                  //                                 @{kImg:@"banner1",kTit:@"https://www.baidu.com"},
                                  //                                  @{kImg:@"banner2",kTit:@"https://news.baidu.com"},
                                  //                                 @{kImg:@"banner3",kTit:@"http://music.taihe.com"}
                                  ]
                          };
    
    if (page==1) {
        
        [self.listData addObject:@{
                                   kIndexSection: @(IndexSectionZero),
                                   kIndexRow: @[dic]}];
    }
    
    
    
    [self removeContentWithType:IndexSectionTwo];
    
    
    
    if (data.marketList !=nil && data.marketList.count>0) {
        [self.listData addObject:@{
                                   
                                   kIndexSection: @(IndexSectionTwo),
                                   kIndexRow: data.marketList}//data.t.arr
         ];
    }
    [self sortData];
}
- (void)sortData {
    [self.listData sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSNumber *number1 = [NSNumber numberWithInteger:[[obj1 objectForKey:kIndexSection] integerValue]];
        NSNumber *number2 = [NSNumber numberWithInteger:[[obj2 objectForKey:kIndexSection] integerValue]];
        
        NSComparisonResult result = [number1 compare:number2];
        
        return result == NSOrderedDescending;
    }];
}

- (void)removeContentWithType:(IndexSectionType)type {
    [self.listData enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        IndexSectionType contentType = [[(NSDictionary *)obj objectForKey:kIndexSection] integerValue];
        if (contentType == type) {
            *stop = YES;
            [self.listData removeObject:obj];
        }
    }];
    
}

- (NSMutableDictionary *)zeroSectionDic {
    if (!_zeroSectionDic) {
        NSDictionary* dic = @{
                              kTip:@"BUB"
                              };
        _zeroSectionDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        
    }
    return _zeroSectionDic;
}

-(id)getOldeDataAndKey:(NSString*)key{
    NSString *filePath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:key];
    id data = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    return data;
}

-(void)entDataWith:(NSString*)key data:(id)data{
    if (data) {
        NSString *filePath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:key];
        [NSKeyedArchiver archiveRootObject:data toFile:filePath];
    }
}


@end



