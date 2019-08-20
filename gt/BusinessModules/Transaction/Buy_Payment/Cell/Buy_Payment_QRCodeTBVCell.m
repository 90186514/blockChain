//
//  Buy_Payment_QRCodeTBVCell.m
//  gt
//
//  Created by Administrator on 03/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "Buy_Payment_QRCodeTBVCell.h"

@interface Buy_Payment_QRCodeTBVCell (){
    
    UILabel *titleLab;
    
    UIButton *payBtn;
    
    NSString *paymentNumberStr;
    
    NSString *QRCodeStr;
}

@end

@implementation Buy_Payment_QRCodeTBVCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style
                paymentStyle:(PaywayType)paymentStyle
             reuseIdentifier:(NSString *)reuseIdentifier
                   orderType:(NSString *)orderType
                     dataDic:(NSDictionary *)dataDic{
    
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        
//        NSLog(@"QRCode = %@",dataDic[@"QRCode"]);
        
        QRCodeStr = dataDic[@"QRCode"];
        
        paymentNumberStr = dataDic[@"paymentNumber"];
        
        [self initView];
        
        switch (paymentStyle) {
            case PaywayTypeZFB:{//支付宝
                
                titleLab.text = @"使用支付宝向以下账号汇款";
                
                [payBtn setTitle:@"跳转至支付宝APP付款"
                        forState:UIControlStateNormal];
                
                [payBtn addTarget:self
                           action:@selector(Alipay:)
                 forControlEvents:UIControlEventTouchUpInside];
            }
                break;
            case PaywayTypeWX:{//微信
                
                titleLab.text = @"使用微信向以下账号汇款";
                
                [payBtn setTitle:@"跳转至微信APP付款"
                        forState:UIControlStateNormal];
                
                [payBtn addTarget:self
                           action:@selector(WechatPay:)
                 forControlEvents:UIControlEventTouchUpInside];
            }
                break;
                
            default:
                break;
        }
        
        
    }
    
    return self;
}

-(void)initView{
    
    titleLab = UILabel.new;
    
    titleLab.textColor = RGBCOLOR(51, 51, 51);
    
    titleLab.font = kFontSize(14);
    
    [self.contentView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.left.equalTo(self.contentView).offset(15);
    }];
    
    UIButton *duplicateBtn = UIButton.new;
    
    [duplicateBtn setBackgroundImage:kIMG(@"copy_blue_rightup")
                            forState:UIControlStateNormal];
    
    [duplicateBtn addTarget:self
                     action:@selector(duplicateBtnClickEvent:)
           forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:duplicateBtn];
    
    [duplicateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.contentView).offset(-15);
        
        make.size.mas_equalTo(CGSizeMake(13, 15));
        
        make.centerY.equalTo(self->titleLab);
    }];
    
    UILabel *subtitleLab = UILabel.new;
    
    NSDictionary* style = @{@"A":[UIFont fontWithName:@"PingFangSC-Regular" size:14.0],
                             @"B":[UIFont fontWithName:@"PingFangSC-Semibold" size:14.0],
                             @"a":RGBCOLOR(154, 154, 154),
                             @"b":RGBCOLOR(51, 51, 51)};
    
    subtitleLab.attributedText = [[NSString stringWithFormat:@"<A><a>付款参考号:</a></A><B><b>%@</b></B>",paymentNumberStr]
                                  attributedStringWithStyleBook:style];

    [self.contentView addSubview:subtitleLab];
    
    [subtitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(self->titleLab);
        
        make.right.equalTo(duplicateBtn.mas_left).offset(-4);
    }];
    
    UILabel *lab = UILabel.new;
    
    [NSObject cornerCutToCircleWithView:lab
                        AndCornerRadius:8];
    
    lab.backgroundColor = RGBCOLOR(246, 247, 249);
    
    [self.contentView addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(20);
        
        make.right.equalTo(self.contentView).offset(-20);
        
        make.top.equalTo(self->titleLab.mas_bottom).offset(15);
        
        make.height.mas_equalTo(@149);
    }];
    
    UIImageView *QRIMGV = UIImageView.new;
    
    //常规二维码
    QRIMGV.image = [SGQRCodeObtain generateQRCodeWithData:QRCodeStr
                                                     size:108];
    
    [self.contentView addSubview:QRIMGV];
    
    [QRIMGV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(lab);
        
        make.size.mas_equalTo(CGSizeMake(108, 108));
    }];
    
    payBtn = UIButton.new;
    
    [payBtn setBackgroundColor:RGBCOLOR(76, 127, 255)];
    
    [NSObject cornerCutToCircleWithView:payBtn
                        AndCornerRadius:6];
    
    [self.contentView addSubview:payBtn];
    
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(@40);
        
        make.left.equalTo(self.contentView).offset(30);
        
        make.right.equalTo(self.contentView).offset(-30);
        
        make.top.equalTo(lab.mas_bottom).offset(10);
    }];
}

#pragma mark —— duplicateBtn点击事件
-(void)duplicateBtnClickEvent:(UIButton *)sender{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = paymentNumberStr;
    
    if (pasteboard.string.length > 0) {
        
        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
    }
}

#pragma mark —— 跳转支付宝付款
-(void)Alipay:(UIButton *)sender{
    
    self.MyBlock(PaywayTypeZFB);
}

#pragma mark —— 跳转微信付款
-(void)WechatPay:(UIButton *)sender{
    
    self.MyBlock(PaywayTypeWX);
}


-(void)setOrderDetailModel:(OrderDetailModel *)orderDetailModel{
    
    _orderDetailModel = orderDetailModel;
}


@end
