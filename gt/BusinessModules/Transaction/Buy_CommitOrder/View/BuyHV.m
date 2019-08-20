//  gtp
//
//  Created by Aalto on 2018/12/23.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "BuyHV.h"
#import "TransactionModel.h"
@interface BuyHV ()<UITextFieldDelegate>
{
    UIView * backView;
    UIButton * imgBtn;
    
}
@property (nonatomic, strong)UIView * moneyView0;
@property (nonatomic, strong)UIView * moneyView;
@property (nonatomic, strong)UILabel *safeLab;
@property (nonatomic, strong)UITextField * numTf;
@property (nonatomic, strong) UITextField * amountTf;

@property (nonatomic, assign) TransactionAmountType type;

@property (nonatomic, copy) DataBlock block;
@property (nonatomic, strong)TransactionData*requestParams;
@end

@implementation BuyHV

- (instancetype)initWithFrame:(CGRect)frame WithModel:(TransactionData*)requestParams{
    self = [super initWithFrame:frame];
    if (self) {
        _requestParams = requestParams;
        [self publicTopPartView];
        _type = [_requestParams.amountType intValue];
        if (_type == TransactionAmountTypeLimit){
            [self richElesInLimitView];
        }else{
            [self richElesInFixedView];
        }
        
    }
    return self;
}

- (void)publicTopPartView{
    UIView * topline = [[UIView alloc]init];
    topline.backgroundColor = HEXCOLOR(0xf6f5fa);
    [self addSubview:topline];
    [topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(5);
        make.left.right.top.mas_equalTo(0);
        make.centerX.mas_equalTo(self);
    }];
    
    
    UIButton* userNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:userNameBtn];
    [userNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(55);
        make.top.mas_equalTo(topline.mas_bottom);
        make.centerX.mas_equalTo(self);
    }];
    userNameBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    userNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [userNameBtn setTitleColor:HEXCOLOR(0x000000) forState:UIControlStateNormal];
    userNameBtn.titleLabel.font = kFontSize(20);
    userNameBtn.titleLabel.numberOfLines = 1;
    
    NSString* userName = 
    _requestParams.nickName!=nil?_requestParams.nickName:_requestParams.username!=nil?_requestParams.username:@"";
    [userNameBtn setTitle:userName forState:UIControlStateNormal];
    //[NSString getAnonymousString:userName]
    [userNameBtn setImage:[UIImage imageNamed:[_requestParams getPriorityImageName]] forState:UIControlStateNormal];
    [userNameBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:7];
    
    UILabel * priceLab = [UILabel new];//单价：
    priceLab.attributedText = [NSString attributedStringWithString:@"" stringColor:HEXCOLOR(0x666666) stringFont:[UIFont boldSystemFontOfSize:16] subString:@"卖家信息：" subStringColor:HEXCOLOR(0x000000) subStringFont:[UIFont boldSystemFontOfSize:16]];
    priceLab.textAlignment = NSTextAlignmentLeft;
    [self addSubview:priceLab];
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(16);
        make.centerY.mas_equalTo(userNameBtn);
        make.height.mas_equalTo(55);
    }];
    
    UIView * line = [[UIView alloc]initWithFrame:CGRectMake(0, 51, MAINSCREEN_WIDTH, 1)];
    line.backgroundColor = HEXCOLOR(0xe8e9ed);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1);
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(userNameBtn.mas_bottom);
    }];
    
    self.safeLab = [[UILabel alloc]init];
    [self addSubview:self.safeLab];
    self.safeLab.attributedText = [NSString attributedStringWithString:@"" stringColor:kClearColor stringFont:kFontSize(14) subString:[NSString stringWithFormat:@"该订单需要你在 %@ 分钟内完成付款",_requestParams.prompt] subStringColor:HEXCOLOR(0x4c7fff) subStringFont:kFontSize(14) numInSubColor:HEXCOLOR(0xff9238) numInSubFont:kFontSize(16)];
    self.safeLab.textAlignment = NSTextAlignmentCenter;
