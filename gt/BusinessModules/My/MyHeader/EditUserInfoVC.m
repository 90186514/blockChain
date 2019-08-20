//
//  EditUserInfoVC.m
//  gt
//
//  Created by cookie on 2018/12/26.
//  Copyright © 2018 GT. All rights reserved.
//

#import "EditUserInfoVC.h"
#import "LoginModel.h"
#import "LoginVM.h"
#import "ChangeNicknameVC.h"
@interface EditUserInfoVC ()

@property (nonatomic, strong)UIButton *editNameBtn;
@property (nonatomic, strong) LoginVM* vm;

@property (nonatomic, strong) LoginModel* requestParams;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, copy)NSString * nickName;
@end

@implementation EditUserInfoVC


#pragma mark - life cycle
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    EditUserInfoVC *vc = [[EditUserInfoVC alloc] init];
    vc.block = block;
    vc.requestParams = requestParams;
    [rootVC.navigationController pushViewController:vc animated:true];
    return vc;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    kWeakSelf(self);
    [self.vm network_checkUserInfoWithRequestParams:@1 success:^(id data,id data2) {
        kStrongSelf(self);
        LoginModel * model = data2;
        self.nickName = model.userinfo.nickname;
        [self.editNameBtn setTitle:self.nickName  forState:UIControlStateNormal];
        
    } failed:^(id data) {
        //        kStrongSelf(self);
        
    } error:^(id data) {
        //        kStrongSelf(self);
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"个人信息";
    [self initView];
}

-(void)initView{
    UIView * lineOne = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 5)];
    lineOne.backgroundColor = [UIColor colorWithRed:242.0/256 green:241.0/256 blue:246.0/256 alpha:1];
    [self.view addSubview:lineOne];
    
    UIImageView * headerImg = [[UIImageView alloc] initWithFrame:CGRectMake(155 * SCALING_RATIO, 22 * SCALING_RATIO, 65 * SCALING_RATIO, 65 * SCALING_RATIO)];
    [headerImg setImageWithURL:[NSURL URLWithString:_requestParams.userinfo.useravator] placeholderImage:[UIImage imageNamed:@"default_circle_avator"]];
    [self.view addSubview:headerImg];
    headerImg.layer.cornerRadius = 65 * SCALING_RATIO / 2;
    headerImg.layer.masksToBounds = YES;
    NSArray * titleArr = @[@"ID",@"昵称  (点击修改)",@"用户名"];
    NSArray * contentArr = @[[NSString stringWithFormat:@"%@",_requestParams.userinfo.userid],
                             @"",[NSString stringWithFormat:@"%@",_requestParams.userinfo.username]];

    
    for (int i = 0; i < 3; i ++){
        UIButton * titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(26, CGRectGetMaxY(headerImg.frame) + 33 + (50 * i), 200, 24)];
        [titleBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        [titleBtn setTitleColor:HEXCOLOR(0x232630) forState:UIControlStateNormal];
        titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
//        [titleBtn sizeToFit];
        titleBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        [self.view addSubview:titleBtn];
        
        if (i == 1) {
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:titleArr[i]];
            [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(4, 6)];
            [attrStr addAttribute:NSForegroundColorAttributeName value:COLOR_RGB(198, 198, 198, 1) range:NSMakeRange(4,6)];
            [titleBtn setAttributedTitle:attrStr forState:UIControlStateNormal];
            [titleBtn addTarget:self action:@selector(editNameTFEvent) forControlEvents:UIControlEventTouchUpInside];
            self.editNameBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleBtn.frame) + 10, titleBtn.frame.origin.y, MAINSCREEN_WIDTH - CGRectGetMaxX(titleBtn.frame) - 10 - 16, 24)];
            [self.editNameBtn setTitle:contentArr[i] forState:UIControlStateNormal] ;
            self.editNameBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            self.editNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [self.editNameBtn setTitleColor:COLOR_RGB(102, 102, 102, 1) forState:UIControlStateNormal];
            [self.view addSubview:self.editNameBtn];
            [self.editNameBtn addTarget:self action:@selector(editNameTFEvent) forControlEvents:UIControlEventTouchUpInside];
        }else{
            
            UIButton * contentBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleBtn.frame) + 10, titleBtn.frame.origin.y, MAINSCREEN_WIDTH - CGRectGetMaxX(titleBtn.frame) - 10 - 16, 24)];
            [contentBtn setTitle:contentArr[i] forState:UIControlStateNormal] ;
            contentBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            contentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            [contentBtn setTitleColor:COLOR_RGB(102, 102, 102, 1) forState:UIControlStateNormal];
            [self.view addSubview:contentBtn];
        }
        
        UIView * lineTwo = [[UIView alloc] initWithFrame:CGRectMake(26, CGRectGetMaxY(titleBtn.frame) + 5, MAINSCREEN_WIDTH - 26, 1)];
        lineTwo.backgroundColor = [UIColor colorWithRed:242.0/256 green:241.0/256 blue:246.0/256 alpha:1];
        [self.view addSubview:lineTwo];
        
    }
    
    WS(weakSelf);
    [self.view bottomSingleButtonInSuperView:self.view WithButtionTitles:@"退出登录" leftButtonEvent:^(id data) {
        [weakSelf logOutBtnClick];
    }];
    
    
}
-(void)editNameTFEvent{
//    WS(weakSelf);
    [ChangeNicknameVC pushFromVC:self requestParams:self.nickName success:^(id data) {
//        [weakSelf.editNameBtn setTitle:data forState:UIControlStateNormal];
    }];
}
-(void)logOutBtnClick{
    kWeakSelf(self);
    [self.vm network_getLoginOutWithRequestParams:@1
                                       success:^(id model) {
                                           kStrongSelf(self);
                                           if (self.block) {
                                               [weakself locateTabBar:0];
                                               //befor block set userStatus
                                               self.block(model);
                                           }
                                           
                                       }
                                        failed:^(id model){
                                            
                                        }
                                         error:^(id model){
                                             
                                         }];
}

- (LoginVM *)vm {
    if (!_vm) {
        _vm = [LoginVM new];
    }
    return _vm;
}
@end
