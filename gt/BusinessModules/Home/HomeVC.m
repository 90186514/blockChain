//
//  HomeVC.m
//  gt
//
//  Created by Aalto on 2018/11/19.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "HomeVC.h"
#import "HomeView.h"
#import "HomeVM.h"

#import "HomeGuidePageManager.h"

#import "WebViewController.h"
#import "HomeScanView.h"
#import "ScanCodeVC.h"
#import "TransferRecordVC.h"
#import "TransactionVC.h"
#import "MultiTransferVC.h"
#import "OrdersVC.h"
#import "ExchangeVC.h"
#import "SlideTabBarVC.h"
#import "PostAdsVC.h"
#import "HelpCentreVC.h"
#import "DataStatisticsVC.h"
#import "OrderDetailVC.h"

#import "LoginModel.h"
#import "IdentityAuthVC.h"

#import "AssetsVC.h"

#import "HomePopUpView.h"
@interface HomeVC () <HomeViewDelegate>
@property (nonatomic, strong) HomeView *mainView;
@property (nonatomic, strong) HomeVM *vm;


@end

@implementation HomeVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccessBlockMethod) name:kNotify_IsLoginOutRefresh object:nil];
//    [self YBGeneral_baseConfig];
    [self initView];
    [self.vm network_checkFixedPricesSuccess:^(id data) {
        
    } failed:^(id data) {
        
    } error:^(id data) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.navigationController.delegate = self;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self loginSuccessBlockMethod];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)initView {
    
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
//    WS(weakSelf);
    
//    __block
    [self.mainView actionBlock:^(id data, id data2) {
        
//        NSDictionary *dataModel = (NSDictionary *)data2;
//        IndexSectionType type = [dataModel[kType] integerValue];
        EnumActionTag type = [data integerValue];
        switch (type) {
            case EnumActionTag7://scan
            case EnumActionTag0:
            {
                if([self isloginBlock])return;
                if (GetUserDefaultBoolWithKey(kIsScanTip)) {
                    [ScanCodeVC pushFromVC:self];
                }else{
                    HomeScanView* scanView = [[HomeScanView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, MAINSCREEN_HEIGHT)];
//                    __weak __typeof(scanView) weakView = scanView;
                    scanView.scanBlock = ^{
                       [ScanCodeVC pushFromVC:self];
                    };
                    scanView.buyBlock = ^{
                        [self locateTabBar:1];
                    };
                    scanView.helpBlock = ^{
                        [HelpCentreVC pushFromVC:self requestParams:@1 success:^(id data) {
                            
                        }];
                    };
                    scanView.cancelBlock = ^{
                    };
//                    [self.tabBarController.view addSubview:scanView];
                    [[UIApplication sharedApplication].keyWindow addSubview:scanView];
                }
                
            }
                break;
            case EnumActionTag1:
            {
//                if([self isloginBlock])return;
                [self locateTabBar:1];
            }
                break;
            case EnumActionTag2:
            {
                if([self isloginBlock])return;
                [OrdersVC pushFromVC:self];
            }
                break;
            case EnumActionTag3:
            {
                if([self isloginBlock])return;
                [ExchangeVC pushFromVC:self];
            }
                break;
            case EnumActionTag4:
            {
                if([self isloginBlock])return;
                
                LoginModel* model = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
                LoginData* loginData = model.userinfo;
                IdentityAuthType type = [loginData getIdentityAuthType:loginData.valiidnumber];
                UserType userType = [loginData.userType intValue];
                if (userType == UserTypeSeller) {
                    if (type  == IdentityAuthTypeFinished) {
                        [PostAdsVC pushFromVC:self requestParams:@(PostAdsTypeCreate) success:^(id data) {
                            
                        }];
                    }else{
                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"亲爱的卖家，请先进行实名认证哦～" message:nil preferredStyle:  UIAlertControllerStyleAlert];
                        [alert addAction:[UIAlertAction actionWithTitle:@"稍后验证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                        }]];
                        [alert addAction:[UIAlertAction actionWithTitle:@"现在去认证" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            
                            [IdentityAuthVC pushFromVC:self requestParams:@1 success:^(id data) {
                                
                            }];
                        }]];
                        [self presentViewController:alert animated:true completion:nil];
                }
                
                }else{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"买家账号不能卖币哦～" message:nil preferredStyle:  UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    }]];
                    [self presentViewController:alert animated:true completion:nil];
                }
                
            }
                break;
            case EnumActionTag5://help
            {
                [HelpCentreVC pushFromVC:self requestParams:@1 success:^(id data) {
                    
                }];
            }
                break;
            case EnumActionTag6://remind
            {
                if([self isloginBlock])return;
                [self locateTabBar:2];
            }
                break;
            
            case EnumActionTag8://login
            {
                if([self isloginBlock])return;
            }
                break;
            case EnumActionTag9://record
            {
                if([self isloginBlock])return;
                [TransferRecordVC pushFromVC:self];
            }
                break;
            case EnumActionTag10://banner
            {
//                if([self isloginBlock])return;
                HomeBannerData *model = data2;
                [WebViewController pushFromVC:self requestUrl:model.clickUrl //data2[kTit]
                            withProgressStyle:DKProgressStyle_Gradual success:^(id data) {
                    
                }];
            }
                break;
            case EnumActionTag11://banner
            {
                [self netwoekingErrorDataRefush];
            }
                break;
            case EnumActionTag12://asset
            {
                [AssetsVC pushFromVC:self requestParams:@1 success:^(id data) {
                    
                }];
            }
                break;
            default:
                
                break;
        }
        
    }];
    
}

