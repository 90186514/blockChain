//
//  Buy_ContentTBVCell.m
//  gt
//
//  Created by Administrator on 31/03/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "Buy_CommitOrder_ContentTBVCell.h"

@interface Buy_CommitOrder_ContentTBVCell(){
    
    UILabel *nickname;
    
    UILabel *businessVolumeLab;
    
    UILabel *successRateLab;
    
    UILabel *profilePhotoLab;
}

@property(nonatomic,strong)NSMutableArray *titleLabMutArr;

@property(nonatomic,strong)NSMutableArray *titleMenuDetailMutArr;

@property(nonatomic,strong)NSMutableArray *paymentTermMutArr;

@property(nonatomic,strong)NSMutableArray *lab02MutArr;

@property (nonatomic, copy) ActionBlock block;

@end

@implementation Buy_CommitOrder_ContentTBVCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                  amountType:(TransactionAmountType)type//金额类型 : 1、限额 2、固额
                  paymentway:(NSString *)paymentway{
    
    if ([super initWithStyle:style
             reuseIdentifier:reuseIdentifier]) {
        
        [self setupData:paymentway];
        
        [self dataInit:type];
        
        [self initView];
    }
    
    return self;
}

-(void)setupData:(NSString *)paymentWay{
    
    //1、微信 ;2、支付宝 ;3、银行卡
    if ([paymentWay containsString:@"1"]||
        [paymentWay containsString:@"2"]||
        [paymentWay containsString:@"3"]) {
        
        if ([paymentWay containsString:@"1"]&&
            [paymentWay containsString:@"2"]&&
            [paymentWay containsString:@"3"]) {//支付宝、微信、银行卡
            
            [self.paymentTermMutArr addObject:@"icon_cir_zhifubao"];//支付宝图标
            
            [self.paymentTermMutArr addObject:@"icon_cir_weixin"];//微信图标
            
            [self.paymentTermMutArr addObject:@"icon_cir_bank"];//银行卡

        }else if ([paymentWay containsString:@"1"]&&
                  [paymentWay containsString:@"2"]){//微信、支付宝
            
            [self.paymentTermMutArr addObject:@"icon_cir_zhifubao"];//支付宝图标
            
            [self.paymentTermMutArr addObject:@"icon_cir_weixin"];//微信图标
            
        }else if ([paymentWay containsString:@"1"]&&
                  [paymentWay containsString:@"3"]){//微信、银行卡
            
            [self.paymentTermMutArr addObject:@"icon_cir_weixin"];//微信图标
            
            [self.paymentTermMutArr addObject:@"icon_cir_bank"];//银行卡
        }else if ([paymentWay containsString:@"2"]&&
                  [paymentWay containsString:@"3"]){//支付宝、银行卡
            
            [self.paymentTermMutArr addObject:@"icon_cir_zhifubao"];//支付宝图标
            
            [self.paymentTermMutArr addObject:@"icon_cir_bank"];//银行卡
        }else if ([paymentWay containsString:@"1"]){//微信
            
            [self.paymentTermMutArr addObject:@"icon_cir_weixin"];//微信图标
            
        }else if ([paymentWay containsString:@"2"]){//支付宝
            
            [self.paymentTermMutArr addObject:@"icon_cir_zhifubao"];//支付宝图标
        }else if ([paymentWay containsString:@"3"]){//银行卡
            
            [self.paymentTermMutArr addObject:@"icon_cir_bank"];//银行卡
        }
    }
}

-(void)dataInit:(TransactionAmountType)type{
    
    self.type = type;
    
    switch (type) {
        case TransactionAmountTypeFixed:
            
            [self.titleMenuDetailMutArr addObject:@"固定额度"];
            
            [self.titleMenuDetailMutArr addObject:@"单价"];
            
            [self.titleMenuDetailMutArr addObject:@"卖家支持收款方式"];
            
            break;
            
        case TransactionAmountTypeLimit:
            
            [self.titleMenuDetailMutArr addObject:@"剩余可购买数量"];
            
            [self.titleMenuDetailMutArr addObject:@"单次购买限额"];
            
            [self.titleMenuDetailMutArr addObject:@"单价"];
            
            [self.titleMenuDetailMutArr addObject:@"卖家支持收款方式"];
            
            break;
            
        default:
            break;
    }
}

