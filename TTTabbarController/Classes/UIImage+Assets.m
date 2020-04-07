//
//   UIImage+Assets.m
//   TTTabbarController_Example
//
//   Created  by chenqg on 2020/4/7
//   Copyright © 2020 heng66. All rights reserved.
//
   

#import "UIImage+Assets.h"

@implementation UIImage (Assets)

+ (UIImage *)tt_imageWithImageName:(NSString *)imageName targetCls:(Class)cls {

    NSParameterAssert(imageName);
    NSParameterAssert(cls);
    
    NSBundle *bundle = [NSBundle bundleForClass:cls];
    NSString *bundleName = bundle.infoDictionary[@"CFBundleName"];
    NSString *path = [NSString stringWithFormat:@"/%@.bundle",bundleName];
    NSString *bundlePath = [bundle.resourcePath
                                stringByAppendingPathComponent:path];
    bundle = [NSBundle bundleWithPath:bundlePath];
    UIImage *image = [UIImage imageNamed:imageName
                                    inBundle:bundle
               compatibleWithTraitCollection:nil];
    if (!image) {
        NSLog(@"Image not found, imgName:%@", imageName);
    }
    return image;

}

@end
