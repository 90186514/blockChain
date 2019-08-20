//
//  SPCell.m
//  LiNiuYang
//
//  Created by Aalto on 2017/7/25.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "TransactionCell.h"
#import "TransactionModel.h"
//#import "IdentityAuthVC.h"

@interface TransactionCell ()
@property (nonatomic, strong) NSArray *arr;

@property (nonatomic, strong) UIImageView *decorIv;
@property (nonatomic, strong) UILabel *adIdLab;
@property (nonatomic, strong) UIButton *userNameBtn;
@property (nonatomic, strong) UIImageView *line1;

@property (nonatomic, strong) UILabel *typeLab;

@property (nonatomic, strong) UILabel *balanceLab;
@property (nonatomic, strong) UILabel *saledLab;

@property (nonatomic, strong) UIImageView *line2;

@property (nonatomic, strong) UILabel *distributeTimeLab;
@property (nonatomic, strong) UILabel *modifyTimeLab;

@property (nonatomic, strong) UILabel *statusLab;

@property (nonatomic, strong) UIButton *buyBtn;

@property (nonatomic, strong) UIView *payMethodView;
@property (nonatomic, strong) UILabel *payMethodLab;
@property (nonatomic, strong) UIImageView* zIV;
@property (nonatomic, strong) UIImageView* wIV;
@property (nonatomic, strong) UIImageView* cIV;
@property (nonatomic, strong) NSMutableArray* payIvs;
@property (nonatomic, strong) NSMutableArray* statusBtns;
@property (nonatomic, copy) ActionBlock block;
@property (nonatomic, strong) id modle;
@end

@implementation TransactionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self richEles];
    }
    return self;
}

- (void)richEles{
    _adIdLab = [[UILabel alloc]init];
    [self.contentView addSubview:_adIdLab];
    [_adIdLab mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.contentView).offset(20);
       make.top.equalTo(self.contentView).offset(15);
        make.width.height.equalTo(@22);
    }];
    
    _userNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _userNameBtn.adjustsImageWhenHighlighted = NO;
    [self.contentView addSubview:_userNameBtn];
    [_userNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.adIdLab.mas_right).offset(10);
        make.centerY.equalTo(self.adIdLab);
        make.height.equalTo(self.adIdLab);
    }];
    
    _line1 = [[UIImageView alloc]init];
    [self.contentView addSubview:_line1];
    [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.adIdLab);
       make.trailing.equalTo(@0); make.top.equalTo(self.adIdLab.mas_bottom).offset(10);
        make.height.equalTo(@.5);
    }];
    
    _typeLab = [[UILabel alloc]init];
    [self.contentView addSubview:_typeLab];
    [_typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
    make.leading.equalTo(self.adIdLab);
   make.top.equalTo(self.line1.mas_bottom).offset(8.5);
        make.height.equalTo(self.adIdLab);
//        make.width.equalTo(@190);
    }];
    
    _balanceLab = [[UILabel alloc]init];
    [self.contentView addSubview:_balanceLab];
    [_balanceLab mas_makeConstraints:^(MASConstraintMaker *make) {
       make.leading.equalTo(self.typeLab); make.top.equalTo(self.typeLab.mas_bottom).offset(10);
        make.height.equalTo(self.typeLab);
    }];

    
    _saledLab = [[UILabel alloc]init];
    [self.contentView addSubview:_saledLab];
    [_saledLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.balanceLab); make.top.equalTo(self.balanceLab.mas_bottom).offset(3);
        make.height.equalTo(self.balanceLab);
        
    }];
    
    _statusLab = [[UILabel alloc]init];
    [self.contentView addSubview:_statusLab];
    [_statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adIdLab);
        make.height.equalTo(self.adIdLab);
        make.trailing.equalTo(@-22);
    }];

    
}

