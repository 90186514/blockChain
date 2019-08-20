//
//  AboutUsVC.m
//  gt
//
//  Created by 钢镚儿 on 2018/12/19.
//  Copyright © 2018年 GT. All rights reserved.
//  关于我们

#import "AboutUsVC.h"
#import "LoginVM.h"
#import "AboutUsModel.h"
@interface AboutUsVC ()
@property(nonatomic,strong)UILabel * aboutUsLab;
@property(nonatomic,strong)UILabel * UsQQ;
@property (nonatomic, strong) LoginVM* vm;
@property (nonatomic, strong) AboutUsModel* model;
@end

@implementation AboutUsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self YBGeneral_baseConfig];
    self.title = @"关于我们";
    [self initView];
    kWeakSelf(self);
    [self.vm network_aboutUsWithRequestParams:@1
                                      success:^(id data) {
                                          kStrongSelf(self);
                                          [self richElementsInView:data];
                                      } failed:^(id data) {
                                          
                                      } error:^(id data) {
                                          
                                      }];
}

- (void)richElementsInView:(AboutUsModel*)model{
    self.aboutUsLab.text = model.versioninfo.about;
    self.UsQQ.text = [NSString stringWithFormat:@"联系我们\n客服%@",model.versioninfo.contact];
}

-(void)initView{
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 5)];
    lineView.backgroundColor = COLOR_RGB(239, 238, 243, 1);
    [self.view addSubview:lineView];
    
    UILabel * versionLb = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, MAINSCREEN_WIDTH, 28)];
    versionLb.text = [NSString stringWithFormat:@"Version  %@",[YBSystemTool appVersion]];
    versionLb.font = [UIFont systemFontOfSize:20];
    versionLb.textAlignment = NSTextAlignmentCenter;
    versionLb.textColor = COLOR_RGB(155, 155, 155, 1);
    [self.view addSubview:versionLb];
    
    UIView * lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(versionLb.frame) + 30, MAINSCREEN_WIDTH, 0.5)];
    lineView1.backgroundColor = COLOR_RGB(239, 238, 243, 1);
    [self.view addSubview:lineView1];
    
    self.aboutUsLab = [[UILabel alloc] initWithFrame:CGRectMake(40 * SCALING_RATIO, CGRectGetMaxY(lineView1.frame) + 45, MAINSCREEN_WIDTH - 80 * SCALING_RATIO, 100)];
    self.aboutUsLab.font = [UIFont systemFontOfSize:18];
//    aboutUsTV.setClickable(false);
    self.aboutUsLab.text = @"BUB pay 是一个专业的数字货币支付系统，所有支付和交易均在区块链上进行，保障您的资金安全。";
    self.aboutUsLab.numberOfLines = 0;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:18],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    self.aboutUsLab.attributedText = [[NSAttributedString alloc] initWithString:self.aboutUsLab.text attributes:attributes];
    self.aboutUsLab.textColor = COLOR_RGB(57, 67, 104, 1);
    [self.view addSubview:self.aboutUsLab];
    
    UIView * lineView2 = [[UIView alloc] initWithFrame:CGRectMake(0, MAINSCREEN_HEIGHT - 107 - [YBFrameTool statusBarHeight] - [YBFrameTool navigationBarHeight], MAINSCREEN_WIDTH, 0.5)];
    lineView2.backgroundColor = COLOR_RGB(232, 233, 237, 1);
    [self.view addSubview:lineView2];
    
    self.UsQQ = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(lineView2.frame), MAINSCREEN_WIDTH, 51)];
    self.UsQQ.textColor = COLOR_RGB(85, 85, 85, 1);
    self.UsQQ.text = @"联系我们\n客服QQ";
    self.UsQQ.numberOfLines = 0;
    self.UsQQ.textAlignment = NSTextAlignmentCenter;
    self.UsQQ.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:self.UsQQ];
}

- (BOOL)canBecomeFirstResponder {
    return NO;
}
- (LoginVM *)vm {
    if (!_vm) {
        _vm = [LoginVM new];
    }
    return _vm;
}

@end
