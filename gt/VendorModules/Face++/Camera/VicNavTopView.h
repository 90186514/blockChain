//
//  VicNavTopView.h
//  VicCameraKit
//
//  Created by Dodgson on 2018/11/29.
//  Copyright © 2018 Dodgson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VicNavTopView : UIView

@property (nonatomic, copy) void(^rightButtonClick)(void);

@property (nonatomic, copy) void(^leftClick)(void);
@end