- (void)clickItem:(UIButton*)button{
    if (self.block) {
        self.block(_modle);
    }
}
- (void)actionBlock:(ActionBlock)block
{
    self.block = block;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    _adIdLab.textAlignment = NSTextAlignmentCenter;
    _adIdLab.font = [UIFont boldSystemFontOfSize:15];;
    _adIdLab.textColor = HEXCOLOR(0xffffff);
    _adIdLab.layer.masksToBounds = YES;
    _adIdLab.layer.cornerRadius = 22/2;
    _adIdLab.backgroundColor = HEXCOLOR(0x4c7fff);
    
    _userNameBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _userNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_userNameBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _userNameBtn.titleLabel.font = kFontSize(15);
    _userNameBtn.titleLabel.numberOfLines = 1;
    [_userNameBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    
    _line1.backgroundColor = HEXCOLOR(0xf0f1f3);
    _typeLab.textAlignment = NSTextAlignmentCenter;
    _typeLab.font = kFontSize(13);
    _typeLab.textColor = HEXCOLOR(0x4c7fff);
    _typeLab.backgroundColor = HEXCOLOR(0xedf2ff);
    _typeLab.layer.masksToBounds = YES;
    _typeLab.layer.cornerRadius = 2;
    
    _balanceLab.textAlignment = NSTextAlignmentLeft;
    _balanceLab.font = kFontSize(14);
    _balanceLab.textColor = HEXCOLOR(0x394368);
    
    _saledLab.textAlignment = NSTextAlignmentLeft;
    _saledLab.font = kFontSize(14);
    _saledLab.textColor = HEXCOLOR(0x394368);
    
    
    _statusLab.textAlignment = NSTextAlignmentRight;
    _statusLab.font = kFontSize(13);
    _statusLab.textColor =  HEXCOLOR(0x8c96a5);
}


+(instancetype)cellWith:(UITableView*)tabelView{
    static NSString *CellIdentifier = @"TransactionCell";
    TransactionCell *cell = (TransactionCell *)[tabelView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[TransactionCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel{
    return 146;
}

- (void)richElementsInCellWithModel:(TransactionData*)model{
    _modle = model;
    
    NSString* userName = model.nickName!=nil?model.nickName:model.username!=nil?model.username:@"";
    
    [_userNameBtn setTitle:userName forState:UIControlStateNormal];
    //[NSString getAnonymousString:userName]
    [_userNameBtn setImage:[UIImage imageNamed:[model getPriorityImageName]] forState:UIControlStateNormal];
    [_userNameBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:7];
    
    _adIdLab.text = [NSString stringWithFormat:@"%@",[userName substringToIndex:1]];
    
    
    _balanceLab.text = [NSString stringWithFormat:@"单价 %@",[model getRateName]];
    _saledLab.text = [NSString stringWithFormat:@"剩余数量 %@",model.balance];
    
    _statusLab.text = [NSString stringWithFormat:@"交易量 %@  成功率 %@", model.orderAllNumber,model.successRate];
    
    [self layoutTypeLabelWithModel:model];
    [self layoutPayMethodViewsWithModel:model];
}

- (void)layoutTypeLabelWithModel:(TransactionData*)model{
    _typeLab.text = [model getTransactionAmountTypeName];
    CGFloat typeStringWidth =  [NSString getTextWidth:_typeLab.text withFontSize:kFontSize(13) withHeight:21];
    [_typeLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(typeStringWidth+6));
    }];
}

//我改的
//- (void)layoutPayMethodViewsWithModel:(TransactionData*)model{
//
//    _payIvs = [NSMutableArray array];
//
//    if (_payMethodView) {
//        [_payMethodView removeFromSuperview];
//    }
//    if (_buyBtn) {
//        [_buyBtn removeFromSuperview];
//    }
//
//    _buyBtn = [[UIButton alloc]init];
//    _buyBtn.titleLabel.numberOfLines = 0;
//    [self.contentView addSubview:_buyBtn];
//    [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.saledLab);
//        make.height.equalTo(self.saledLab);
//        make.trailing.equalTo(@-14);
//    }];
//
//    //    [_buyBtn setImage:kIMG(@"cTransAction_buyBtn") forState:UIControlStateNormal];
//
//    if (!GetUserDefaultBoolWithKey(kIsLogin)) {//？？？？
//
//        [_buyBtn setAttributedTitle:[NSString attributedStringWithString:@"点击购买"
//                                                             stringColor:HEXCOLOR(0x4c7fff)
//                                                              stringFont:kFontSize(13)
//                                                               subString:@""
//                                                          subStringColor:kClearColor
//                                                           subStringFont:kFontSize(13)]
//                           forState:UIControlStateNormal];
//
//    }else{
//
//        LoginModel* loginModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];
//
//        LoginData* loginData = loginModel.userinfo;
//
//        /**
//         *  1、实名认证 和 高级认证 (均通过) —— “点击购买”
//         *  2、实名认证 和 高级认证 (均未通过),其实就是实名认证未通过 —— “卖家要求实名认证/高级认证” 点击跳转实名认证
//         *  3、实名认证 (未通过),高级认证 (通过) —— “卖家要求实名认证” 点击跳转实名认证
//         *  4、实名认证 (通过),高级认证 (未通过) ——“卖家要求高级认证” 点击跳转高级认证
//         *  5、只要求实名认证通过 (先有实名认证,再有高级认证)
//         *  6、卖家无任何要求 —— “点击购买”
//         */
//
//        //1、实名认证 和 高级认证 (均通过) —— “点击购买”
//        if ([loginData.valiidnumber isEqualToString:@"3"]||//实名认证(通过) 0-未审核，1-待审核，2-审核未通过，3-审核通过
//            [model.isSellerSeniorAuth isEqualToString:@"1"]) {//高级认证(通过) 1-是 2-否
//
//            [_buyBtn setAttributedTitle:[NSString attributedStringWithString:@"点击购买"
//                                                                 stringColor:HEXCOLOR(0x4c7fff)
//                                                                  stringFont:kFontSize(13)
//                                                                   subString:@""
//                                                              subStringColor:kClearColor
//                                                               subStringFont:kFontSize(13)]
//                               forState:UIControlStateNormal];
//        }
//
//        //2、实名认证 和 高级认证 (均未通过),其实就是实名认证未通过 —— “卖家要求实名认证/高级认证” 点击跳转实名认证
//        if (![loginData.valiidnumber isEqualToString:@"3"]||//实名认证(未通过)
//            ![model.isSellerSeniorAuth isEqualToString:@"1"]){//高级认证(未通过)
//
//            [_buyBtn setAttributedTitle:[NSString attributedStringWithString:@"卖家要求"
//                                                                 stringColor:HEXCOLOR(0x394368)
//                                                                  stringFont:kFontSize(13)
//                                                                   subString:@"高级验证/实名认证"
//                                                              subStringColor:HEXCOLOR(0x4c7fff)
//                                                               subStringFont:kFontSize(13)]
//                               forState:UIControlStateNormal];
//        }
//
//        //3、实名认证 (未通过),高级认证 (通过) —— “卖家要求实名认证” 点击跳转实名认证
//        if (![loginData.valiidnumber isEqualToString:@"3"]||//实名认证(未通过)
//            [model.isSellerSeniorAuth isEqualToString:@"1"]) {//高级认证(通过)
//
//            [_buyBtn setAttributedTitle:[NSString attributedStringWithString:@"卖家要求"
//                                                                 stringColor:HEXCOLOR(0x394368)
//                                                                  stringFont:kFontSize(13)
//                                                                   subString:@"实名认证"
//                                                              subStringColor:HEXCOLOR(0x4c7fff)
//                                                               subStringFont:kFontSize(13)]
//                               forState:UIControlStateNormal];
//        }
//
//        //4、实名认证 (通过),高级认证 (未通过) ——“卖家要求高级认证” 点击跳转高级认证
//        if ([loginData.valiidnumber isEqualToString:@"3"]||//实名认证(通过)
//            ![model.isSellerSeniorAuth isEqualToString:@"1"]) {//高级认证(未通过)
//
//            [_buyBtn setAttributedTitle:[NSString attributedStringWithString:@"卖家要求"
//                                                                 stringColor:HEXCOLOR(0x394368)
//                                                                  stringFont:kFontSize(13)
//                                                                   subString:@"高级验证"
//                                                              subStringColor:HEXCOLOR(0x4c7fff)
//                                                               subStringFont:kFontSize(13)]
//                               forState:UIControlStateNormal];
//        }
//
//        //5、只要求实名认证通过 (先有实名认证,再有高级认证)
//        if ([loginData.valiidnumber isEqualToString:@"3"]) {//实名认证(通过)
//
//            [_buyBtn setAttributedTitle:[NSString attributedStringWithString:@"点击购买"
//                                                                 stringColor:HEXCOLOR(0x4c7fff)
//                                                                  stringFont:kFontSize(13)
//                                                                   subString:@""
//                                                              subStringColor:kClearColor
//                                                               subStringFont:kFontSize(13)]
//                               forState:UIControlStateNormal];
//        }
//
//        //6、卖家无任何要求 —— “点击购买”
//        [_buyBtn setAttributedTitle:[NSString attributedStringWithString:@"点击购买"
//                                                             stringColor:HEXCOLOR(0x4c7fff)
//                                                              stringFont:kFontSize(13)
//                                                               subString:@""
//                                                          subStringColor:kClearColor
//                                                           subStringFont:kFontSize(13)]
//                           forState:UIControlStateNormal];
//    }
//
//
//    [_buyBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
//                             imageTitleSpace:5];
//
//    _payMethodView = [[UIView alloc]init];
//    [self.contentView addSubview:_payMethodView];
//    [_payMethodView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.typeLab);
//        make.height.equalTo(self.typeLab);
//        make.trailing.equalTo(@-14);
//    }];
//    _wIV = [[UIImageView alloc] init];
//    _wIV.tag = EnumActionTag1;
//    _wIV.image = [UIImage imageNamed:@"icon_cir_weixin"];
//    [self.payMethodView addSubview:_wIV];
//
//    _zIV = [[UIImageView alloc] init];
//    _zIV.tag = EnumActionTag2;
//    _zIV.image = [UIImage imageNamed:@"icon_cir_zhifubao"];
//    [self.payMethodView addSubview:_zIV];
//
//    _cIV = [[UIImageView alloc] init];
//    _cIV.tag = EnumActionTag3;
//    _cIV.image = [UIImage imageNamed:@"icon_cir_bank"];
//    [self.payMethodView addSubview:_cIV];
//
//    _payMethodLab = [[UILabel alloc]init];
//    _payMethodLab.text = @"";//支付方式：
//    [self.payMethodView addSubview:_payMethodLab];
//
//    _payMethodLab.textAlignment = NSTextAlignmentLeft;
//    _payMethodLab.font = kFontSize(13);
//    _payMethodLab.textColor = HEXCOLOR(0x394368);
//    NSArray  *paymentways = [NSArray array];
//    if ([model.paymentway containsString:@","]) {
//        paymentways = [model.paymentway componentsSeparatedByString:@","];
//    }else{
//        paymentways = @[model.paymentway];
//    }
//
//    for (int i=0; i<paymentways.count; i++) {
//        NSInteger tag = [paymentways[i] integerValue];
//        if (tag == _wIV.tag&&![_payIvs containsObject:_wIV]) {
//            [_payIvs addObject:_wIV];
//        }
//        if (tag == _zIV.tag&&![_payIvs containsObject:_zIV]) {
//            [_payIvs addObject:_zIV];
//        }
//        if (tag == _cIV.tag&&![_payIvs containsObject:_cIV]) {
//            [_payIvs addObject:_cIV];
//        }
//    }
//
//    //    _payIvs = [@[_zIV, _wIV, _cIV]mutableCopy];
//    if (_payIvs.count == 1) {
//        [_payIvs.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.payMethodView.mas_right);
//            make.centerY.equalTo(self.payMethodView);
//            make.width.mas_equalTo(@25);
//            make.height.mas_equalTo(@25);
//        }];
//    }
//    else{
//        [_payIvs mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
//                             withFixedSpacing:5
//                                  leadSpacing:0
//                                  tailSpacing:0];
//
//        [_payIvs mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self.payMethodView);
//            make.width.mas_equalTo(@25);
//            make.height.mas_equalTo(@25);
//        }];
//    }
//    UIImageView* firstIv = (UIImageView*)_payIvs.firstObject;
//    [_payMethodLab mas_remakeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.payMethodView);
//        make.right.equalTo(firstIv.mas_left).offset(-5);
//    }];
//}

//aatlo的
- (void)layoutPayMethodViewsWithModel:(TransactionData*)model{

    _payIvs = [NSMutableArray array];

    if (_payMethodView) {
        [_payMethodView removeFromSuperview];
    }
    if (_buyBtn) {
        [_buyBtn removeFromSuperview];
    }

    _buyBtn = [[UIButton alloc]init];
    _buyBtn.titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_buyBtn];
    [_buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.saledLab);
        make.height.equalTo(self.saledLab);
        make.trailing.equalTo(@-14);
    }];