-(void)initView{
    
    UILabel *titleLab = UILabel.new;
    
    titleLab.text = @"卖家信息";
    
    titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium"
                                    size:15];
    
    [self.contentView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(10);
        
        make.left.equalTo(self.contentView).offset(15);
    }];
    
    UILabel *tipLab = UILabel.new;

    NSDictionary* style1 = @{@"body":[UIFont fontWithName:@"PingFangSC-Medium" size:12.0],
                             @"orange":RGBCOLOR(255, 146, 56),
                             };

    tipLab.attributedText = [@"<body>该卖家需要你在<orange>10</orange> 分钟内完成付款</body>" attributedStringWithStyleBook:style1];
    
    [self.contentView addSubview:tipLab];
    
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(titleLab);
        
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    //分割线
    UILabel *segmentationLab_01 = UILabel.new;
    
    segmentationLab_01.backgroundColor = RGBCOLOR(240, 241, 243);
    
    [self.contentView addSubview:segmentationLab_01];
    
    [segmentationLab_01 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(@1);
        
        make.top.equalTo(titleLab.mas_bottom).offset(10);
        
        make.left.equalTo(titleLab.mas_left);
        
        make.right.equalTo(tipLab.mas_right);
    }];
    
    //圆形头像
    profilePhotoLab = UILabel.new;
    
    profilePhotoLab.textAlignment = NSTextAlignmentCenter;
    
    profilePhotoLab.textColor = HEXCOLOR(0xffffff);

    profilePhotoLab.backgroundColor = HEXCOLOR(0x4c7fff);
    
    [NSObject cornerCutToCircleWithView:profilePhotoLab
                        AndCornerRadius:40 / 2];
    
    [self.contentView addSubview:profilePhotoLab];
    
    [profilePhotoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(segmentationLab_01);
        
        make.top.equalTo(segmentationLab_01.mas_bottom).offset(13);
        
        make.size.mas_equalTo(CGSizeMake(40,40));
    }];
    
    //昵称
    nickname = UILabel.new;
    
    nickname.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    
    [self.contentView addSubview:nickname];
    
    [nickname mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self->profilePhotoLab.mas_right).offset(12);
        
        make.top.equalTo(self->profilePhotoLab);
        
        make.bottom.equalTo(self->profilePhotoLab.mas_centerY);
    }];
    
    //交易量 成功率
    businessVolumeLab = UILabel.new;
    
    businessVolumeLab.textColor = RGBCOLOR(140, 150, 165);
    
    businessVolumeLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    
    [self.contentView addSubview:businessVolumeLab];
    
    [businessVolumeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self->nickname);
        
        make.top.equalTo(self->profilePhotoLab.mas_centerY);
        
        make.bottom.equalTo(self->profilePhotoLab);
    }];
    
    successRateLab = UILabel.new;
    
//    successRateLab.text = @"成功率:99%";
    
    successRateLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    
    successRateLab.textColor = RGBCOLOR(140, 150, 165);
    
    [self.contentView addSubview:successRateLab];
    
    [successRateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(self->businessVolumeLab);
        
        make.left.equalTo(self->businessVolumeLab.mas_right).offset(8);
    }];
    
    //三个状态标签:实名、人脸认证、认证商家
    for (int w = 0; w < 3; w++) {
        
        UILabel *lab = UILabel.new;
        
        lab.text = self.titleLabMutArr[w];
        
        lab.textColor = kWhiteColor;
        
        lab.textAlignment = NSTextAlignmentCenter;
        
        lab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];

        lab.backgroundColor = [UIColor colorWithRed:0.65
                                              green:0.72
                                               blue:0.79
                                              alpha:1.00];
        
        [self.contentView addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self->profilePhotoLab);
            
            make.bottom.equalTo(self->profilePhotoLab.mas_centerY);
            
            if (w == 0) {
                
                make.left.equalTo(self->nickname.mas_right).offset(8);
                
                make.width.mas_equalTo(@34);
            }else{
                
                make.left.equalTo(self->nickname.mas_right).offset(8 * (w + 1) + 34 + 54 * (w - 1));
                
                make.width.mas_equalTo(@54);
            }
        }];
    }
    
    //分割线
    UILabel *segmentationLab_02 = UILabel.new;
    
    segmentationLab_02.backgroundColor = RGBCOLOR(240, 241, 243);
    
    [self.contentView addSubview:segmentationLab_02];
    
    [segmentationLab_02 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(@1);
        
        make.top.equalTo(self->profilePhotoLab.mas_bottom).offset(10);
        
        make.left.equalTo(self->profilePhotoLab.mas_left);
        
        make.right.equalTo(tipLab.mas_right);
    }];
    
    //子菜单标题及其对应的值
    for (int f = 0; f < self.titleMenuDetailMutArr.count; f++) {
        
        UILabel *lab_01 = UILabel.new;//左边的标题
        
        lab_01.textAlignment = NSTextAlignmentCenter;
        
        lab_01.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        
        lab_01.textColor = RGBCOLOR(140, 150, 165);
        
        lab_01.text = self.titleMenuDetailMutArr[f];
        
        [self.contentView addSubview:lab_01];
        
        [lab_01 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self->profilePhotoLab);
            
            make.height.mas_equalTo(@13);
            
            make.top.equalTo(segmentationLab_02.mas_bottom).offset(12 + (13 + 15) * f);
        }];
        
        UILabel *lab_02 = UILabel.new;
        
        if (f == self.titleMenuDetailMutArr.count - 1) {
            
            for (int e = 0; e < self.paymentTermMutArr.count; e++) {
                
                UIImageView *imgView = UIImageView.new;
                
                imgView.image = [UIImage imageNamed:(NSString *)self.paymentTermMutArr[self.paymentTermMutArr.count - 1 - e]];
    
                [lab_02 addSubview:imgView];
                
                [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.right.equalTo(lab_02).offset(-(22 + 8) * e);
                    
                    make.size.mas_equalTo(CGSizeMake(22, 22));
                    
                    make.centerY.equalTo(lab_02);
                }];
            }
        }else{
            
//            lab_02.backgroundColor = RandomColor;
            
//            lab_02.text = @"text";
        }
        
        [self.lab02MutArr addObject:lab_02];

        [self.contentView addSubview:lab_02];
        
        [lab_02 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(segmentationLab_02);
            
            make.height.top.equalTo(lab_01);
        }];
    }
}

