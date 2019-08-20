//
//  Buy_Waitting_ContentTBVCell.m
//  gt
//
//  Created by Administrator on 03/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "Buy_Waitting_ContentTBVCell.h"

#import "OrderDetailModel.h"

@interface Buy_Waitting_ContentTBVCell (){
    
    UILabel *tipsLab;
}

@property(nonatomic,strong)NSMutableArray *menuTitleMutArr;

@property(nonatomic,strong)NSMutableArray *menuTitleValueMutArr;

@property(nonatomic,strong)NSMutableArray *menuTitleValueDataMutArr;

@property(nonatomic,strong)OrderDetailModel *orderDetailModel;

@property(nonatomic,assign)OrderType orderType;

@end

@implementation Buy_Waitting_ContentTBVCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style
               requestParams:(id)requestParams
             reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        
        [self asssembleData:requestParams];
        
        [self initView:self.orderType];
    }
    
    return self;
}

-(void)asssembleData:(id)requestParams{
    
    self.orderDetailModel = [OrderDetailModel mj_objectWithKeyValues:requestParams];
    
    self.orderType = [self.orderDetailModel getTransactionOrderType];
    
    switch (self.orderType) {
        case BuyerOrderTypeNotYetPay://买方_订单还未支付
        case BuyerOrderTypeHadPaidNotDistribute://买方_订单已经支付不放行
        case BuyerOrderTypeClosed:{//超时页面
            
            [self.menuTitleMutArr addObject:@"订单号:"];
            
            [self.menuTitleMutArr addObject:@"订单金额:"];
            
            [self.menuTitleMutArr addObject:@"数量:"];
            
            [self.menuTitleMutArr addObject:@"订单时间:"];
            
            [self.menuTitleValueDataMutArr addObject:[NSString isEmpty:self.orderDetailModel.orderNo]?@"?":self.orderDetailModel.orderNo];
            
            [self.menuTitleValueDataMutArr addObject:[NSString isEmpty:self.orderDetailModel.orderAmount]?@"?":self.orderDetailModel.orderAmount];
            
            [self.menuTitleValueDataMutArr addObject:[NSString isEmpty:self.orderDetailModel.orderNumber]?@"?":self.orderDetailModel.orderNumber];
            
            [self.menuTitleValueDataMutArr addObject:[NSString isEmpty:self.orderDetailModel.createdTime]?@"?":self.orderDetailModel.createdTime];
        }
            break;
        case BuyerOrderTypeHadPaidWaitDistribute:{//买方_订单已经支付待放行
            
            NSLog(@"%@",self.orderDetailModel.paymentWay.paymentWay);
            
            [self.menuTitleMutArr addObject:@"订单号:"];
            
            [self.menuTitleMutArr addObject:@"订单金额:"];
            
            [self.menuTitleMutArr addObject:@"数量:"];
            
            [self.menuTitleMutArr addObject:@"订单时间:"];
            
            [self.menuTitleMutArr addObject:@"支付方式:"];
            
            [self.menuTitleValueDataMutArr addObject:[NSString isEmpty:self.orderDetailModel.orderNo]?@"?":self.orderDetailModel.orderNo];//订单号
            
            [self.menuTitleValueDataMutArr addObject:[NSString isEmpty:self.orderDetailModel.orderAmount]?@"?":self.orderDetailModel.orderAmount];//订单金额
            
            [self.menuTitleValueDataMutArr addObject:[NSString isEmpty:self.orderDetailModel.orderAmount]?@"?":self.orderDetailModel.orderAmount];//数量
            
//            [self.menuTitleValueDataMutArr addObject:[NSString isEmpty:self.orderDetailModel.orderNumber]?@"?":self.orderDetailModel.orderNumber];
            
            [self.menuTitleValueDataMutArr addObject:[NSString isEmpty:self.orderDetailModel.createdTime]?@"?":self.orderDetailModel.createdTime];//订单时间
            
            
            if ([NSString isEmpty:self.orderDetailModel.paymentWay.paymentWay]) {//支付方式
                
                [self.menuTitleValueDataMutArr addObject:@"?"];
            }else{
                
                // 收款方式:1、微信;2、支付宝;3、银行卡
                if ([self.orderDetailModel.paymentWay.paymentWay isEqualToString:@"1"]) {
                    
                    [self.menuTitleValueDataMutArr addObject:@"微信"];
                }else if ([self.orderDetailModel.paymentWay.paymentWay isEqualToString:@"2"]){
                    
                    [self.menuTitleValueDataMutArr addObject:@"支付宝"];
                }else if ([self.orderDetailModel.paymentWay.paymentWay isEqualToString:@"3"]){
                    
                    [self.menuTitleValueDataMutArr addObject:@"银行卡"];
                }
            }
        }
            break;
        default:
            break;
    }
}

