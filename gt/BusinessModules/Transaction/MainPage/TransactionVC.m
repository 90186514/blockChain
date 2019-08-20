//
//  PageViewController.m
//  TestTabTitle
//
//  Created by Aalto on 2018/12/20..
//  Copyright © 2018年 Aalto. All rights reserved.
//

#import "TransactionVC.h"
#import "TransactionView.h"
#import "TransactionVM.h"
#import "TransactorInfoVC.h"
#import "Buy_CommitOrderVC.h"
#import "LoginModel.h"
#import "IdentityAuthVC.h"

#import "TransactionModel.h"

@interface TransactionVC ()<TransactionViewDelegate>
@property (nonatomic, strong) TransactionView *mainView;
@property (nonatomic, strong) TransactionVM *vm;
@property (nonatomic,assign)BOOL isFrist;
@property (nonatomic, copy) ActionBlock block;
@end

@implementation TransactionVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC
{
    TransactionVC *vc = [[TransactionVC alloc] init];
    
    [rootVC.navigationController pushViewController:vc
                                           animated:true];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self YBGeneral_baseConfig];
    
    _isFrist = false;
    
    [self initView];
    
    self.view.backgroundColor = kRedColor;
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(isSelectedNoTransactionTabarRefresh) name:kNotify_IsSelectedNoTransactionTabarRefresh
                                              object:nil];
}

-(void)isSelectedNoTransactionTabarRefresh{
//    [self transactionView:self.mainView requestListWithPage:1 WithFilterArr:@[]];
    [self.mainView getInitFliterStatus];
}

-(void)loginSuccessBlockMethod{
    
    [self transactionView:self.mainView requestListWithPage:1
            WithFilterArr:@[]];
}
-(void)netwoekingErrorDataRefush{
    
    [self transactionView:self.mainView requestListWithPage:1
            WithFilterArr:@[]];
}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}

- (void)initView {
//    if (_mainView) {
//        [_mainView removeFromSuperview];
//    }
//    _mainView = [TransactionView new];
//    _mainView.delegate = self;
    
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    WS(weakSelf);
    [self.mainView actionBlock: ^(id data,id data2) {
        
        NSLog(@"data = %@",data);
        
        NSLog(@"data2 = %@",data2);//TransactionData
        
        EnumActionTag tag = [data intValue];
        
        switch (tag) {
            case EnumActionTag0:
            {
                [TransactorInfoVC pushViewController:weakSelf
                                    requestParams:data2
                                            success:^(id data) {
                    
                }];
            }
                break;
            case EnumActionTag1://全部都是可以买的
            {
                if([self isloginBlock])return;
                
                LoginModel* model = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
                
                LoginData* loginData = model.userinfo;
                
                UserType userType = [loginData.userType intValue];
                
                if (userType == UserTypeSeller) {
                    
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"卖家暂不能买币哦～"
                                                                                   message:nil
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
                    }]];
                    [self presentViewController:alert
                                       animated:true
                                     completion:nil];
                }else{

                    TransactionData* itemData = data2;
                    
                    [Buy_CommitOrderVC pushFromVC:self
                                    requestParams:data2
                        withTransactionAmountType:itemData.amountType//限额还是固额？
                                  paywayOccurType:Nil
                                          success:^(id data) {
                                      
                                  }];
                }
            }
                break;
            case EnumActionTag2:
            {
                if([self isloginBlock])return;
                
                [IdentityAuthVC pushFromVC:self
                             requestParams:@1
                                   success:^(id data) {
                    
                }];
            }
                break;
            case EnumActionTag3:
            {
                [self netwoekingErrorDataRefush];
            }
                break;
            default:
                break;
        }
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    
    if(!_isFrist){
        //第一次进入,自动加载数据
//        NSLog(@"第一次进入--%@",_tag);
        _isFrist=true;
    }else{
        //不是第一次进入,不加载数据
//        NSLog(@"第二次进入--%@",_tag);
    }
//    [self initView];
    
}
#pragma mark - TransactionViewDelegate
- (void)transactionView:(TransactionView *)view
    requestListWithPage:(NSInteger)page
          WithFilterArr:(NSArray*)fliterArr{
    
    kWeakSelf(self);
    [self.vm postTransactionPageListWithPage:page
                           WithRequestParams:fliterArr
                                     success:^(id data, id data2) {
        kStrongSelf(self);
        [self.mainView requestListSuccessWithArray:data2
                                          WithPage:page
                                           WithSum:[data intValue]];
    } failed:^(id data) {
        kStrongSelf(self);
        [self.mainView requestListServiceErrorFailed];
    } error:^(id data) {
        kStrongSelf(self);
        [self.mainView requestListNetworkErrorFailed];
    }];
}

#pragma mark - getter
- (TransactionView *)mainView {
    if (!_mainView) {
        _mainView = [TransactionView new];
        _mainView.delegate = self;
    }
    return _mainView;
}

- (TransactionVM *)vm {
    if (!_vm) {
        _vm = [TransactionVM new];
    }
    return _vm;
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self
                                                   name:kNotify_IsSelectedNoTransactionTabarRefresh
                                                 object:nil];
    
}

@end