//    self.safeLab.text = [NSString stringWithFormat:@"该订单需要你在 %@ 分钟内完成付款",_requestParams.prompt];
//    self.safeLab.font = [UIFont systemFontOfSize:14.0];
//    self.safeLab.textColor = HEXCOLOR(0x4c7fff);
    [self.safeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(20);
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(line.mas_bottom).offset(10);
    }];
}
- (void)richElesInFixedView{
    self.moneyView = [[UIView alloc]init];
    self.moneyView.backgroundColor = HEXCOLOR(0xf6f5fa);
    self.moneyView.layer.masksToBounds = YES;
    self.moneyView.layer.cornerRadius = 8;
    [self addSubview:self.moneyView];
    [self.moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.top.mas_equalTo(self.safeLab.mas_bottom).offset(29);
        make.height.mas_equalTo(177);
    }];
    
    
    UIView * line2 = [[UIView alloc]init];
    [self.moneyView addSubview:line2];
    line2.backgroundColor =HEXCOLOR(0xe6e6e6);
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.moneyView);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(50.9);
    }];
    
    
    
    UILabel * priceLab = [[UILabel alloc]init];
    priceLab.text =
//    [NSString stringWithFormat:@"%@ BUB",_requestParams.price];
    [NSString stringWithFormat:@"%.2f BUB",[_requestParams.price floatValue] * [_requestParams.fixedAmount floatValue]];
    [self.moneyView addSubview:priceLab];
    priceLab.font = [UIFont systemFontOfSize:26.0];
    priceLab.textColor = HEXCOLOR(0x394368);
    priceLab.textAlignment = NSTextAlignmentCenter;
    [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(line2.mas_top);
    }];
    
    UILabel * priceLab2 = [UILabel new];//单价：
    priceLab2.attributedText = [NSString attributedStringWithString:@"" stringColor:HEXCOLOR(0x666666) stringFont:kFontSize(15) subString:@"订单总计：" subStringColor:HEXCOLOR(0x000000) subStringFont:[UIFont boldSystemFontOfSize:16]];
    priceLab2.textAlignment = NSTextAlignmentLeft;
    [self.moneyView addSubview:priceLab2];
    [priceLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.centerY.mas_equalTo(priceLab);
        make.height.mas_equalTo(55);
    }];
    
    
    UILabel* amountLab = [[UILabel alloc]init];
    amountLab.text = @"总价：";
    [self.moneyView addSubview:amountLab];
    amountLab.font = [UIFont systemFontOfSize:14.0];
    amountLab.textColor = HEXCOLOR(0x666666);
    [amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(line2.mas_bottom).offset(20);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(170);
    }];
    
    UILabel* amountRightLab = [[UILabel alloc]init];
    amountRightLab.text =
//    [NSString stringWithFormat:@"%@ CNY",_requestParams.fixedAmount];
    [NSString stringWithFormat:@"%.2f CNY",[_requestParams.price floatValue] * [_requestParams.fixedAmount floatValue]];
    [self.moneyView addSubview:amountRightLab];
    amountRightLab.font = [UIFont systemFontOfSize:14.0];
    amountRightLab.textColor = HEXCOLOR(0x333333);
    [amountRightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(amountLab);
        make.height.mas_equalTo(amountLab);
    }];
    
    UILabel* rateLab = [[UILabel alloc]init];
    rateLab.text = @"单价：";
    [self.moneyView addSubview:rateLab];
    rateLab.font = [UIFont systemFontOfSize:14.0];
    rateLab.textColor = HEXCOLOR(0x666666);
    [rateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(amountLab.mas_bottom).offset(13);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(amountLab);
    }];
    
    UILabel* rateRightLab = [[UILabel alloc]init];
    rateRightLab.text = [_requestParams getRateName];
    [self.moneyView addSubview:rateRightLab];
    rateRightLab.font = [UIFont systemFontOfSize:14.0];
    rateRightLab.textColor = HEXCOLOR(0x333333);
    [rateRightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(rateLab);
        make.height.mas_equalTo(rateLab);
    }];
    
    UILabel* payLab = [[UILabel alloc]init];
    payLab.text = @"卖家支持收款方式：";
    [self.moneyView addSubview:payLab];
    payLab.font = [UIFont systemFontOfSize:14.0];
    payLab.textColor = HEXCOLOR(0x666666);
    [payLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(rateLab.mas_bottom).offset(13);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(rateLab);
    }];
    
    UILabel* payRightLab = [[UILabel alloc]init];
    payRightLab.text = [_requestParams getPaymentwayName];
    [self.moneyView addSubview:payRightLab];
    payRightLab.font = [UIFont systemFontOfSize:14.0];
    payRightLab.textColor = HEXCOLOR(0x4c7fff);
    [payRightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(payLab);
        make.height.mas_equalTo(payLab);
    }];
}


