//
//  LoginVC.m
//  gtp
//
//  Created by GT on 2019/1/2.
//  Copyright © 2019 GT. All rights reserved.
//

#import "FindPWVC.h"
#import "LoginVM.h"
#import "HadVertifyVC.h"
#import "NotYetVertifyVC.h"

#import "RealNameAuthenticationVC.h"
#import "BUBPayCodeVC.h"
#import "GoogleAuthCodeVC.h"
#import "AppealVC.h"

#import "RCDCustomerServiceViewController.h"

@interface FindPWVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UIImageView *decorIv;
@property (nonatomic, strong) UILabel *accLab;
//@property (nonatomic, strong) UIButton *contactCustomerServiceBtn;
//@property (nonatomic, strong) NSMutableArray* leftLabs;
//
//@property (nonatomic, strong) NSMutableArray* rightIvs;
//@property (nonatomic, strong) UIButton *forgetPWBtn;
//
//@property (nonatomic, strong) UIButton *registerBtn;
//
//@property (nonatomic, strong) UIButton *postAdsButton;

@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong) LoginVM* vm;

@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock successBlock;
@property (nonatomic, strong) NSMutableArray *iconMutarr;
@property (nonatomic, strong) NSMutableArray *titleMutarr;

@end

@implementation FindPWVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    FindPWVC *vc = [[FindPWVC alloc] init];
    vc.successBlock = block;
    vc.requestParams = requestParams;
//        UINavigationController *reNavCon = [[UINavigationController alloc]initWithRootViewController:vc];
//        [rootVC presentViewController:reNavCon animated:YES completion:nil];
    
//        [[YBNaviagtionViewController rootNavigationController] pushViewController:vc animated:true];
    
    [rootVC presentViewController:vc animated:YES completion:^{
    }];
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    [self initView];
}

-(void)goBack{
    //    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:false
                             completion:^{
        
    }];
    
}

- (void)initView {
    
    self.view.backgroundColor = HEXCOLOR(0XF0EFF4);
    
    UIImage* decorImage = kIMG(@"");
    _decorIv = [[UIImageView alloc]init];
    [self.view addSubview:_decorIv];
    [_decorIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.leading.trailing.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(decorImage.size.width, 64+19));//219
    }];
    [_decorIv setContentMode:UIViewContentModeScaleAspectFill];
    
    _decorIv.clipsToBounds = YES;
    _decorIv.image = decorImage;
    _decorIv.backgroundColor = kWhiteColor;

    _accLab = UILabel.new;
    _accLab.text = @"密码找回";
    [_decorIv addSubview:_accLab];
    [_accLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.decorIv.mas_centerX);
        make.top.equalTo(self.decorIv).offset(73-19);
    }];
    
    kWeakSelf(self);
    [self.view goBackButtonInSuperView:self.view leftButtonEvent:^(id data) {
        kStrongSelf(self);
        [self goBack];
    }];
    
    UITableView *tableView = UITableView.new;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.scrollEnabled = NO;
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(278);
        make.top.equalTo(self.decorIv.mas_bottom).offset(20);
    }];
}

- (void)clickItem:(UIButton*)sender{
    
    [RCDCustomerServiceViewController presentFromVC:self
                                      requestParams:@(1)
                                            success:^(id data) {

    }];
}