-(void)initView:(OrderType)orderType{
    //共有的标题:
    
    UIButton *titleBtn = UIButton.new;
 
    titleBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular"
                                               size:24];
    
    [titleBtn setTitle:[self.orderDetailModel getTransactionOrderTypeTitle]
              forState:UIControlStateNormal];
    
    [titleBtn setImage:kIMG([self.orderDetailModel getTransactionOrderTypeImageName])
              forState:UIControlStateNormal];
    
    [titleBtn setTitleColor:RGBCOLOR(51, 51, 51)
                   forState:UIControlStateNormal];

    [self.contentView addSubview:titleBtn];
    
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(20);
        
        make.left.equalTo(self.contentView);
        
        make.right.equalTo(self.contentView);
    }];

    //在某种状态下才会显示的tips
    switch (orderType) {
        case BuyerOrderTypeAppealing:
        case SellerOrderTypeNotYetPay:
        case SellerOrderTypeWaitDistribute:
        case SellerOrderTypeAppealing:{
            
            tipsLab = UILabel.new;
            
//            tipsLab.text = @"temp";
            
            [self.contentView addSubview:tipsLab];
            
            [tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.top.centerX.equalTo(titleBtn);
            }];
        }
            break;
        default:
            break;
    }
    
    UILabel *line = UILabel.new;
    
    line.backgroundColor = RGBCOLOR(240, 241, 243);
    
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(15);
        
        make.right.equalTo(self.contentView).offset(-15);
        self->tipsLab?make.top.equalTo(self->tipsLab.mas_bottom).offset(20):make.top.equalTo(titleBtn.mas_bottom).offset(20);
        
        make.height.mas_equalTo(@1);
    }];
    
    for (int s = 0; s < self.menuTitleMutArr.count; s++) {
        
        UILabel *menuTitleLab = UILabel.new;
        
        menuTitleLab.text = self.menuTitleMutArr[s];
        
        menuTitleLab.textColor = RGBCOLOR(154, 154, 154);
        
        menuTitleLab.font = kFontSize(13);
        
        [self.contentView addSubview:menuTitleLab];
        
        [menuTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.right.equalTo(line);
            
            make.size.mas_equalTo(CGSizeMake(39, 13));
            
            make.top.equalTo(line.mas_bottom).offset(12 + (13 + 15) * s);
        }];
        
        UILabel *menuTitleValueLab = UILabel.new;
        
        menuTitleValueLab.text = self.menuTitleValueDataMutArr[s];
        
        [self.menuTitleValueMutArr addObject:menuTitleValueLab];
        
        menuTitleValueLab.textColor = RGBCOLOR(51, 51, 51);
        
        menuTitleValueLab.font = [UIFont fontWithName:@"PingFangSC-Regular"
                                                 size:13];
        
        [self.contentView addSubview:menuTitleValueLab];
        
        switch (s) {
            case 0:{
                
                UIButton *copyBtn = UIButton.new;
                
                [copyBtn setBackgroundImage:kIMG(@"copy_blue_rightup")
                                   forState:UIControlStateNormal];
                
                [copyBtn addTarget:self
                            action:@selector(copyBtnClick)
                  forControlEvents:UIControlEventTouchUpInside];
                
                [self.contentView addSubview:copyBtn];
                
                [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.top.bottom.equalTo(menuTitleLab);
                    
                    make.right.equalTo(self.contentView).offset(-15);
                    
                    make.size.mas_equalTo(CGSizeMake(13, 15));
                }];
                
                [menuTitleValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.right.equalTo(copyBtn.mas_left).offset(-4);
                    
                    make.top.bottom.equalTo(menuTitleLab);
                }];
            }
                break;
                
            default:{
                
                [menuTitleValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    
                    make.right.equalTo(self.contentView).offset(-15);
                    
                    make.top.bottom.equalTo(menuTitleLab);
                }];
            }
                break;
        }
    }
}

#pragma mark —— 复制到剪贴板
-(void)copyBtnClick{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = self.menuTitleValueDataMutArr[0];
    
    if (pasteboard.string.length > 0) {
        
        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
    }
}

#pragma mark - lazyload
-(NSMutableArray *)menuTitleMutArr{
    
    if (!_menuTitleMutArr) {
        
        _menuTitleMutArr = NSMutableArray.array;
    }
    
    return _menuTitleMutArr;
}

-(NSMutableArray *)menuTitleValueMutArr{
    
    if (!_menuTitleValueMutArr) {
        
        _menuTitleValueMutArr = NSMutableArray.array;
    }
    
    return _menuTitleValueMutArr;
}

-(NSMutableArray *)menuTitleValueDataMutArr{
    
    if (!_menuTitleValueDataMutArr) {
        
        _menuTitleValueDataMutArr = NSMutableArray.array;
    }
    
    return _menuTitleValueDataMutArr;
}

#pragma mark —— set方法赋值
//-(void)setOrderNo:(NSString *)orderNo{//订单号
//    
//    _orderNo = orderNo;
//    
//    UILabel *lab = self.menuTitleValueMutArr[0];
//    
//    lab.text = [NSString isEmpty:_orderNo]?@"?":_orderNo;
//}
//
//-(void)setOrderAmount:(NSString *)orderAmount{//订单金额
//    
//    _orderAmount = orderAmount;
//    
//    UILabel *lab = self.menuTitleValueMutArr[1];
//    
//    lab.text = [NSString isEmpty:_orderAmount]?@"?":_orderAmount;
//}
//
//-(void)setOrderNumber:(NSString *)orderNumber{//数量
//    
//    _orderNumber = orderNumber;
//    
//    UILabel *lab = self.menuTitleValueMutArr[2];
//    
//    lab.text = [NSString isEmpty:_orderNumber]?@"?":_orderNumber;
//}
//
//-(void)setCreatedTime:(NSString *)createdTime{//订单创建时间
//    
//    _createdTime = createdTime;
//    
//    UILabel *lab = self.menuTitleValueMutArr[3];
//    
//    lab.text = [NSString isEmpty:_createdTime]?@"?":_createdTime;
//}

@end
