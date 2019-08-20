//
//  VicCameraBottomView.h
//  VicCameraKit
//
//  Created by Dodgson on 2018/11/29.
//  Copyright © 2018 Dodgson. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VicCameraBottomView : UIView

@property (nonatomic, copy) void(^returnClick)(void);

@property (nonatomic, copy) void(^takePhotoClick)(void);

@property (nonatomic, copy) void(^switchPhotoClick)(void);

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, strong) UIImageView *hintImageView;

@property (nonatomic, strong) UILabel *hintLabel;

@property (nonatomic, strong) UIButton *returnBtn;

@property (nonatomic, strong) UIButton *takePhotoBtn;

@property (nonatomic, strong) UIButton *switchDirectBtn;

- (void)updateViewWith:(int)type time:(NSInteger)time;


@end
