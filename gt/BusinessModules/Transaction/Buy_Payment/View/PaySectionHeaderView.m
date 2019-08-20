//  Created by Aalto on 2018/12/28.
//  Copyright © 2018 Aalto. All rights reserved.
//

#import "PaySectionHeaderView.h"
#define kPayHeightForHeaderInSections  99//38+5

@interface PaySectionHeaderView ()
@property(nonatomic,strong)UIImageView* headerSectionLine;
@property (nonatomic, strong) UIButton *tipButton;
@property(nonatomic,strong)UIImageView* sectionLine;
@property (nonatomic, strong) NSMutableArray *funcBtns;
@end

@implementation PaySectionHeaderView
+ (void)sectionHeaderViewWith:(UITableView*)tableView{
    [tableView registerClass:[PaySectionHeaderView class] forHeaderFooterViewReuseIdentifier:PaySectionHeaderReuseIdentifier];
}
-(instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        _funcBtns = [NSMutableArray array];
        self.contentView.backgroundColor = kWhiteColor;
        self.backgroundView = [[UIView alloc] init];

        self.contentView.frame = CGRectMake(0, 0, MAINSCREEN_WIDTH, kPayHeightForHeaderInSections);
        
        self.headerSectionLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, MAINSCREEN_WIDTH, 5)];
        self.headerSectionLine.backgroundColor = HEXCOLOR(0xf6f5fa);
        [self.contentView addSubview:self.headerSectionLine];
        [self.headerSectionLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@0);
            make.height.equalTo(@5);
            make.leading.trailing.equalTo(@0);
        }];
        
        self.sectionLine = [[UIImageView alloc]init];
        self.sectionLine.backgroundColor = HEXCOLOR(0xf0f1f3);
        [self.contentView addSubview:self.sectionLine];
        [self.sectionLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-44);
            make.height.equalTo(@2);
            make.leading.trailing.equalTo(@0);
        }];
        
        NSArray* subtitleArray =@[@"",@""];
        for (int i = 0; i < subtitleArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag =  i;
            button.adjustsImageWhenHighlighted = NO;
            button.titleLabel.font = kFontSize(17);
//            button.layer.masksToBounds = YES;
//            button.layer.cornerRadius = 6;
//            button.layer.borderWidth = 1;
            
            [button setTitle:subtitleArray[i] forState:UIControlStateNormal];
            [button setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            //        [button addTarget:self action:@selector(funAdsButtonClickItem:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:button];
            [_funcBtns addObject:button];
            //        [_fucBtns[i] layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
        }
        
        
        [_funcBtns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:12 leadSpacing:20 tailSpacing:20];
        
        [_funcBtns mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.sectionLine.mas_top);
            make.top.equalTo(self.headerSectionLine.mas_bottom);
        }];
        
        self.tipButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.tipButton.userInteractionEnabled = NO;
        self.tipButton.adjustsImageWhenHighlighted = NO;
        self.tipButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.tipButton setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
        self.tipButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [self.contentView addSubview:self.tipButton];
        [self.tipButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.sectionLine.mas_bottom).offset(15);
            make.leading.equalTo(@20);
            make.height.equalTo(@20);
        }];
    }
    return self;
}


- (void)richElementsInViewWithModel:(NSDictionary*)model{
    NSDictionary *titleDic = model[kTip];
    NSString *subTitle = model[kSubTip];
    self.sectionLine.hidden = NO;
    self.headerSectionLine.hidden = NO;
//    switch (type) {
//        case IndexSectionZero:{
            _headerSectionLine.hidden = NO;
            _sectionLine.hidden = NO;
            UIButton* btn0 =_funcBtns.firstObject;
            [btn0 setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xffffff)] forState:UIControlStateNormal];
            [btn0 setTitleColor:HEXCOLOR(0x394368) forState:UIControlStateNormal];
            [btn0 setTitle:titleDic.allKeys[0] forState:UIControlStateNormal];
            btn0.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            
            UIButton* btn1 =_funcBtns.lastObject;
            [btn1 setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xffffff)] forState:UIControlStateNormal];
            [btn1 setTitleColor:HEXCOLOR(0xff9238) forState:UIControlStateNormal];
            [btn1 setTitle:titleDic.allValues[0] forState:UIControlStateNormal];
    btn1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
            [self.tipButton setTitle:subTitle forState:UIControlStateNormal];
//        }
//            break;
////
//        default:{
//            _headerSectionLine.hidden = NO;
//            _sectionLine.hidden = YES;
//        }
//            break;
//    }
}

- (void)refreshTopic:(UIButton*)sender {
}
+ (CGFloat)viewHeight
{
    return kPayHeightForHeaderInSections;
}
@end
