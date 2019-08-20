//
//  HomeInfoTableViewCell.m
//  OTC
//
//  Created by David on 2018/11/21.
//  Copyright © 2018年 yang peng. All rights reserved.
//

#import "HomeInfoTableViewCell.h"
#import "HomeModel.h"
@implementation HomeInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(instancetype)cellWith:(UITableView*)tabelView{
    [tabelView registerNib:[UINib nibWithNibName:@"HomeInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"HomeInfoTableViewCell"];
    HomeInfoTableViewCell *cell = (HomeInfoTableViewCell *)[tabelView dequeueReusableCellWithIdentifier:@"HomeInfoTableViewCell"];
    if (!cell) {
        cell = [[HomeInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HomeInfoTableViewCell"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

+ (CGFloat)cellHeightWithModel:(HomeData*)data{
    
    return 80;
}

- (void)richElementsInCellWithModel:(HomeData*)listModel{
    self.homeCoinLab.text = [NSString stringWithFormat:@"$ %.2f",[listModel.price floatValue]];
    
    self.homeRMBLab.text = [NSString stringWithFormat:@"￥ %.2f",[listModel.rmbPrice floatValue]];
    
    self.homeTypeLab.text = listModel.coinId;
    
//    self.homeTypeImage.image = [UIImage imageNamed:listModel.coinId];
    [self.homeTypeImage setImageWithURL:[NSURL URLWithString:listModel.coinImageUrl] placeholderImage:kIMG(@"icon-in-app")];
    
    if ([listModel.upAndDown floatValue] > 0) {
        self.homeUpDownLab.text = [NSString stringWithFormat:@"+%@",listModel.upAndDown];
        self.homeUpDownLab.textColor = HEXCOLOR(0xd02a2a);
        self.homeUpDownLab.backgroundColor =  HEXCOLOR(0xffe6ed);
    }else{
        self.homeUpDownLab.text = [NSString stringWithFormat:@"%@",listModel.upAndDown];
        self.homeUpDownLab.textColor = HEXCOLOR(0x043891);
        self.homeUpDownLab.backgroundColor = HEXCOLOR(0xdaeeff);
    }
    self.homeUpDownLab.layer.cornerRadius = 6;
    self.homeUpDownLab.layer.masksToBounds = YES;
}
@end
