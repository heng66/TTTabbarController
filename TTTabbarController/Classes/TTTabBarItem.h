//
//   TTTabBarItem.h
//   TTTabbarController_Example
//
//   Created  by chenqg on 2020/4/7
//   Copyright © 2020 heng66. All rights reserved.
//
   

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TTTabBarItem : UIControl

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL isRotating;

- (void)setSelectedImage:(UIImage *)selectedImage unselectedImage:(UIImage *)unselectedImage;
- (void)startRotationAnimation;
- (void)stopRotationAnimation;

@end

NS_ASSUME_NONNULL_END
