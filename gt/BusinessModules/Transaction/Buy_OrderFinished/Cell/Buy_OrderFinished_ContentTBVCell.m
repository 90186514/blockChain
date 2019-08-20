//
//  Buy_OrderFinished_ContentTBVCell.m
//  
//
//  Created by Administrator on 02/04/2019.
//

#import "Buy_OrderFinished_ContentTBVCell.h"

#import "OrderDetailModel.h"

@interface Buy_OrderFinished_ContentTBVCell()

@property(nonatomic,strong)NSMutableArray *menuTitleMutArr;

@property(nonatomic,strong)NSMutableArray *menuTitleValueMutArr;

@end

@implementation Buy_OrderFinished_ContentTBVCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style
               requestParams:(id)requestParams
             reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        
        [self data:requestParams];
        
        [self initView];
    }
    
    return self;
}

-(void)data:(id)requestParams{
    
    [self.menuTitleMutArr addObject:@"订单号:"];
    
    [self.menuTitleMutArr addObject:@"订单金额:"];
    
    [self.menuTitleMutArr addObject:@"数量:"];
    
    [self.menuTitleMutArr addObject:@"订单时间:"];
    
    [self.menuTitleMutArr addObject:@"支付方式:"];
    
    [self.menuTitleMutArr addObject:@"付款参考号:"];
    
    OrderDetailModel *orderDetailModel = requestParams;
    
    [self.menuTitleValueMutArr addObject:orderDetailModel.orderNo];
    
    [self.menuTitleValueMutArr addObject:orderDetailModel.orderAmount];
    
    [self.menuTitleValueMutArr addObject:orderDetailModel.orderNumber];
    
    [self.menuTitleValueMutArr addObject:orderDetailModel.createdTime];
    
    if ([orderDetailModel.paymentWay.paymentWay isEqualToString:@"1"]) {
        
        [self.menuTitleValueMutArr addObject:@"微信"];
    }else if ([orderDetailModel.paymentWay.paymentWay isEqualToString:@"2"]){
        
        [self.menuTitleValueMutArr addObject:@"支付宝"];
    }else if ([orderDetailModel.paymentWay.paymentWay isEqualToString:@"3"]){
        
        [self.menuTitleValueMutArr addObject:@"银行卡"];
    }
    
    [self.menuTitleValueMutArr addObject:orderDetailModel.paymentNumber];
}

-(void)initView{
    
    UIButton *titleBtn = UIButton.new;
    
    [titleBtn setTitle:@"已完成"
              forState:UIControlStateNormal];
    
    titleBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular"
                                               size:24];
    
    [titleBtn setTitleColor:RGBCOLOR(51, 51, 51)
                   forState:UIControlStateNormal];
    
    [titleBtn setImage:kIMG(@"icon_check")
              forState:UIControlStateNormal];
    
    [self.contentView addSubview:titleBtn];
    
    [titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(20);
        
        make.left.equalTo(self.contentView);
        
        make.right.equalTo(self.contentView);
    }];
    
    UILabel *line = UILabel.new;
    
    line.backgroundColor = RGBCOLOR(240, 241, 243);
    
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(15);
        
        make.right.equalTo(self.contentView).offset(-15);
        
        make.top.equalTo(titleBtn.mas_bottom).offset(20);
        
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
        
//        menuTitleValueLab.text = @"123";
        
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
    
    pasteboard.string = self.menuTitleMutArr[0];
    
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

@end