-(void)loginSuccessBlockMethod{
    [self homeView:self.mainView requestHomeListWithPage:1];
}
-(void)netwoekingErrorDataRefush{
    [self homeView:self.mainView requestHomeListWithPage:1];
}
#pragma mark - HomeViewDelegate

- (void)homeView:(HomeView *)view requestHomeListWithPage:(NSInteger)page {
   kWeakSelf(self);
    [self.vm network_getHomeListWithPage:page success:^(id data) {
        kStrongSelf(self);
        
        
        [self.mainView requestHomeListSuccessWithArray:data WithPage:page];
        
    } failed:^(id data) {
        kStrongSelf(self);
        if ([data isKindOfClass:[NSNumber class]]) {
            NSNumber* n= data;
            NSInteger i =  [n integerValue];
            if (i !=1) {
                if([self isloginBlock])return;
            }
        }
        [self.mainView requestHomeListFailed];
    } error:^(id data) {
        kStrongSelf(self);
        [self.mainView requestHomeListFailed];
    } ];
    [self showGuidePages];
}

#pragma mark - getter

- (HomeView *)mainView {
    if (!_mainView) {
        _mainView = [HomeView new];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (HomeVM *)vm {
    if (!_vm) {
        _vm = [HomeVM new];
    }
    return _vm;
}

- (void)showGuidePages{
    
    kWeakSelf(self);
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"FOURORDER"]) {
        [[HomeGuidePageManager shareManager] showGuidePageWithType:ABGuidePageTypeScan completion:^{
            [[HomeGuidePageManager shareManager] showGuidePageWithType:ABGuidePageTypeBuy completion:^{
                [[HomeGuidePageManager shareManager] showGuidePageWithType:ABGuidePageTypeSale completion:^{
                    [[HomeGuidePageManager shareManager] showGuidePageWithType:ABGuidePageTypeOrder completion:^{
                        kStrongSelf(self);
                        
                        [self popUpView];
                        
                    }];
                }];
            }];
        }];
    }
}


-(void)popUpView{
    
    if ([NSObject isFirstLaunchApp]) {//当日首次启动App展示
        
        HomePopUpView *popView = [[HomePopUpView alloc]init];
        [self.view addSubview:popView];
        [popView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}
//-(void)dealloc {
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:kNotify_IsLoginOutRefresh object:nil];
//}
@end