#pragma marks -- UITableViewDataSource && UITableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 278 / 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * identifier= @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    //自适应图片（大小）
    cell.textLabel.text = self.titleMutarr[indexPath.row];

    cell.imageView.image = [UIImage imageNamed:self.iconMutarr[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {//已完成实名认证
        
        [RealNameAuthenticationVC pushFromVC:self requestParams:@(1) success:^(id data) {
            
        }];
        
    }else if (indexPath.row == 1){//BUB支付密码找回
        
        [BUBPayCodeVC pushFromVC:self requestParams:@(1) success:^(id data) {
            
        }];
    }else if (indexPath.row == 2){//谷歌验证码找回
        [GoogleAuthCodeVC pushFromVC:self requestParams:@(1) success:^(id data) {
            
        }];
        
    }else if (indexPath.row == 3){//申诉找回
        
        [AppealVC pushFromVC:self requestParams:@(1) success:^(id data) {
            
        }];
    }
}

#pragma marks -- lazyload

-(NSMutableArray *)iconMutarr{
    
    if (!_iconMutarr) {
        _iconMutarr = NSMutableArray.array;
        [_iconMutarr addObject:@"实名认证"];
        [_iconMutarr addObject:@"BUB"];
        [_iconMutarr addObject:@"谷歌验证码找回"];
        [_iconMutarr addObject:@"申述找回"];
    }
    return _iconMutarr;
}

-(NSMutableArray *)titleMutarr{
    
    if (!_titleMutarr) {
        _titleMutarr = NSMutableArray.array;
        [_titleMutarr addObject:@"已完成实名认证"];
        [_titleMutarr addObject:@"BUB支付密码找回"];
        [_titleMutarr addObject:@"谷歌验证码找回"];
        [_titleMutarr addObject:@"申诉找回"];
    }
    
    return _titleMutarr;
}

//- (void)initView {
//    UIImage* decorImage = kIMG(@"login_top");
//    _decorIv = [[UIImageView alloc]init];
//    [self.view addSubview:_decorIv];
//    [_decorIv mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.mas_equalTo(self.view.mas_centerX);
//        make.top.leading.trailing.equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(decorImage.size.width, 219));
//    }];
//    [_decorIv setContentMode:UIViewContentModeScaleAspectFill];
//
//    _decorIv.clipsToBounds = YES;
//    _decorIv.image = decorImage;
//
//    _accLab = [[UILabel alloc]init];
//
//    _accLab.backgroundColor = [UIColor redColor];
//
//    [_decorIv addSubview:_accLab];
//    [_accLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.decorIv.mas_centerX);
//        make.top.equalTo(self.decorIv).offset(73);
//    }];
//
//
//    _postAdsButton = [UIButton buttonWithType:UIButtonTypeCustom];
////    _postAdsButton.tag = EnumActionTag0;
//    _postAdsButton.adjustsImageWhenHighlighted = NO;
//    _postAdsButton.titleLabel.font = kFontSize(17);
//    [_postAdsButton setTitleColor:HEXCOLOR(0x394368) forState:UIControlStateNormal];
////    _postAdsButton.layer.masksToBounds = YES;
////    _postAdsButton.layer.cornerRadius = 20;
////    _postAdsButton.layer.borderWidth = 0;
//    //        _postAdsButton.layer.borderColor = HEXCOLOR(0x9b9b9b).CGColor;
//
////    [_postAdsButton setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0x4c7fff)] forState:UIControlStateNormal];
//
////    [_postAdsButton addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
//    _postAdsButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//    _postAdsButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
//    [self.view addSubview:_postAdsButton];
//    [_postAdsButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        //        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15);
//        make.top.equalTo(self.view).offset(200);//别用scrollView
//        make.centerX.equalTo(self.view);
//        make.left.equalTo(self.view).offset(38);
//        make.height.mas_equalTo(@29);
////        make.width.mas_equalTo(@225);
//    }];
//
//    [self layoutAccountPublic];
//}

//-(void)layoutAccountPublic{
//    _leftLabs = [NSMutableArray array];
//    _rightIvs = [NSMutableArray array];
//
//    UIScrollView *scrollView = [UIScrollView new];
//    scrollView.scrollEnabled = NO;
//    scrollView.delegate = nil;
//
//    scrollView.userInteractionEnabled = YES;
//    [self.view addSubview:scrollView];
//    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        //        make.leading.equalTo(self.contentView).offset(30);
//        //        make.trailing.equalTo(self.contentView).offset(-30);
//        //        make.bottom.equalTo(self.contentView.mas_bottom).offset(-45);
//        //        make.top.equalTo(self.contentView).offset(47);
//        //        make.height.equalTo(@178);
//        make.edges.equalTo(self.view).with.insets(UIEdgeInsetsMake(250, 38, 255, 38));
//    }];
//
//    UIView *containView = [UIView new];
//    containView.backgroundColor = kWhiteColor;
//    [scrollView addSubview:containView];
//    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(scrollView);
//        make.width.equalTo(scrollView);
//    }];
//
//    UIView *lastView = nil;
//    for (int i = 0; i < 2; i++) {
//        UIView *sub_view = [UIView new];
//
//        UIButton* leftBtn = [[UIButton alloc]init];
//        leftBtn.tag = i;
//        leftBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [leftBtn setTitleColor:HEXCOLOR(0x232630) forState:UIControlStateNormal];
//        leftBtn.titleLabel.font = kFontSize(17);
//        [leftBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
//        [sub_view addSubview:leftBtn];
//        [_leftLabs addObject:leftBtn];
//
//
//        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.equalTo(sub_view).offset(0);
////            make.top.equalTo(sub_view).offset(19);
////            make.bottom.equalTo(sub_view).offset(-4);
//            make.centerY.equalTo(sub_view);
//            make.width.equalTo(sub_view);
//        }];
//
//
//        UIImageView* arrowIv = [[UIImageView alloc] init];
//        arrowIv.image = [UIImage imageNamed:@"btnRight"];
//        arrowIv.tag = i;
//        [sub_view addSubview:arrowIv];
//        [_rightIvs  addObject:arrowIv];
//        [arrowIv mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.trailing.equalTo(sub_view).offset(0);
//            make.centerY.equalTo(sub_view);
//            make.width.height.equalTo(@(18));
//        }];
//
//        UIImageView* line1 = [[UIImageView alloc]init];
//        [sub_view addSubview:line1];
//        line1.backgroundColor = HEXCOLOR(0xe8e9ed);
//        [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.leading.trailing.equalTo(@0);
//            make.bottom.equalTo(sub_view.mas_bottom).offset(-2);
//            make.height.equalTo(@.5);
//        }];
//
//        [containView addSubview:sub_view];
//
//        //        sub_view.layer.cornerRadius = 4;
//        //        sub_view.layer.borderWidth = 1;
//        //        sub_view.layer.masksToBounds = YES;
//
//        [sub_view mas_makeConstraints:^(MASConstraintMaker *make) {
//
//            make.left.and.right.equalTo(containView);
//
//            make.height.mas_equalTo(@(50));//*i
//
//            if (lastView)
//            {
//                make.top.mas_equalTo(lastView.mas_bottom).offset(6);//下个顶对上个底的间距=上个顶对整个视图顶的间距
//                //                //上1个
//                //                lastView.backgroundColor = HEXCOLOR(0xf2f1f6);
//                //                lastView.layer.borderColor = HEXCOLOR(0xf2f1f6).CGColor;
//            }else
//            {
//                make.top.mas_equalTo(containView.mas_top);//-15多出来scr
//
//
//            }
//
//        }];
//        //最后一个
//        //        sub_view.backgroundColor = kWhiteColor;
//        //        sub_view.layer.borderColor = HEXCOLOR(0xf2f1f6).CGColor;
//
//        lastView = sub_view;
//
//    }
//    // 最后更新containView
//    [containView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(lastView.mas_bottom).offset(0);
//    }];
//
//    kWeakSelf(self);
//    [self.view goBackButtonInSuperView:self.view leftButtonEvent:^(id data) {
//        kStrongSelf(self);
//        [self goBack];
//    }];
//
//    [self richElementsInViewWithModel];
//
//}
//- (void)richElementsInViewWithModel{
//    _accLab.text = @"密码找回";
//    _accLab.textAlignment = NSTextAlignmentCenter;
//    _accLab.textColor = HEXCOLOR(0xffffff);
//    _accLab.font = kFontSize(30);
//
//    [_postAdsButton setTitle:@"是否实名认证？" forState:UIControlStateNormal];
//
//    UIButton* lab0 = _leftLabs[0];
//    [lab0 setTitle:@"已认证" forState:UIControlStateNormal];
//    UIButton* lab1 = _leftLabs[1];
//    [lab1 setTitle:@"未认证" forState:UIControlStateNormal];
//}

//- (void)clickItem:(UIButton*)sender{
//    EnumActionTag type = sender.tag;
//    switch (type) {
//        case EnumActionTag0:
//            [self hadVertifyEvent];
//            break;
//        case EnumActionTag1:
//            [self noVertifyEvent];
//            break;
//        default:
//            break;
//    }
//
//}

//- (void)hadVertifyEvent{
//    [HadVertifyVC pushFromVC:self requestParams:@(2) success:^(id data) {
//        
//    }];
//}
//- (void)noVertifyEvent{
//    [NotYetVertifyVC pushFromVC:self requestParams:@(2) success:^(id data) {
//        
//    }];
//}
//
//- (void)actionBlock:(ActionBlock)block
//{
//    self.block = block;
//}

//- (LoginVM *)vm {
//    if (!_vm) {
//        _vm = [LoginVM new];
//    }
//    return _vm;
//}
@end


