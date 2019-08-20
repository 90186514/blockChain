//  Created by Aalto on 2018/12/23.
//  Copyright © 2018 Aalto. All rights reserved.
//
#import "PayStatusCell.h"
#import "PayModel.h"

@interface PayStatusCell ()
@property (nonatomic, strong) NSMutableArray *btns;
@property(nonatomic,copy)ActionBlock block;
@end

@implementation PayStatusCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self richEles];
    }
    return self;
}

- (void)richEles{
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    self.contentView.backgroundColor = kWhiteColor;
    self.backgroundView = [[UIView alloc] init];
    
    _btns = [NSMutableArray array];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsImageWhenHighlighted = NO;
        button.tag =  i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        //        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        
        [button setTitleColor:HEXCOLOR(0x394368) forState:UIControlStateNormal];
        //        [button setImage:[UIImage imageNamed:@"checkbox"] forState:UIControlStateNormal];
        
        //        button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //        [button addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:button];
        [_btns addObject:button];
        //        [_btns[i] layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    }
    UIButton* bt0 =_btns[0];
    bt0.titleLabel.font = kFontSize(15);
    [bt0 setTitleColor:HEXCOLOR(0x666666) forState:UIControlStateNormal];
    bt0.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    UIButton* bt1 =_btns[1];
    bt1.titleLabel.font = kFontSize(16);
    [bt1 setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    bt1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    bt1.titleLabel.numberOfLines = 1;
    
    
    [_btns mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:MAINSCREEN_WIDTH leadSpacing:20 tailSpacing:20];
    
    [_btns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@11);
        make.height.mas_equalTo(@20);
    }];

}

- (void)clickItem:(UIButton*)button{
   
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}


+(instancetype)cellWith:(UITableView*)tabelView{
    PayStatusCell *cell = (PayStatusCell *)[tabelView dequeueReusableCellWithIdentifier:@"PayStatusCell"];
    if (!cell) {
        cell = [[PayStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PayStatusCell"];
    }
    return cell;
}

+ (CGFloat)cellHeightWithModel:(id)model{
    return 11+21;
}

- (void)richElementsInCellWithModel:(NSDictionary*)model WithArr:(NSArray*)arr WithIndexPath:(NSIndexPath*)indexPath{
    UIButton* bt0 =_btns[0];
    UIButton* bt1 =_btns[1];
    [bt0 setTitle:model.allKeys[0] forState:UIControlStateNormal];
    [bt1 setTitle:model.allValues[0] forState:UIControlStateNormal];
    [bt1 setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    if (!(arr.count < 2)) {
        if (indexPath.row < 2) {
            [bt1 setImage:[UIImage imageNamed:@"iconCopy"] forState:UIControlStateNormal];
            [bt1 layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:10];
            [bt1 addTarget:self action:@selector(copylinkBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [bt1 setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        }
    }
    
    
}
- (void)copylinkBtnClick:(UIButton*)sender {
    [YKToastView showToastText:@"复制成功!"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = sender.titleLabel.text;
    if (self.block) {
        self.block(pasteboard.string);
    }
}
- (void)actionBlock:(ActionBlock)block{
    self.block = block;
}

@end
