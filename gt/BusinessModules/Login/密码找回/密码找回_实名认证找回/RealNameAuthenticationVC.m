//
//  RealNameAuthenticationVC.m
//  gt
//
//  Created by Administrator on 23/03/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "RealNameAuthenticationVC.h"
#import "ApplyForCheckingVC.h"

#import "LeePhotoOrAlbumImagePicker.h"

@interface RealNameAuthenticationVC ()

@property (nonatomic, strong) UIImageView *decorIv;
@property (nonatomic, strong) UILabel *accLab;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock successBlock;

@property (nonatomic, strong)UITextField *userTF;
@property (nonatomic, strong)UITextField *nameTF;
@property (nonatomic, strong)UITextField *idTF;
@property (nonatomic, strong)UITextField *mailTF;

@property (nonatomic, strong)UILabel *checkLab;//y反馈用户名是否存在
@property (nonatomic, strong)UILabel *tipLab;//请上传手持身份证照片
@property (nonatomic, strong)UIButton *picBtn;
@property (nonatomic, strong)UIImageView *imgView;
@property (nonatomic, strong)UIButton *sendToCheck;

@property(nonatomic,strong)LeePhotoOrAlbumImagePicker *pickerController;
@property(nonatomic,strong)UIImage *image;

@end

@implementation RealNameAuthenticationVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    RealNameAuthenticationVC *vc = [[RealNameAuthenticationVC alloc] init];
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

- (void)initView {
    
    self.view.backgroundColor = HEXCOLOR(0XF0EFF4);
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeClick:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:rightSwipe];
    
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
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.decorIv.mas_bottom);
    }];
    
    _userTF = UITextField.new;
    _userTF.backgroundColor = kWhiteColor;
    _userTF.placeholder = @"请输入用户名:";
    [_scrollView addSubview:_userTF];
    [_userTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(@49);
        make.width.mas_equalTo(@345);
        make.top.equalTo(self.decorIv.mas_bottom).offset(20);
    }];
    
    _checkLab = UILabel.new;
    
    _nameTF = UITextField.new;
    _nameTF.backgroundColor = kWhiteColor;
    _nameTF.placeholder = @"姓名:";
    [_scrollView addSubview:_nameTF];
    [_nameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(@49);
        make.width.mas_equalTo(@345);
        make.top.equalTo(self.userTF.mas_bottom).offset(20);
    }];
    
    _idTF = UITextField.new;
    _idTF.backgroundColor = kWhiteColor;
    _idTF.placeholder = @"身份证号:";
    [_scrollView addSubview:_idTF];
    [_idTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(@49);
        make.width.mas_equalTo(@345);
        make.top.equalTo(self.nameTF.mas_bottom).offset(20);
    }];
    
    _mailTF = UITextField.new;
    _mailTF.backgroundColor = kWhiteColor;
    _mailTF.placeholder = @"联系邮箱:";
    [_scrollView addSubview:_mailTF];
    [_mailTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(@49);
        make.width.mas_equalTo(@345);
        make.top.equalTo(self.idTF.mas_bottom).offset(20);
    }];
    
    _tipLab = UILabel.new;
    _tipLab.text = @"请上传手持身份证照片:";
//    _tipLab.backgroundColor = kRedColor;
    _tipLab.textAlignment = NSTextAlignmentLeft;
    [_tipLab sizeToFit];
    [_scrollView addSubview:_tipLab];
    [_tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mailTF);
        make.height.mas_equalTo(@17);
//        make.width.mas_equalTo(@120);
        make.top.equalTo(self.mailTF.mas_bottom).offset(15);
    }];
    
    _picBtn = UIButton.new;
    [_picBtn addTarget:self action:@selector(picForHandinIDCardClickEvent) forControlEvents:UIControlEventTouchUpInside];
    _picBtn.backgroundColor = kWhiteColor;
    [_scrollView addSubview:_picBtn];
    [_picBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.height.mas_equalTo(@220);
        make.width.mas_equalTo(@345);
        make.top.equalTo(self.tipLab.mas_bottom).offset(15);
    }];
    
    _imgView = UIImageView.new;
    _imgView.image = [UIImage imageNamed:@"手持身份证"];
    [_scrollView addSubview:_imgView];
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.picBtn).offset(38);
        make.left.equalTo(self.picBtn).offset(33);
        make.right.equalTo(self.picBtn).offset(-35);
        make.bottom.equalTo(self.picBtn).offset(-38);
    }];
    
    _sendToCheck = UIButton.new;
    [_sendToCheck addTarget:self action:@selector(sendToCheckClickEvent) forControlEvents:UIControlEventTouchUpInside];
    _sendToCheck.backgroundColor = RGBCOLOR(114, 154, 255);
    [_sendToCheck setTitle:@"送出审核" forState:UIControlStateNormal];
    [_sendToCheck.titleLabel setFont:[UIFont fontWithName:@"PingFang-SC-Medium" size:16]];
    [_scrollView addSubview:_sendToCheck];
    [_sendToCheck mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(327, 42));
        make.top.equalTo(self.picBtn.mas_bottom).offset(15);
    }];
}

#pragma marks -- 手持身份证相片
-(void)picForHandinIDCardClickEvent{
    
    self.pickerController = [[LeePhotoOrAlbumImagePicker alloc]init];
    
    kWeakSelf(self);
    
    [self.pickerController getPhotoAlbumOrTakeAPhotoWithController:self
                                                        photoBlock:^(UIImage *img) {
                                                            //回掉图片
                                                            NSLog(@"%@",img);
                                                            
                                                            weakself.imgView.image = img;
                                                        }];
}

#pragma marks -- 送出审核
-(void)sendToCheckClickEvent{
    
    [ApplyForCheckingVC pushFromVC:self requestParams:@(1) success:^(id data) {
        
    }];
}

-(void)goBack{
    //    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:false completion:^{
        
    }];
}

-(void)swipeClick:(UISwipeGestureRecognizer *)swpie{
    
    [self goBack];
}

@end
