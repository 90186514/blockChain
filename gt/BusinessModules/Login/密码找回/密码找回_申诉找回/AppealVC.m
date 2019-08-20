//
//  AppealVC.m
//  gt
//
//  Created by Administrator on 23/03/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "AppealVC.h"

@interface AppealVC ()

@property (nonatomic, strong) UIImageView *decorIv;
@property (nonatomic, strong) UILabel *accLab;




@property (nonatomic, strong) id requestParams;
@property (nonatomic, copy) DataBlock successBlock;

@end

@implementation AppealVC

+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block
{
    AppealVC *vc = [[AppealVC alloc] init];
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
    

    
}


@end
