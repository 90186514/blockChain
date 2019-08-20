//
//  GoogleAuthCodeVC.m
//  gt
//
//  Created by Administrator on 23/03/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "GoogleAuthCodeVC.h"

@interface GoogleAuthCodeVC ()


@property (nonatomic, strong) UIImageView *decorIv;
@property (nonatomic, strong) UILabel *accLab;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *tip_01;
@property (nonatomic, strong) UILabel *tip_02;
@property (nonatomic, strong) UILabel *tip_03;
@property (nonatomic, strong) UITextField *textField_01;
@property (nonatomic, strong) UITextField *textField_02;
@property (nonatomic, strong) UITextField *textField_03;
@property (nonatomic, strong) UIButton *btn_01;
@property (nonatomic, strong) UIButton *btn_02;
@property (nonatomic, strong) UIButton *btn_03;
@property (nonatomic, strong)UIButton *sendToCheck;


@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock successBlock;

@end

@implementation GoogleAuthCodeVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    GoogleAuthCodeVC *vc = [[GoogleAuthCodeVC alloc] init];
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
    [self dismissViewControllerAnimated:false completion:^{
        
    }];
}

- (void)initView {
    
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
    
    _scrollView = UIScrollView.new;
    _scrollView.backgroundColor = HEXCOLOR(0XF0EFF4);
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.decorIv.mas_bottom);
    }];
    
    _tip_01 = UILabel.new;
    _tip_01.textAlignment = NSTextAlignmentLeft;
    _tip_01.textColor = RGBCOLOR(51, 51, 51);
    _tip_01.text = @"请输入用户名";
    [_scrollView addSubview:_tip_01];
    [_tip_01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.scrollView).offset(27);
        make.top.equalTo(self.decorIv.mas_bottom).offset(26);
        make.height.mas_equalTo(22);
    }];
    
    UIView *view_01 = UIView.new;
    view_01.backgroundColor = kWhiteColor;
    [_scrollView addSubview:view_01];
    [NSObject cornerCutToCircleWithView:view_01 AndCornerRadius:8];
    [view_01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tip_01);
        make.top.equalTo(self.tip_01.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(322, 45));
    }];
    
    _textField_01 = UITextField.new;
    [NSObject cornerCutToCircleWithView:_textField_01 AndCornerRadius:8];
    _textField_01.backgroundColor = kWhiteColor;
    [view_01 addSubview:_textField_01];
    [_textField_01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tip_01);
        make.top.equalTo(self.tip_01.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(322 - 45, 45));
    }];
    
    _btn_01 = UIButton.new;
    [_btn_01 addTarget:self action:@selector(btn_01ClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [_btn_01 setImage:kIMG(@"icon_erase") forState:UIControlStateNormal];
    [view_01 addSubview:_btn_01];
    [_btn_01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(19, 19));
        make.left.equalTo(self.textField_01.mas_right).offset(10);
        make.centerY.equalTo(view_01);
    }];
    
    _tip_02 = UILabel.new;
    _tip_02.textAlignment = NSTextAlignmentLeft;
    _tip_02.textColor = RGBCOLOR(51, 51, 51);
    _tip_02.text = @"请输入谷歌验证码";
    [_scrollView addSubview:_tip_02];
    [_tip_02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField_01);
        make.size.equalTo(self.tip_01);
        make.top.equalTo(self.textField_01.mas_bottom);
    }];
    
    UIView *view_02 = UIView.new;
    view_02.backgroundColor = kWhiteColor;
    [_scrollView addSubview:view_02];
    [NSObject cornerCutToCircleWithView:view_02 AndCornerRadius:8];
    [view_02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tip_02);
        make.size.equalTo(view_01);
        make.top.equalTo(self.tip_02.mas_bottom);
    }];
    
    _textField_02 = UITextField.new;
    _textField_02.secureTextEntry= YES;
    [NSObject cornerCutToCircleWithView:_textField_02 AndCornerRadius:8];
    _textField_02.backgroundColor = kWhiteColor;
    [view_02 addSubview:_textField_02];
    [_textField_02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tip_02);
        make.size.equalTo(self.textField_01);
        make.top.equalTo(self.tip_02.mas_bottom);
    }];
    
    _btn_02 = UIButton.new;
    [_btn_02 addTarget:self action:@selector(btn_02ClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_btn_02 setImage:kIMG(@"icon_erase") forState:UIControlStateNormal];
    [view_02 addSubview:_btn_02];
    [_btn_02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(19, 19));
        make.left.equalTo(self.textField_02.mas_right).offset(10);
        make.centerY.equalTo(view_02);
    }];
    
    _tip_03 = UILabel.new;
    _tip_03.textAlignment = NSTextAlignmentLeft;
    _tip_03.textColor = RGBCOLOR(51, 51, 51);
    _tip_03.text = @"联系信箱";
    [_scrollView addSubview:_tip_03];
    [_tip_03 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textField_02);
        make.size.mas_equalTo(self.tip_02);
        make.top.equalTo(self.textField_02.mas_bottom);
    }];
    
    UIView *view_03 = UIView.new;
    view_03.backgroundColor = kWhiteColor;
    [NSObject cornerCutToCircleWithView:view_03 AndCornerRadius:8];
    [_scrollView addSubview:view_03];
    [view_03 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tip_02);
        make.size.equalTo(view_02);
        make.top.equalTo(self.tip_03.mas_bottom);
    }];
    
    _textField_03 = UITextField.new;
    [NSObject cornerCutToCircleWithView:_textField_03 AndCornerRadius:8];
    _textField_03.backgroundColor = kWhiteColor;
    [view_03 addSubview:_textField_03];
    [_textField_03 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tip_03);
        make.size.mas_equalTo(self.textField_02);
        make.top.equalTo(self.tip_03.mas_bottom);
    }];
    
    _btn_03 = UIButton.new;
    [_btn_03 addTarget:self action:@selector(btn_03ClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [_btn_03 setImage:kIMG(@"icon_erase") forState:UIControlStateNormal];
    [view_03 addSubview:_btn_03];
    [_btn_03 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(19, 19));
        make.left.equalTo(self.textField_03.mas_right).offset(10);
        make.centerY.equalTo(view_03);
    }];
    
    _sendToCheck = UIButton.new;
    [_sendToCheck addTarget:self action:@selector(sendToCheckClickEvent:) forControlEvents:UIControlEventTouchUpInside];
    _sendToCheck.backgroundColor = RGBCOLOR(114, 154, 255);
    [_sendToCheck setTitle:@"送出审核" forState:UIControlStateNormal];
    [_sendToCheck.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:16]];
    [_scrollView addSubview:_sendToCheck];
    [_sendToCheck mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(327, 42));
        //        make.top.equalTo(self.picBtn.mas_bottom).offset(15);
        make.bottom.equalTo(self.view).offset(-12);
    }];
}

-(void)btn_01ClickEvent{
    
    _textField_01.text = @"";
}

-(void)btn_02ClickEvent:(UIButton *)sender{
    
    _textField_02.text = @"";
}

-(void)btn_03ClickEvent{
    
    _textField_03.text = @"";
    
}

-(void)sendToCheckClickEvent:(UIButton *)sender{
    
    
}
@end
