//
//  LoginVC.m
//  gtp
//
//  Created by GT on 2019/1/2.
//  Copyright © 2019 GT. All rights reserved.
//

#import "RegisterSuccessVC.h"
#import "YBRootTabBarViewController.h"
#import "NoGoogleViewController.h"
#import "LoginVC.h"
#import "LoginVM.h"
#import <StoreKit/StoreKit.h>
#import "NoGoogleViewController.h"
@interface RegisterSuccessVC ()<SKStoreProductViewControllerDelegate>
@property (nonatomic, strong) UIImageView *decorIv;
@property (nonatomic, strong) UILabel *accLab;
@property (nonatomic, strong) UILabel* leftLab;

@property (nonatomic, strong) NSMutableArray* rightTfs;
@property (nonatomic, strong) UIButton *forgetPWBtn;

@property (nonatomic, strong) UIButton *registerBtn;

//@property (nonatomic, strong) UIButton *btn;//我已下载，去绑定
@property (nonatomic, strong) UIButton *postAdsButton;//跳过，暂不下载

//@property (nonatomic, strong) UIButton *jupmButton;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong) LoginVM* vm;

@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock successBlock;
@end

@implementation RegisterSuccessVC
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    RegisterSuccessVC *vc = [[RegisterSuccessVC alloc] init];
    vc.successBlock = block;
    vc.requestParams = requestParams;
//        UINavigationController *reNavCon = [[UINavigationController alloc]initWithRootViewController:vc];
//        [rootVC presentViewController:reNavCon animated:YES completion:nil];
    
//        [[YBNaviagtionViewController rootNavigationController] pushViewController:vc animated:true];
    
    [rootVC presentViewController:vc animated:YES completion:^{
    }];
    return vc;
}

-(void)goBack{
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:false completion:^{
        
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    [self initView];
}


- (void)initView {
    UIImage* decorImage = kIMG(@"login_top");
    _decorIv = [[UIImageView alloc]init];
    [self.view addSubview:_decorIv];
    [_decorIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX); make.top.leading.trailing.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(decorImage.size.width, 219));
    }];
    [_decorIv setContentMode:UIViewContentModeScaleAspectFill];
    
    _decorIv.clipsToBounds = YES;
    _decorIv.image = decorImage;
    
    _accLab = [[UILabel alloc]init];
    [_decorIv addSubview:_accLab];
    [_accLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.decorIv.mas_centerX);
        make.top.equalTo(self.decorIv).offset(73);
    }];

    _leftLab = [[UILabel alloc]init];
    _leftLab.text = @"A";
    _leftLab.numberOfLines = 0;
    _leftLab.textAlignment = NSTextAlignmentLeft;
//    leftLab.textColor = HEXCOLOR(0x333333);
//    leftLab.font = kFontSize(17);
    [self.view addSubview:_leftLab];
    
    [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(36);
        make.trailing.offset(-36);
        make.top.equalTo(self.accLab).offset(105);
    }];
        
    UIButton* btnleft = [[UIButton alloc]init];
    [btnleft setTitle:@"您也可以 " forState:UIControlStateNormal];
    [btnleft setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    btnleft.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnleft.titleLabel.font = kFontSize(16);
    [self.view addSubview:btnleft];
    [btnleft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(36);
        make.top.equalTo(self.leftLab.mas_bottom).offset(60);
        make.height.mas_equalTo(36);
    }];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.layer.masksToBounds = YES;
    leftButton.layer.cornerRadius = 4;
    leftButton.layer.borderWidth = 0;
    [leftButton setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal];
    [leftButton setTitle:@"绑定谷歌验证器" forState:UIControlStateNormal];
    leftButton.tag = EnumActionTag2;
    leftButton.titleLabel.font  = kFontSize(16);
    [leftButton setTitleColor:kWhiteColor forState:UIControlStateNormal] ;
    leftButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    leftButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    [leftButton addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leftButton];
    [leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(btnleft.mas_right).offset(4);;
        make.centerY.equalTo(btnleft);
        make.size.mas_equalTo(CGSizeMake(127, 36));
    }];
    
    UIButton* btnRight = [[UIButton alloc]init];
    [btnRight setTitle:@"让交易更安全" forState:UIControlStateNormal];
    [btnRight setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    btnRight.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btnRight.titleLabel.font = kFontSize(16);
    [self.view addSubview:btnRight];
    [btnRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftButton.mas_right).offset(6);
        make.centerY.equalTo(btnleft);
        make.height.mas_equalTo(36);
    }];
    
//    _btn = UIButton.new;
//    _btn.tag = EnumActionTag0;
//    _btn.adjustsImageWhenHighlighted = NO;
//    _btn.titleLabel.font = kFontSize(16);
//    [_btn setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
//    _btn.layer.masksToBounds = YES;
//    _btn.layer.cornerRadius = 20;
//    _btn.layer.borderWidth = 0;
//    //        _postAdsButton.layer.borderColor = HEXCOLOR(0x9b9b9b).CGColor;
//
//    [_btn setTitle:@"我已下载，去绑定" forState:UIControlStateNormal];
//
//    [_btn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    
//    [_btn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal];
//
//    [_btn addTarget:self action:@selector(clickItem_0:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_btn];
//    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(leftButton.mas_bottom).offset(129);//别用scrollView
//        make.centerX.equalTo(self.view);
//        make.height.mas_equalTo(@40);
//        make.width.mas_equalTo(@225);
//    }];
    
    
    _postAdsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _postAdsButton.tag = EnumActionTag0;
    _postAdsButton.adjustsImageWhenHighlighted = NO;
    _postAdsButton.titleLabel.font = kFontSize(16);
    [_postAdsButton setTitleColor:HEXCOLOR(0xffffff) forState:UIControlStateNormal];
    _postAdsButton.layer.masksToBounds = YES;
    _postAdsButton.layer.cornerRadius = 20;
    _postAdsButton.layer.borderWidth = 0;
    //        _postAdsButton.layer.borderColor = HEXCOLOR(0x9b9b9b).CGColor;
    [_postAdsButton setTitleColor: HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
//    [_postAdsButton setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal];
    
    [_postAdsButton addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_postAdsButton];
    [_postAdsButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.btn.mas_bottom).offset(10);//别用scrollView
        make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(@40);
        make.width.mas_equalTo(@225);
    }];
    
    
