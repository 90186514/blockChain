//
//  PageViewController.m
//  TestTabTitle
//
//  Created by Aalto on 2018/12/20..
//  Copyright © 2018年 Aalto. All rights reserved.
//

#import "IdentityAuthVC.h"
#import "IdentityAuthView.h"
#import "LoginVM.h"

#import "IdentityInfoVC.h"
#import "ApplyAuthVC.h"

#import "VicFaceViewController.h"

#import "AboutUsModel.h"

@interface IdentityAuthVC ()<IdentityAuthViewDelegate>
@property (nonatomic, strong) IdentityAuthView *mainView;
@property (nonatomic, strong) LoginVM *vm;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong) id requestParams;
@property (nonatomic, strong) LoginModel* loginModel;
@property (nonatomic,strong) AboutUsModel* aboutUsModel;
@property (nonatomic, copy) NSString* contact;
@property (nonatomic, copy) DataBlock successBlock;
@end

@implementation IdentityAuthVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id)requestParams success:(DataBlock)block
{
    IdentityAuthVC *vc = [[IdentityAuthVC alloc] init];
    vc.requestParams =requestParams;
    vc.successBlock = block;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self identityAuthView:self.mainView requestListWithPage:1];
//    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
}
//-(void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = YES;
//}
//#pragma mark —— 重写该方法以自定义系统导航栏返回按钮点击事件 
//-(void)YBGeneral_clickBackItem:(UIBarButtonItem *)item{
//    [self locateTabBar:3];
//    [self.navigationController popViewControllerAnimated:YES];
//
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"身份认证";
    
    [self initView];
    kWeakSelf(self);
    [self.vm network_helpCentreWithRequestParams:@{} success:^(id data) {
        kStrongSelf(self);
        self.aboutUsModel = data;
        self.contact = [NSString stringWithFormat:@"%@",self.aboutUsModel.qq];
        
    } failed:^(id data) {
        
    } error:^(id data) {
        
    }];
}

- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}

- (void)initView {
//    if (_mainView) {
//        [_mainView removeFromSuperview];
//    }
//    _mainView = [IdentityAuthView new];
//    _mainView.delegate = self;
//    
    [self.view addSubview:self.mainView];
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.mainView actionBlock: ^(id data) {
        IndexSectionType tag = [data[kIndexSection] intValue];
        switch (tag) {
            case IndexSectionZero:
            {
                IdentityAuthType type = [data[kType] intValue];
                if (type ==IdentityAuthTypeFinished) {
                    return ;
                }
                else if (type ==IdentityAuthTypeHandling){
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您的信息已提交，审核中...\n\n如有任何疑问请联系客服：%@",self.contact] message:nil preferredStyle:  UIAlertControllerStyleAlert];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                        [self.navigationController popViewControllerAnimated:YES];
                        if (self.block) {
                            self.block(data);
                        }
                    }]];
                    
                    [self presentViewController:alert animated:true completion:nil];
                }
                else{
                    [IdentityInfoVC pushFromVC:self requestParams:@1 success:^(id data) {
                        //                    [weakSelf identityAuthView:self.mainView requestListWithPage:1];
                    }];
                }
                
                
            }
                break;
            case IndexSectionOne:
            {
                SeniorAuthType type = [data[kType] intValue];
                if (type ==SeniorAuthTypeFinished) {
                    return ;
                }
                else if (type ==SeniorAuthTypeUndone){
                    if (self.loginModel!=nil&&[self.loginModel.userinfo.valiidnumber intValue]!= IdentityAuthTypeFinished) {
                        [YKToastView showToastText:@"请先实名认证"];
                        return;
                    }
                    [VicFaceViewController pushFromVC:self requestParams:self.loginModel.userinfo.idCardFont!=nil?self.loginModel.userinfo.idCardFont:@"" success:^(id data) {
                        
                    }];
                    
//                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"您的信息已提交，审核中...\n\n如有任何疑问请联系客服：%@",self.contact] message:nil preferredStyle:  UIAlertControllerStyleAlert];
//
//                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
////                        [self.navigationController popViewControllerAnimated:YES];
//                        if (self.block) {
//                            self.block(data);
//                        }
//                    }]];
//
//                    [self presentViewController:alert animated:true completion:nil];
                }
                
                
                
                
            }
                break;
                
            default:
                break;
        }
    }];
}

#pragma mark - IdentityAuthViewDelegate
- (void)identityAuthView:(IdentityAuthView *)view requestListWithPage:(NSInteger)page{
    kWeakSelf(self);
    [self.vm network_checkUserInfoWithRequestParams:@1 success:^(id data,id data2) {
        kStrongSelf(self);
        self.loginModel = data2;
        [self.mainView requestListSuccessWithArray:data WithPage:page];
    } failed:^(id data) {
        kStrongSelf(self);
        [self.mainView requestListFailed];
    } error:^(id data) {
        kStrongSelf(self);
        [self.mainView requestListFailed];
    }];
}

#pragma mark - getter
- (IdentityAuthView *)mainView {
    if (!_mainView) {
        _mainView = [IdentityAuthView new];
        _mainView.delegate = self;
    }
    return _mainView;
}
- (LoginVM *)vm {
    if (!_vm) {
        _vm = [LoginVM new];
    }
    return _vm;
}
@end