- (void)richElesInLimitView{
    self.moneyView0 = [[UIView alloc]init];
    self.moneyView0.backgroundColor = HEXCOLOR(0xf6f5fa);
    self.moneyView0.layer.masksToBounds = YES;
    self.moneyView0.layer.cornerRadius = 8;
    [self addSubview:self.moneyView0];
    [self.moneyView0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.top.mas_equalTo(self.safeLab.mas_bottom).offset(10);
        make.height.mas_equalTo(147.5);
    }];
    
    [self layoutIfNeeded];

//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.moneyView0.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight cornerRadii:CGSizeMake(8, 8)];
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.frame = self.moneyView0.bounds;
//    maskLayer.path = maskPath.CGPath;
//    self.moneyView0.layer.mask = maskLayer;
    
    
    
    UILabel* amountLab = [[UILabel alloc]init];
    amountLab.text = @"限额：";
    [self.moneyView0 addSubview:amountLab];
    amountLab.font = [UIFont systemFontOfSize:14.0];
    amountLab.textColor = HEXCOLOR(0x666666);
    [amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(26);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(170);
    }];
    
    UILabel* amountRightLab = [[UILabel alloc]init];
    amountRightLab.text = [NSString stringWithFormat:@"%@ ~ %@",_requestParams.limitMinAmount,_requestParams.limitMaxAmount];
    [self.moneyView0 addSubview:amountRightLab];
    amountRightLab.font = [UIFont systemFontOfSize:14.0];
    amountRightLab.textColor = HEXCOLOR(0x333333);
    [amountRightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(amountLab);
        make.height.mas_equalTo(amountLab);
    }];
    
    
    UILabel* rateLab = [[UILabel alloc]init];
    rateLab.text = @"单价：";
    [self.moneyView0 addSubview:rateLab];
    rateLab.font = [UIFont systemFontOfSize:14.0];
    rateLab.textColor = HEXCOLOR(0x666666);
    [rateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(amountLab.mas_bottom).offset(13);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(amountLab);
    }];
    
    UILabel* rateRightLab = [[UILabel alloc]init];
    rateRightLab.text = [_requestParams getRateName];
    [self.moneyView0 addSubview:rateRightLab];
    rateRightLab.font = [UIFont systemFontOfSize:14.0];
    rateRightLab.textColor = HEXCOLOR(0x333333);
    [rateRightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(rateLab);
        make.height.mas_equalTo(rateLab);
    }];
    
    UILabel* payLab = [[UILabel alloc]init];
    payLab.text = @"卖家支持收款方式：";
    [self.moneyView0 addSubview:payLab];
    payLab.font = [UIFont systemFontOfSize:14.0];
    payLab.textColor = HEXCOLOR(0x666666);
    [payLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(rateLab.mas_bottom).offset(13);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(rateLab);
    }];
    
    UILabel* payRightLab = [[UILabel alloc]init];
    payRightLab.text = [_requestParams getPaymentwayName];
    [self.moneyView0 addSubview:payRightLab];
    payRightLab.font = [UIFont systemFontOfSize:14.0];
    payRightLab.textColor = HEXCOLOR(0x4c7fff);
    [payRightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.centerY.mas_equalTo(payLab);
        make.height.mas_equalTo(payLab);
    }];
    
