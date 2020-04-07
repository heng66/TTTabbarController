//
//   UIImage+Assets.h
//   TTTabbarController_Example
//
//   Created  by chenqg on 2020/4/7
//   Copyright © 2020 heng66. All rights reserved.
//
   
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Assets)

+ (UIImage *)tt_imageWithImageName:(NSString *)imageName targetCls:(Class)cls;

@end

NS_ASSUME_NONNULL_END
