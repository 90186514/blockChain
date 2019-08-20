//
//  VicFaceViewController.h
//  VicCameraKit
//
//  Created by Dodgson on 1/21/19.
//  Copyright © 2019 Dodgson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VicFaceViewController : UIImagePickerController
+ (instancetype)pushFromVC:(UIViewController *)rootVC requestParams:(id )requestParams success:(DataBlock)block;

@end