//    [_buyBtn setImage:kIMG(@"cTransAction_buyBtn") forState:UIControlStateNormal];

    if (!GetUserDefaultBoolWithKey(kIsLogin)) {

        [_buyBtn setAttributedTitle:[NSString attributedStringWithString:@"点击购买"
                                                             stringColor:HEXCOLOR(0x4c7fff)
                                                              stringFont:kFontSize(13)
                                                               subString:@""
                                                          subStringColor:kClearColor
                                                           subStringFont:kFontSize(13)]
                           forState:UIControlStateNormal];

    }else{
        
        LoginModel* loginModel = [LoginModel mj_objectWithKeyValues:GetUserDefaultWithKey(kUserInfo)];

        LoginData* loginData = loginModel.userinfo;

        if (![loginData.valiidnumber isEqualToString:@"3"]){//实名认证未审核通过 0-未审核，1-待审核，2-审核未通过，3-审核通过

            if ([model.isSellerIdNumber isEqualToString:@"1"]//商家是否实名认证  1-是 2-否 ？？？
                &&[model.isSellerSeniorAuth isEqualToString:@"1"]) {//商家通过高级认证 1-是 2-否

                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"卖家要求实名认证/高级验证"
                                                                                                     attributes:@{

                                                                                                                  NSFontAttributeName: [UIFont fontWithName:@"PingFangSC-Medium"
                                                                                                                                                       size: 13.0f],
                                                                                                                  NSForegroundColorAttributeName: [UIColor colorWithRed:76.0f / 255.0f
                                                                                                                                                                  green:127.0f / 255.0f
                                                                                                                                                                   blue:1.0f
                                                                                                                                                                  alpha:1.0f],

                                                                                                                  NSKernAttributeName: @(-0.0)
                                                                                                                                              }];
                [attributedString addAttribute:NSForegroundColorAttributeName
                                         value:[UIColor colorWithRed:57.0f / 255.0f
                                                               green:67.0f / 255.0f
                                                                blue:104.0f / 255.0f
                                                               alpha:1.0f]
                                         range:NSMakeRange(0, 4)];

                [attributedString addAttribute:NSForegroundColorAttributeName
                                         value:[UIColor colorWithRed:57.0f / 255.0f
                                                               green:67.0f / 255.0f
                                                                blue:104.0f / 255.0f
                                                               alpha:1.0f]
                                         range:NSMakeRange(8, 1)];

                [_buyBtn setAttributedTitle:attributedString
                                   forState:UIControlStateNormal];
            }

            if ([model.isSellerIdNumber isEqualToString:@"1"]//商家是否实名认证  1-是 2-否
                &&![model.isSellerSeniorAuth isEqualToString:@"1"]) {//商家通过高级认证 1-是 2-否

                [_buyBtn setAttributedTitle:[NSString attributedStringWithString:@"卖家要求"
                                                                     stringColor:HEXCOLOR(0x394368)
                                                                      stringFont:kFontSize(13)
                                                                       subString:@"实名认证"
                                                                  subStringColor:HEXCOLOR(0x4c7fff)
                                                                   subStringFont:kFontSize(13)]
                                   forState:UIControlStateNormal];
            }

            if (![model.isSellerIdNumber isEqualToString:@"1"]//商家是否实名认证  1-是 2-否
                &&![model.isSellerSeniorAuth isEqualToString:@"1"]) {//商家未通过高级认证 1-是 2-否
                [_buyBtn setAttributedTitle:[NSString attributedStringWithString:@"点击购买"
                                                                     stringColor:HEXCOLOR(0x4c7fff)
                                                                      stringFont:kFontSize(13)
                                                                       subString:@""
                                                                  subStringColor:kClearColor
                                                                   subStringFont:kFontSize(13)]
                                   forState:UIControlStateNormal];
            }
            if (![model.isSellerIdNumber isEqualToString:@"1"]//商家是否实名认证  1-是 2-否
                &&[model.isSellerSeniorAuth isEqualToString:@"1"]) {//商家通过高级认证 1-是 2-否
                [_buyBtn setAttributedTitle:[NSString attributedStringWithString:@"卖家要求"
                                                                     stringColor:HEXCOLOR(0x394368)
                                                                      stringFont:kFontSize(13)
                                                                       subString:@"高级验证"
                                                                  subStringColor:HEXCOLOR(0x4c7fff)
                                                                   subStringFont:kFontSize(13)]
                                   forState:UIControlStateNormal];
            }


        }else{//通过实名认证审核

            if ([loginData.isSeniorCertification isEqualToString:@"1"]) {//通过高级认证 1-是 2-否

                [_buyBtn setAttributedTitle:[NSString attributedStringWithString:@"点击购买"
                                                                     stringColor:HEXCOLOR(0x4c7fff)
                                                                      stringFont:kFontSize(13)
                                                                       subString:@""
                                                                  subStringColor:kClearColor
                                                                   subStringFont:kFontSize(13)]
                                   forState:UIControlStateNormal];
            }else if (![loginData.isSeniorCertification isEqualToString:@"1"]) {//通过高级认证 1-是 2-否

                if ([model.isSellerSeniorAuth isEqualToString:@"1"]) {//商家是通过高级认证 -是 2-否
                    [_buyBtn setAttributedTitle:[NSString attributedStringWithString:@"卖家要求"
                                                                         stringColor:HEXCOLOR(0x394368)
                                                                          stringFont:kFontSize(13)
                                                                           subString:@"高级验证"
                                                                      subStringColor:HEXCOLOR(0x4c7fff)
                                                                       subStringFont:kFontSize(13)]
                                       forState:UIControlStateNormal];
                }else{
                    [_buyBtn setAttributedTitle:[NSString attributedStringWithString:@"点击购买"
                                                                         stringColor:HEXCOLOR(0x4c7fff)
                                                                          stringFont:kFontSize(13)
                                                                           subString:@""
                                                                      subStringColor:kClearColor
                                                                       subStringFont:kFontSize(13)]
                                       forState:UIControlStateNormal];
                }

            }
        }


    }
    [_buyBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight
                             imageTitleSpace:5];

    _payMethodView = [[UIView alloc]init];
    [self.contentView addSubview:_payMethodView];
    [_payMethodView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLab);
        make.height.equalTo(self.typeLab);
        make.trailing.equalTo(@-14);
    }];
    _wIV = [[UIImageView alloc] init];
    _wIV.tag = EnumActionTag1;
    _wIV.image = [UIImage imageNamed:@"icon_cir_weixin"];
    [self.payMethodView addSubview:_wIV];

    _zIV = [[UIImageView alloc] init];
    _zIV.tag = EnumActionTag2;
    _zIV.image = [UIImage imageNamed:@"icon_cir_zhifubao"];
    [self.payMethodView addSubview:_zIV];

    _cIV = [[UIImageView alloc] init];
    _cIV.tag = EnumActionTag3;
    _cIV.image = [UIImage imageNamed:@"icon_cir_bank"];
    [self.payMethodView addSubview:_cIV];

    _payMethodLab = [[UILabel alloc]init];
    _payMethodLab.text = @"";//支付方式：
    [self.payMethodView addSubview:_payMethodLab];

    _payMethodLab.textAlignment = NSTextAlignmentLeft;
    _payMethodLab.font = kFontSize(13);
    _payMethodLab.textColor = HEXCOLOR(0x394368);
    NSArray  *paymentways = [NSArray array];
    if ([model.paymentway containsString:@","]) {
        paymentways = [model.paymentway componentsSeparatedByString:@","];
    }else{
        paymentways = @[model.paymentway];
    }

    for (int i=0; i<paymentways.count; i++) {
        NSInteger tag = [paymentways[i] integerValue];
        if (tag == _wIV.tag&&![_payIvs containsObject:_wIV]) {
            [_payIvs addObject:_wIV];
        }
        if (tag == _zIV.tag&&![_payIvs containsObject:_zIV]) {
            [_payIvs addObject:_zIV];
        }
        if (tag == _cIV.tag&&![_payIvs containsObject:_cIV]) {
            [_payIvs addObject:_cIV];
        }
    }

    if (_payIvs.count == 0)return;
//    _payIvs = [@[_zIV, _wIV, _cIV]mutableCopy];
    if (_payIvs.count == 1) {
        [_payIvs.firstObject mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.equalTo(self.payMethodView.mas_right);
            make.centerY.equalTo(self.payMethodView);
            make.width.mas_equalTo(@25);
            make.height.mas_equalTo(@25);
        }];
    }
    else{
        [_payIvs mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                             withFixedSpacing:5
                                  leadSpacing:0
                                  tailSpacing:0];

        [_payIvs mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.payMethodView);
            make.width.mas_equalTo(@25);
            make.height.mas_equalTo(@25);
        }];
    }
    UIImageView* firstIv = (UIImageView*)_payIvs.firstObject;
    [_payMethodLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payMethodView);
        make.right.equalTo(firstIv.mas_left).offset(-5);
    }];
}


@end
