//
//  ApplyForCheckingVC.m
//  gt
//
//  Created by Administrator on 25/03/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "ApplyForCheckingVC.h"

@interface ApplyForCheckingVC ()

@property (nonatomic, strong) UIImageView *decorIv;
@property (nonatomic, strong) UIImageView *iconIMGV;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *tipLab_01;
@property (nonatomic, strong) UILabel *tipLab_02;
@property (nonatomic, strong) UIButton *contactCustomerServiceBtn;

@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock successBlock;

@end

@implementation ApplyForCheckingVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    ApplyForCheckingVC *vc = [[ApplyForCheckingVC alloc] init];
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
    
    UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeClick:)];
    downSwipe.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self.view addGestureRecognizer:downSwipe];
    
    UIImage* decorImage = kIMG(@"申请审核中背景@2x");
    _decorIv = [[UIImageView alloc]init];
    [self.view addSubview:_decorIv];
    [_decorIv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.leading.trailing.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(decorImage.size.width, 343+20));
    }];
    [_decorIv setContentMode:UIViewContentModeScaleAspectFill];
    
    _decorIv.clipsToBounds = YES;
    _decorIv.image = decorImage;
    _decorIv.backgroundColor = kWhiteColor;
    
    _iconIMGV = UIImageView.new;
    _iconIMGV.image = [UIImage imageNamed:@"申请审核中"];
    [_decorIv addSubview:_iconIMGV];
    [_iconIMGV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.decorIv);
        make.size.mas_equalTo(CGSizeMake(96, 96));
    }];
    
    _titleLab = UILabel.new;
    _titleLab.text = @"申请审核中";
    _titleLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:32];
    _titleLab.textColor = kWhiteColor;
    [_decorIv addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.iconIMGV.mas_bottom).offset(17);
        make.size.mas_equalTo(CGSizeMake(160, 45));
    }];
    
//    [_contactCustomerServiceBtn setAttributedTitle:[NSString attributedStringWithString:@"有任何问题请" stringColor:HEXCOLOR(0x666666) stringFont:kFontSize(15) subString:@"联系客服" subStringColor:HEXCOLOR(0x4c7fff) subStringFont:kFontSize(15) ] forState:UIControlStateNormal]
    
    _tipLab_01 = UILabel.new;
    _tipLab_01.text = @"您的订单号为Aa00012";
    _tipLab_01.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    [self.view addSubview:_tipLab_01];
    [_tipLab_01 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.equalTo(self.decorIv.mas_bottom).offset(67);
        make.size.mas_equalTo(CGSizeMake(181, 20));
    }];
    
    _tipLab_02 = UILabel.new;
    _tipLab_02.numberOfLines = 0;
    _tipLab_02.text = @"币友团队将会在7个工作日内审核文称,并将结果传中\n至您的信箱,请耐心等候,谢谢。";
    _tipLab_02.textColor = RGBCOLOR(102, 102, 102);
    _tipLab_02.textAlignment = NSTextAlignmentCenter;
    _tipLab_02.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    [self.view addSubview:_tipLab_02];
    [_tipLab_02 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipLab_01.mas_bottom).offset(9);
        make.centerX.equalTo(self.view);
    }];
    
    _contactCustomerServiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _contactCustomerServiceBtn.tag = EnumActionTag2;
    _contactCustomerServiceBtn.adjustsImageWhenHighlighted = NO;
    _contactCustomerServiceBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
    [_contactCustomerServiceBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_contactCustomerServiceBtn];
    [_contactCustomerServiceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-40);
        make.leading.equalTo(self.view);
        make.trailing.equalTo(self.view);
        make.height.mas_equalTo(@41);
    }];
    
    [_contactCustomerServiceBtn setAttributedTitle:[NSString attributedStringWithString:@"有任何问题请" stringColor:HEXCOLOR(0x666666) stringFont:kFontSize(15) subString:@"联系客服" subStringColor:HEXCOLOR(0x4c7fff) subStringFont:kFontSize(15) ] forState:UIControlStateNormal];
}

- (void)clickItem:(UIButton*)sender{
    
    NSLog(@"111");
}

-(void)swipeClick:(UISwipeGestureRecognizer *)swpie{
    [self dismissViewControllerAnimated:false completion:^{
        
    }];
}


@end
