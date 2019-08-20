//
//  VicCameraBottomView.m
//  VicCameraKit
//
//  Created by Dodgson on 2018/11/29.
//  Copyright © 2018 Dodgson. All rights reserved.
//

#import "VicCameraBottomView.h"
#import "UIView+CCAdditions.h"

@interface VicCameraBottomView()


@end


@implementation VicCameraBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self titleLabel];
        [self contentLabel];
        [self hintLabel];
        [self hintImageView];
        [_titleLabel setText:@"人脸识别"];
        [_contentLabel setText:@"请将面部按照图示放在指定区域内"];
        
    }
    return self;
}

- (void)tapClick{
    if(self.takePhotoClick){
        self.takePhotoClick();
    }
}

- (void)updateViewWith:(int)type time:(NSInteger)time{
    if(type == 1){
        //fail
        [_hintLabel setText:@"验证失败,请重新验证"];
        [_hintLabel setTextColor:HEXCOLOR(0xf70000)];
        [_hintImageView setImage:[UIImage imageNamed:@"auth_icon_wrong"]];
        [_hintLabel setTextAlignment:NSTextAlignmentRight];
        [_hintLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-VicRateW(92.f));
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(VicRateH(54.f));
        }];
        [_hintImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.hintLabel);
            make.right.mas_equalTo(self.hintLabel.mas_left).offset(-VicRateW(10.f));
        }];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            if([self viewController].navigationController){
                [[self viewController].navigationController popViewControllerAnimated:YES];
            }else{
                [[self viewController] dismissViewControllerAnimated:YES completion:nil];
            }
        });
        
    }else if (type == 2){
        [_hintLabel setText:[NSString stringWithFormat:@"%ld",(long)time]];
        [_hintLabel setTextColor:HEXCOLOR(0x1E69F8)];
        [_hintLabel setTextAlignment:NSTextAlignmentCenter];
        [_hintLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(VicRateH(54.f));
        }];
    }
    else if (type == 3){
        [_hintLabel setText:@"校验中"];
        [_hintLabel setTextColor:HEXCOLOR(0x1E69F8)];
        [_hintLabel setTextAlignment:NSTextAlignmentCenter];
        [_hintLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(VicRateH(54.f));
        }];
    }
    else if (type == 4){
        //success
        [_hintLabel setText:@"验证成功"];
        [_hintLabel setTextColor:HEXCOLOR(0x1E69F8)];
        [_hintLabel setTextAlignment:NSTextAlignmentRight];
        [_hintImageView setImage:[UIImage imageNamed:@"auth_icon_right"]];
        [_hintLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-VicRateW(132.f));
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(VicRateH(54.f));
        }];
        [_hintImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.hintLabel);
            make.right.mas_equalTo(self.hintLabel.mas_left).offset(-VicRateW(10.f));
        }];
        dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5/*延迟执行时间*/ * NSEC_PER_SEC));
        
        dispatch_after(delayTime, dispatch_get_main_queue(), ^{
            if([self viewController].navigationController){
                [[self viewController].navigationController popViewControllerAnimated:YES];
            }else{
                [[self viewController] dismissViewControllerAnimated:YES completion:nil];
            }
        });
    }
    else if (type == 5){
        [_hintLabel setText:@""];
        [_hintLabel setTextColor:HEXCOLOR(0x1E69F8)];
        [_hintLabel setTextAlignment:NSTextAlignmentCenter];
        [_hintLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self);
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(VicRateH(54.f));
        }];
    }

}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] init];
            [self addSubview:label];
            [label setFont:[UIFont systemFontOfSize:30.f]];
            [label setTextColor:[UIColor blackColor]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self);
                make.top.mas_equalTo(self).offset(VicRateH(27.5f));
            }];
            label;
        });
    }
    return _titleLabel;
}

- (UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = ({
            UILabel *label = [[UILabel alloc] init];
            [self addSubview:label];
            [label setFont:kFontSize(15)];
            [label setTextColor:[UIColor blackColor]];
            [label setTextAlignment:NSTextAlignmentCenter];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self);
                make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(VicRateH(6.f));
            }];
            label;
        });
    }
    return _contentLabel;
}

- (UILabel *)hintLabel{
    if (!_hintLabel) {
        _hintLabel = ({
            UILabel *label = [[UILabel alloc] init];
            [self addSubview:label];
            [label setFont:kFontSize(18)];
            [label setTextAlignment:NSTextAlignmentRight];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.mas_equalTo(self);
                make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(VicRateH(54.f));
            }];
            label;
        });
    }
    return _hintLabel;
}

- (UIImageView *)hintImageView{
    if (!_hintImageView) {
        _hintImageView = ({
            UIImageView *imgView = [[UIImageView alloc] init];
            [imgView setContentMode:UIViewContentModeScaleAspectFill];
            [imgView setClipsToBounds:YES];
            [self addSubview:imgView];
            imgView;
        });
    }
    return _hintImageView;
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
