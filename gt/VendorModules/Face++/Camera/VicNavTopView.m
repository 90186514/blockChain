//
//  VicNavTopView.m
//  VicCameraKit
//
//  Created by Dodgson on 2018/11/29.
//  Copyright © 2018 Dodgson. All rights reserved.
//

#import "VicNavTopView.h"

@interface VicNavTopView()

@property (nonatomic, strong) UIButton *rightBtn;

@end


@implementation VicNavTopView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        UIButton * back = [UIButton buttonWithType:UIButtonTypeCustom];
        [back addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
        [back setImage:[UIImage imageNamed:@"icon_back_black"] forState:UIControlStateNormal];
        [self addSubview:back];
        
        [back mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self).mas_offset(6);
//            make.top.mas_equalTo(self).mas_offset(kDevice_Is_iPhoneX ? k_time_height + 6 : 26);
            make.width.mas_equalTo(44);
            make.height.mas_equalTo(44);
            make.bottom.equalTo(self).offset(-11.f);
        }];
        
        UILabel * title = [[UILabel alloc]init];
        title.text = @"人脸认证";
        title.font = [UIFont systemFontOfSize:20.0];
        title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.height.mas_equalTo(28);
            make.centerY.mas_equalTo(back);
        }];

    }
    return self;
}

- (void)backClick{
    if(self.leftClick){
        self.leftClick();
        return;
    }
    if([self viewController].navigationController){
        [[self viewController].navigationController popViewControllerAnimated:YES];
    }else{
        [[self viewController] dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)rightClick:(UIButton *)btn{
    [btn setSelected:!btn.selected];
    if(self.rightButtonClick){
        self.rightButtonClick();
    }
}

- (UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(self.frame.size.width - 40.f, self.frame.size.height - 35.f, 25.f, 25.f)];
            [self addSubview:button];
            
            [button setImage:[UIImage imageNamed:@"camera_icon_flashlight_disable"] forState:0];
            [button setImage:[UIImage imageNamed:@"camera_icon_flashlight_auto_pressed"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(rightClick:) forControlEvents:1<<6];
            button;
        });
    }
    return _rightBtn;
}

- (UIViewController *)viewController {
    for (UIView *view = self; view; view = view.superview) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