//    UIView * line1 = [[UIView alloc]init];
//    [self.moneyView0 addSubview:line1];
//    line1.backgroundColor =HEXCOLOR(0xe6e6e6);
//    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.mas_equalTo(self.moneyView0);
//        make.height.mas_equalTo(1);
//        make.bottom.mas_equalTo(self.moneyView0.mas_bottom).offset(-1);
//    }];
    
    self.moneyView = [[UIView alloc]init];
    self.moneyView.backgroundColor = HEXCOLOR(0xffffff);
    self.moneyView.layer.masksToBounds = YES;
    self.moneyView.layer.cornerRadius = .5;
    self.moneyView.layer.borderColor = HEXCOLOR(0xe6e6e6).CGColor;
    self.moneyView.layer.borderWidth = 1;

    [self addSubview:self.moneyView];
    [self.moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.right.mas_equalTo(-13);
        make.top.mas_equalTo(self.moneyView0.mas_bottom).offset(15);
        make.height.mas_equalTo(123);
    }];
//    [self layoutIfNeeded];
//    UIBezierPath *maskPath2 = [UIBezierPath bezierPathWithRoundedRect:self.moneyView.bounds byRoundingCorners:UIRectCornerBottomLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(8, 8)];
//    CAShapeLayer *maskLayer2 = [[CAShapeLayer alloc] init];
//    maskLayer2.frame = self.moneyView.bounds;
//    maskLayer2.path = maskPath2.CGPath;
//    self.moneyView.layer.mask = maskLayer2;
    
    UIView * line2 = [[UIView alloc]init];
    [self.moneyView addSubview:line2];
    line2.backgroundColor =HEXCOLOR(0xe6e6e6);
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.moneyView);
        make.height.mas_equalTo(1);
        make.top.mas_equalTo(58);
    }];
    
    self.amountTf = [[UITextField alloc]init];
    self.amountTf.placeholder = @"请输入购买金额";
    self.amountTf.delegate = self;
    self.amountTf.keyboardType = UIKeyboardTypeDecimalPad;
    [self.moneyView addSubview:self.amountTf];
    [self.amountTf addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    self.amountTf.font = [UIFont systemFontOfSize:18.0];
    self.amountTf.textColor = HEXCOLOR(0x394368);
    [self.amountTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(17);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(180);
    }];
    
    
//    UILabel* amountrLab = [[UILabel alloc]init];
//    amountrLab.text = @"总价：";
//    [self.moneyView addSubview:amountrLab];
//    amountrLab.font = [UIFont boldSystemFontOfSize:15.0];
//    amountrLab.textColor = HEXCOLOR(0x000000);
//    [amountrLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(13);
//        make.centerY.mas_equalTo(self.amountTf);
//        make.height.mas_equalTo(20);
//        make.width.mas_equalTo(82);
//    }];
    
    self.numTf = [[UITextField alloc]init];
    self.numTf.placeholder = @"请输入您要购买的BUB数量";
    self.numTf.keyboardType = UIKeyboardTypeDecimalPad;
    self.numTf.delegate = self;
    [self.moneyView addSubview:self.numTf];
    [self.numTf addTarget:self action:@selector(textField1TextChange:) forControlEvents:UIControlEventEditingChanged];
    self.numTf.font = [UIFont systemFontOfSize:18.0];
    self.numTf.textColor = HEXCOLOR(0x394368);
    [self.numTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(13);
        make.top.mas_equalTo(75);
        make.height.mas_equalTo(32);
        make.width.mas_equalTo(250);
    }];
