//
//  AccountCell.m
//  gt
//
//  Created by 钢镚儿 on 2018/12/19.
//  Copyright © 2018年 GT. All rights reserved.
//

#import "MyAccountCell.h"
#import "PaymentAccountModel.h"
@interface MyAccountCell ()

@property (nonatomic, strong) UIImageView * cellImgView;
@property (nonatomic, strong) UILabel * cellTittleLb;
@property (nonatomic, strong) UILabel * cellNumLb;
@property (nonatomic, strong) UISwitch * switchFunc;
@property (nonatomic, strong) UIButton * deleteBtn;
@property (nonatomic, copy) DataBlock block;
@property (nonatomic, copy) DataBlock deleteBlock;
@end

@implementation MyAccountCell

+(CGFloat)cellHeightWithModel{
    return  115;
}
+(instancetype)cellWith:(UITableView*)tabelView{
    MyAccountCell *cell = (MyAccountCell *)[tabelView dequeueReusableCellWithIdentifier:@"MyAccountCell"];
    if (!cell) {
        cell = [[MyAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyAccountCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)richElementsInCellWithModel:(PaymentAccountData*)model{
    NSDictionary* dic = [model getPaymentAccountTypeName];
    self.cellTittleLb.text = dic.allKeys[0];
    self.cellImgView.image = [UIImage imageNamed:dic.allValues[0]] ;
    
    if ([model getPaymentAccountType]==PaywayTypeCard) {
        NSString* bankCardNum = model.accountBankCard;
        self.cellNumLb.text = [NSString stringWithFormat:@"****  ****  ****  %@",bankCardNum.length>3?[bankCardNum substringFromIndex:bankCardNum.length-3]:bankCardNum];
    }else{
        self.cellNumLb.text = model.remark;
    }
    [self.switchFunc setOn:[model.status intValue]==1?YES:NO];
    [self.switchFunc addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)switchAction:(UISwitch*)switchFun{
    if (self.block) {
        self.block(switchFun);
    }
}

- (void)actionBlock:(DataBlock)block
{
    self.block = block;
}
- (void)deleteActionBlock:(DataBlock)block{
    self.deleteBlock = block;
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor colorWithRed:248.0/256 green:248.0/256 blue:250.0/256 alpha:1];
        
        UIView * baseView1 = [[UIView alloc] initWithFrame:CGRectMake(15, 10, [[UIScreen mainScreen] bounds].size.width - 30, 105)];
        baseView1.layer.shadowColor = [UIColor grayColor].CGColor;
        baseView1.layer.shadowOpacity = 0.1f;
        baseView1.layer.shadowRadius = 4.f;
        baseView1.layer.shadowOffset = CGSizeMake(1,3);
        [self addSubview:baseView1];
        
        UIView * baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width - 30, 105)];
        baseView.backgroundColor = [UIColor whiteColor];
        baseView.layer.cornerRadius = 10;
        baseView.layer.masksToBounds = YES;
        [baseView1 addSubview:baseView];
        baseView.userInteractionEnabled = YES;
        _cellImgView = [[UIImageView alloc] initWithFrame:CGRectMake(19, 18, 29, 29)];
        
        [baseView addSubview:_cellImgView];
        
        _cellTittleLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_cellImgView.frame) + 10, CGRectGetMinY(_cellImgView.frame), 200, 28 )];
        
        _cellTittleLb.font = [UIFont systemFontOfSize:20];
        [baseView addSubview:_cellTittleLb];
        
        _cellNumLb = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(_cellTittleLb.frame), CGRectGetMaxY(_cellTittleLb.frame) + 13,baseView.size.width - CGRectGetMinX(_cellTittleLb.frame)-19-35, 28)];
        
        _cellNumLb.font = [UIFont systemFontOfSize:20];
        _cellNumLb.textColor = [UIColor colorWithRed:57.0/256 green:67.0/256 blue:104.0/256 alpha:0.7];
        [baseView addSubview:_cellNumLb];
        
        self.switchFunc = [[UISwitch alloc] initWithFrame:CGRectMake(CGRectGetWidth(baseView.frame) - 60, 10, 35, 20)];
        self.switchFunc.onTintColor = [UIColor colorWithRed:76.0/256 green:127.0/256 blue:255.0/256 alpha:1];
        self.switchFunc.transform = CGAffineTransformMakeScale([[NSNumber numberWithDouble:35] floatValue]/[[NSNumber numberWithDouble:51] floatValue],[[NSNumber numberWithDouble:20] floatValue]/[[NSNumber numberWithDouble:31] floatValue]);
        [baseView addSubview:self.switchFunc];//默认大小 51.0f 31.0f
        
        
        self.deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteBtn.adjustsImageWhenHighlighted = NO;
        self.deleteBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        self.deleteBtn.contentVerticalAlignment =UIControlContentVerticalAlignmentCenter;
        [self.deleteBtn addTarget:self action:@selector(deleteEvent:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:self.deleteBtn];
        [self.deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
        [self.deleteBtn setTitleColor:HEXCOLOR(0xd4237a) forState:UIControlStateNormal];
        self.deleteBtn.titleLabel.font= kFontSize(13);
        self.deleteBtn.frame = CGRectMake(self.switchFunc.x, self.cellNumLb.y, 35, 28);
        
    }
    return self;
}

- (void)deleteEvent:(UIButton*)sender{
    if (self.deleteBlock) {
        self.deleteBlock(sender);
    }
}
@end