//    _jupmButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _jupmButton.tag = EnumActionTag1;
//    _jupmButton.hidden = YES;
//    _jupmButton.adjustsImageWhenHighlighted = NO;
//    _jupmButton.titleLabel.font = kFontSize(16);
//    [_jupmButton setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
//    _jupmButton.layer.masksToBounds = YES;
//    _jupmButton.layer.cornerRadius = 20;
//    _jupmButton.layer.borderWidth = 0;
    //        _postAdsButton.layer.borderColor = HEXCOLOR(0x9b9b9b).CGColor;
    
//    [_jupmButton setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xffffff)] forState:UIControlStateNormal];
//
//    [_jupmButton addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_jupmButton];
//    [_jupmButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.postAdsButton.mas_bottom).offset(10);//别用scrollView
//        make.centerX.equalTo(self.view);
//        make.height.mas_equalTo(@40);
//        make.width.mas_equalTo(@225);
//    }];
    
    [self richElementsInViewWithModel];
    
}
- (void)richElementsInViewWithModel{
    _accLab.text = @"注册成功！";
    _accLab.textAlignment = NSTextAlignmentCenter;
    _accLab.textColor = HEXCOLOR(0xffffff);
    _accLab.font = kFontSize(30);
    
    [_postAdsButton setTitle:@"跳过，暂不绑定" forState:UIControlStateNormal];//我已下载，去绑定
    _postAdsButton.backgroundColor = kWhiteColor;
    
    
//    [_jupmButton setTitle:@"跳过，暂不下载" forState:UIControlStateNormal];
    LoginModel* model = self.requestParams;
    //vc.requestParams  
    _leftLab.attributedText =[NSString attributedStringWithString:[NSString stringWithFormat:@"您的 UG ID 为 %@",[NSObject convertNull:model.userid]] stringColor:HEXCOLOR(0x394368) stringFont:kFontSize(20) subString:@"\n\n请妥善保存，此 ID 将作为您在 BUB 平台的重要身份凭证" subStringColor:HEXCOLOR(0x333333) subStringFont:kFontSize(16)];
}

//-(void)clickItem_0:(UIButton*)sender{
//
//    NSLog(@"我已下载，去绑定");
//
//    //跳
//}

- (void)clickItem:(UIButton*)sender{
    EnumActionTag type = sender.tag;
    switch (type) {
//        case EnumActionTag0:
//        {
////            [self vertifyGoogle];
//            if (self.successBlock) {
//                [self goBack];
//                self.successBlock(sender);
//            }
//        }
//            break;
        case EnumActionTag0:
        {
            [self goBack];
            if (self.successBlock) {
                
                self.successBlock(sender);
            }
        }
            
            break;
        case EnumActionTag2:
        {
//            [self downloadEvent];
            
            //绑定谷歌验证器
            
            [self bound];
        }
            break;
            
        default:
            break;
    }
}

-(void)bound{
    
    NoGoogleViewController *vc = [[NoGoogleViewController alloc] initWithStyle:@"present"];
    
    [self presentViewController:vc
                       animated:vc
                     completion:^{
                         
                     }];
}

- (void)vertifyGoogle{
    NoGoogleViewController * noGoogleVC = [[NoGoogleViewController alloc]initWithStyle:@"push"];
//    YBRootTabBarViewController *tabBarVc = (YBRootTabBarViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    //取出当前选中的导航控制器
//    YBNaviagtionViewController *Nav = (YBNaviagtionViewController*)[tabBarVc selectedViewController];
    [[YBNaviagtionViewController rootNavigationController] pushViewController:noGoogleVC animated:YES];
}
- (void)downloadEvent{
    NSString* appID = @"388497605";
    [SVProgressHUD show];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    SKStoreProductViewController * vc = [[SKStoreProductViewController alloc] init];
    vc.delegate = self;
    NSDictionary * dic = @{SKStoreProductParameterITunesItemIdentifier:appID};
    [vc loadProductWithParameters:dic completionBlock:^(BOOL result, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if (error) {
            
            NSLog(@"error %@ with userInfo %@", error, [error userInfo]);
            
            // 提示用户发生了错误
            // 或者通过 URL 打开 AppStore App.
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/in/app/id%@",appID]];
            //    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",appID]];
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:NULL];
            } else {
                // Fallback on earlier versions
            }
            
            
        } else {
            
            [self presentViewController:vc animated:YES completion:NULL];
        }
    }];
}

- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}

- (LoginVM *)vm {
    if (!_vm) {
        _vm = [LoginVM new];
    }
    return _vm;
}
@end