#pragma mark - lazyload

-(NSMutableArray *)titleLabMutArr{
    
    if (!_titleLabMutArr) {
        
        _titleLabMutArr = NSMutableArray.array;
        
        [_titleLabMutArr addObject:@"实名"];
        
        [_titleLabMutArr addObject:@"人脸认证"];
        
        [_titleLabMutArr addObject:@"认证商家"];
    }
    
    return _titleLabMutArr;
}

-(NSMutableArray *)titleMenuDetailMutArr{

    if (!_titleMenuDetailMutArr) {

        _titleMenuDetailMutArr = NSMutableArray.array;
    }

    return _titleMenuDetailMutArr;
}

-(NSMutableArray *)lab02MutArr{
    
    if (!_lab02MutArr) {
        
        _lab02MutArr = NSMutableArray.array;
    }
    
    return _lab02MutArr;
}

-(NSMutableArray *)paymentTermMutArr{
    
    if (!_paymentTermMutArr) {
        
        _paymentTermMutArr = NSMutableArray.array;
    }
    
    return _paymentTermMutArr;
}

- (void)actionBlock:(ActionBlock)block{
    
    self.block = block;
}

-(void)setNameStr:(NSString *)nameStr{
    
    _nameStr = nameStr;
    
    nickname.text = _nameStr;//@"昵称Link";
    
    profilePhotoLab.text = [NSString stringWithFormat:@"%@",[_nameStr substringToIndex:1]];
}

-(void)setVolumeOfBusinessStr:(NSString *)volumeOfBusinessStr{
    
    _volumeOfBusinessStr = volumeOfBusinessStr;
    
    businessVolumeLab.text = _volumeOfBusinessStr;
}

-(void)setSuccessRateStr:(NSString *)successRateStr{
    
    _successRateStr = successRateStr;
    
    successRateLab.text = _successRateStr;
}

//下面三个变换

-(void)setSurplusPurchasableNumStr:(NSString *)surplusPurchasableNumStr{//第一个
    
    _surplusPurchasableNumStr = surplusPurchasableNumStr;

    UILabel *lab = self.lab02MutArr[0];
    
    NSLog(@"%@",_surplusPurchasableNumStr);
    
    lab.text = _surplusPurchasableNumStr;
}

-(void)setOncePurchasableNumStr:(NSString *)oncePurchasableNumStr{//第二个
    
    _oncePurchasableNumStr = oncePurchasableNumStr;
    
    NSLog(@"%@",oncePurchasableNumStr);
    
//    NSLog(@"type = %lu",(unsigned long)self.type);

    switch (self.type) {
        case TransactionAmountTypeLimit:{
            
            UILabel *lab = self.lab02MutArr[1];
            
            lab.text = _oncePurchasableNumStr;
        }
            break;
            
        case TransactionAmountTypeFixed:{
            
        }
            break;
            
        default:
            break;
    }
}

-(void)setUnitPriceStr:(NSString *)unitPriceStr{//第三个
    
    _unitPriceStr = unitPriceStr;
    
    NSLog(@"%@",_unitPriceStr);
    
    switch (self.type) {
        case TransactionAmountTypeLimit:{
            
            UILabel *lab = self.lab02MutArr[2];

            lab.text = _unitPriceStr;
        }
            break;
            
        case TransactionAmountTypeFixed:{
            
            UILabel *lab = self.lab02MutArr[1];
            
            lab.text = _unitPriceStr;

        }
            break;
            
        default:
            break;
    }
}










@end