//    UILabel* numrLab = [[UILabel alloc]init];
//    numrLab.text = @"BUB 总数：";
//    [self.moneyView addSubview:numrLab];
//    numrLab.font = [UIFont boldSystemFontOfSize:15.0];
//    numrLab.textColor = HEXCOLOR(0x000000);
//    [numrLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(13);
//        make.centerY.mas_equalTo(self.numTf);
//        make.height.mas_equalTo(20);
//        make.width.mas_equalTo(82);
//    }];
    
    UILabel * AB = [[UILabel alloc]init];
    AB.text = @"BUB";
    [self.moneyView addSubview:AB];
    AB.font = [UIFont systemFontOfSize:18.0];
    AB.textColor = HEXCOLOR(0x394368);
    [AB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(75);
        make.height.mas_equalTo(26);
    }];
    
    UIButton * allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [allBtn setTitle:@"全部买入" forState:UIControlStateNormal];
    [allBtn setTitleColor:[YBGeneralColor themeColor] forState:UIControlStateNormal];
    allBtn.titleLabel.font = kFontSize(18);
    [allBtn addTarget:self action:@selector(clickAllBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.moneyView addSubview:allBtn];
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-40);
        make.top.mas_equalTo(20);
        make.height.mas_equalTo(26);
    }];
    
    UILabel * CNYLab = [UILabel new];
    CNYLab.text = @"CNY  |";
    CNYLab.font = [UIFont systemFontOfSize:18.0];
    CNYLab.textColor = HEXCOLOR(0x394368);
    [self.moneyView addSubview:CNYLab];
    [CNYLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(allBtn.mas_left).mas_offset(-13.8);
        make.height.mas_equalTo(26);
        make.centerY.mas_equalTo(allBtn);
    }];
    
    UILabel* maxTipLab = [[UILabel alloc]init];
    maxTipLab.textColor = HEXCOLOR(0x4a4a4a);
    maxTipLab.textAlignment = NSTextAlignmentCenter;
    maxTipLab.font = kFontSize(14);
    [self addSubview:maxTipLab];
    [maxTipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.moneyView.mas_bottom).offset(13);
        make.height.mas_equalTo(20);
    }];
    //库存量 <= limitMaxAmount 最大购买量=库存量
    if (_type == TransactionAmountTypeLimit){
        if ([_requestParams.balance floatValue] > [_requestParams.limitMaxAmount floatValue]) {
            maxTipLab.text = [NSString stringWithFormat:@"注：该卖家设置的最大购买数量为 %@ 个BUB ",[NSString stringWithFormat:@"%.2f",[_requestParams.limitMaxAmount floatValue]]];
            
        }else{
            maxTipLab.text = [NSString stringWithFormat:@"注：该卖家设置的最大购买数量为 %@ 个BUB ",[NSString stringWithFormat:@"%.2f", [_requestParams.balance floatValue]]];
        }
    }

}

- (void)actionBlock:(DataBlock)block
{
    self.block = block;
}

-(void)textField1TextChange:(UITextField *)textField
{
    if ([textField isEqual:self.numTf]) {
        self.amountTf.text = [NSString stringWithFormat:@"%.2f",[_requestParams.price floatValue] * [self.numTf.text floatValue]];
    }else{
        self.numTf.text = [NSString stringWithFormat:@"%.2f",[self.amountTf.text floatValue]/[_requestParams.price floatValue]];
    }
    if (self.block) {
        self.block(self.numTf.text);
    }
}

- (void)clickAllBtn{
    if ([_requestParams.balance floatValue] > [_requestParams.limitMaxAmount floatValue]) {
        self.numTf.text =[NSString stringWithFormat:@"%.2f",[_requestParams.limitMaxAmount floatValue]];
        self.amountTf.text = [NSString stringWithFormat:@"%.2f",[_requestParams.price floatValue] * [_requestParams.limitMaxAmount floatValue]];
    }else{
        self.numTf.text =[NSString stringWithFormat:@"%.2f",[_requestParams.balance floatValue]];
        self.amountTf.text = [NSString stringWithFormat:@"%.2f",[_requestParams.price floatValue] * [_requestParams.balance floatValue]];
    }
    
    if (self.block) {
        self.block(self.numTf.text);
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.amountTf||textField == self.numTf) {
        //如果是删除减少字数，都返回允许修改
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if (range.location>= 13)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    return YES;
}
@end
