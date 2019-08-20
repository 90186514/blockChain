//
//  Buy_Payment_BankCardTBVCell.m
//  gt
//
//  Created by Administrator on 05/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "Buy_Payment_BankCardTBVCell.h"

@interface Buy_Payment_BankCardTBVCell ()

@property(nonatomic,strong)NSMutableArray *menuTitleMutArr;

@property(nonatomic,strong)NSMutableArray *menuTitleValueMutArr;



@end

@implementation Buy_Payment_BankCardTBVCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                   orderType:(NSString *)orderType
                     dataDic:(NSDictionary *)dataDic{
    
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        
        [self.menuTitleValueMutArr addObject:dataDic[@"paymentNumber"]];//付款参考号
        
        [self.menuTitleValueMutArr addObject:dataDic[@"name"]];//收款人
        
        [self.menuTitleValueMutArr addObject:dataDic[@"accountOpenBank"]];//开户银行
        
        [self.menuTitleValueMutArr addObject:dataDic[@"accountOpenBranch"]];//支行信息
        
        [self.menuTitleValueMutArr addObject:dataDic[@"accountBankCard"]];//卡号

        [self initView];
    }
    
    return self;
}

-(void)initView{
    
    UILabel *titleLab = UILabel.new;
    
    titleLab.text = @"使用银行卡账号汇款";
    
    titleLab.font = [UIFont fontWithName:@"PingFangSC-Medium"
                                    size:14];
    
    titleLab.textColor = RGBCOLOR(51, 51, 51);
    
    [self.contentView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(20);
        
        make.left.equalTo(self.contentView).offset(15);
        
        make.right.equalTo(self.contentView).offset(29);
    }];
    
    UILabel *line = UILabel.new;
    
    line.backgroundColor = RGBCOLOR(240, 241, 243);
    
    [self.contentView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(15);
        
        make.right.equalTo(self.contentView).offset(-15);
        
        make.top.equalTo(titleLab.mas_bottom).offset(20);
        
        make.height.mas_equalTo(@1);
    }];
    ///
    for (int s = 0; s < self.menuTitleMutArr.count; s++) {
        //子标题
        UILabel *menuTitleLab = UILabel.new;
        
        menuTitleLab.text = self.menuTitleMutArr[s];
        
        menuTitleLab.textColor = RGBCOLOR(154, 154, 154);
        
        menuTitleLab.font = kFontSize(13);
        
        [self.contentView addSubview:menuTitleLab];
        
        [menuTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(line);
            
//            make.size.mas_equalTo(CGSizeMake(39, 13));
            make.height.mas_equalTo(13);
            
            make.top.equalTo(line.mas_bottom).offset(12 + (13 + 15) * s);
        }];
        //复制按钮
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
        //值
        UILabel *menuTitleValueLab = UILabel.new;
        
        menuTitleValueLab.text = self.menuTitleValueMutArr[s];
        
//        menuTitleValueLab.backgroundColor = kRedColor;
        
        menuTitleValueLab.textColor = RGBCOLOR(51, 51, 51);
        
        menuTitleValueLab.font = [UIFont fontWithName:@"PingFangSC-Medium"
                                                 size:14];
        
        [self.contentView addSubview:menuTitleValueLab];
        
        [menuTitleValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(copyBtn.mas_left).offset(-4);
            
            make.top.bottom.equalTo(menuTitleLab);
        }];
    }
}

#pragma mark —— 复制到剪贴板
-(void)copyBtnClick{
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string = self.menuTitleValueMutArr[0];
    
    if (pasteboard.string.length > 0) {
        
        [SVProgressHUD showSuccessWithStatus:@"复制成功"];
    }
}

#pragma mark - lazyload
-(NSMutableArray *)menuTitleMutArr{
    
    if (!_menuTitleMutArr) {
        
        _menuTitleMutArr = NSMutableArray.array;
        
        [_menuTitleMutArr addObject:@"付款参考号:"];
        
        [_menuTitleMutArr addObject:@"收款人:"];
        
        [_menuTitleMutArr addObject:@"开户银行:"];
        
        [_menuTitleMutArr addObject:@"支行信息:"];
        
        [_menuTitleMutArr addObject:@"银行卡号:"];
    }
    
    return _menuTitleMutArr;
}

-(NSMutableArray *)menuTitleValueMutArr{
    
    if (!_menuTitleValueMutArr) {
        
        _menuTitleValueMutArr = NSMutableArray.array;
    }
    
    return _menuTitleValueMutArr;
}

#pragma mark —— set
-(void)setOrderDetailModel:(OrderDetailModel *)orderDetailModel{
    
    _orderDetailModel = orderDetailModel;
}

@end
