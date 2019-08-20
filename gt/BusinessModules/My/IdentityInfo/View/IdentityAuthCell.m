//
//  SPCell.m
//  LiNiuYang
//
//  Created by Aalto on 2017/7/25.
//  Copyright © 2017年 LiNiu. All rights reserved.
//

#import "IdentityAuthCell.h"
#import "TransactionModel.h"
@interface IdentityAuthCell ()
@property(nonatomic,strong)UIView* bgView;

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

@implementation IdentityAuthCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self richEles];
    }
    return self;
}


- (void)richEles{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    self.contentView.backgroundColor = kTableViewBackgroundColor;
    self.backgroundView = [[UIView alloc] init];
    
    _bgView = [[UIView alloc]init];
    _bgView.backgroundColor = kWhiteColor;
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 6;
    [self.contentView addSubview:_bgView];
    [_bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.contentView).offset(15);
       make.trailing.equalTo(self.contentView).offset(-15); make.top.equalTo(self.contentView).offset(20);
        make.bottom.equalTo(self.contentView).offset(-5);
    }];

    
    
    _adIdLab = [[UILabel alloc]init];
    [self.bgView addSubview:_adIdLab];
    [_adIdLab mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.bgView).offset(22);
       make.top.equalTo(self.bgView).offset(18);
        make.height.height.equalTo(@29);
    }];
    
    _userNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.bgView addSubview:_userNameBtn];
    [_userNameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bgView).offset(-22);
        make.centerY.equalTo(self.adIdLab);
        make.height.equalTo(self.adIdLab);
    }];
    
    _typeLab = [[UILabel alloc]init];
    [self.bgView addSubview:_typeLab];
    [_typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(self.adIdLab);
   make.top.equalTo(self.adIdLab.mas_bottom).offset(5);
        make.height.equalTo(@20);
//        make.width.equalTo(@190);
    }];

    
    _saledLab = [[UILabel alloc]init];
    [self.bgView addSubview:_saledLab];
    [_saledLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.adIdLab); make.bottom.equalTo(self.bgView.mas_bottom).offset(-21);
        make.height.equalTo(@20);
        
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
    _adIdLab.font = [UIFont boldSystemFontOfSize:21];;
    _adIdLab.textColor = HEXCOLOR(0x394368);
    _adIdLab.backgroundColor = kClearColor;
    
    _userNameBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _userNameBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    [_userNameBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    
    _userNameBtn.titleLabel.font = kFontSize(14);
    _userNameBtn.titleLabel.numberOfLines = 0;
    [_userNameBtn addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    
    _typeLab.textAlignment = NSTextAlignmentLeft;
    _typeLab.font = kFontSize(15);
    _typeLab.textColor = HEXCOLOR(0x999999);

    _saledLab.textAlignment = NSTextAlignmentLeft;
//    _saledLab.font = kFontSize(14);
//    _saledLab.textColor = HEXCOLOR(0x394368);
    
}


+(instancetype)cellWith:(UITableView*)tabelView{
    static NSString *CellIdentifier = @"IdentityAuthCell";
    IdentityAuthCell *cell = (IdentityAuthCell *)[tabelView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[IdentityAuthCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel{
    return 165;
}

- (void)richElementsInCellWithModel:(id)data{
//    _modle = model;
    NSDictionary* model = data;
    
    NSDictionary* info = model[kIndexInfo];
    [_userNameBtn setTitle:info.allKeys[0] forState:UIControlStateNormal];
    _userNameBtn.userInteractionEnabled = NO;
    [_userNameBtn setImage:[UIImage imageNamed:info.allValues[0]]  forState:UIControlStateNormal];
    
    if ([model[kIndexSection] intValue]== IndexSectionZero) {
        
        IdentityAuthType type = [model[kType] intValue];
        if (type  == IdentityAuthTypeNone) {
            [_userNameBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:7];
            [_userNameBtn setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
        }else{
            [_userNameBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:7];
            if (type == IdentityAuthTypeHandling) {
                [_userNameBtn setTitleColor:HEXCOLOR(0xff9238) forState:UIControlStateNormal];
            }
            else if (type == IdentityAuthTypeRefuse) {
                [_userNameBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            else{
                [_userNameBtn setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
            }
        }
    }else{
        SeniorAuthType type = [model[kType] intValue];
        if (type  == SeniorAuthTypeUndone) {
            [_userNameBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:7];
            [_userNameBtn setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
        }else{
            [_userNameBtn layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:7];
            [_userNameBtn setTitleColor:HEXCOLOR(0x4c7fff) forState:UIControlStateNormal];
            
        }
    }
    
    
    _adIdLab.text = model[kTip];
    
    _typeLab.text = model[kSubTip];
    
    NSString* st = (NSString*)model[kData];
    _saledLab.attributedText = [NSString attributedStringWithString:@"" stringColor:HEXCOLOR(0x999999) stringFont:kFontSize(14) subString:st subStringColor:HEXCOLOR(0x999999) subStringFont:kFontSize(14) numInSubColor:HEXCOLOR(0x394368) numInSubFont:kFontSize(15)];
}
@end
