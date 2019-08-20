//
//  Buy_Payment_ContentTBVCell.m
//  gt
//
//  Created by Administrator on 02/04/2019.
//  Copyright © 2019 GT. All rights reserved.
//

#import "Buy_Payment_ContentTBVCell.h"

/**
 买币 - 向卖家转账
 */
@interface Buy_Payment_ContentTBVCell ()

@property(nonatomic,strong)NSMutableArray *menuTitleMutArr;

@property(nonatomic,strong)NSMutableArray *menuTitleValueMutArr;

@property(nonatomic,strong)NSDictionary *dataDic;

@end

@implementation Buy_Payment_ContentTBVCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                     dataDic:(NSDictionary *)dataDic{
    
    if (self = [super initWithStyle:style
                    reuseIdentifier:reuseIdentifier]) {
        
        self.dataDic = dataDic;
        
        [self.menuTitleValueMutArr addObject:self.dataDic[@"orderNo"]];//订单号
        
        [self.menuTitleValueMutArr addObject:[NSString stringWithFormat:@"¥%@",self.dataDic[@"orderPrice"]]];//单价
        
        [self.menuTitleValueMutArr addObject:[NSString stringWithFormat:@"%@CNY(人民币)",self.dataDic[@"orderAmount"]]];//订单金额
        
        [self initView];
    }
    
    return self;
}

-(void)initView{
    
    UILabel *titleLab = UILabel.new;

    titleLab.text = [NSString stringWithFormat:@"您正在向%@购买%@个BUB",self.dataDic[@"name"],self.dataDic[@"orderNumber"]];
    
    [self.contentView addSubview:titleLab];
    
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(20);
        
        make.left.equalTo(self.contentView).offset(29);
        
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
        
        menuTitleValueLab.text = self.menuTitleValueMutArr[s];
        
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
                            action:@selector(copyBtnClick:)
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
-(void)copyBtnClick:(UIButton *)sender{
    
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
        
        [_menuTitleMutArr addObject:@"订单号:"];
        
        [_menuTitleMutArr addObject:@"单价:"];
        
        [_menuTitleMutArr addObject:@"总价:"];
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
