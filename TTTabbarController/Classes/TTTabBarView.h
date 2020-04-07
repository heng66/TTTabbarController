//
//   TTTabBarView.h
//   TTTabbarController_Example
//
//   Created  by chenqg on 2020/4/7
//   Copyright © 2020 heng66. All rights reserved.
//
   

#import <UIKit/UIKit.h>
#import "TTTabBarItem.h"

NS_ASSUME_NONNULL_BEGIN

@class TTTabBarView;
@protocol TFTabBarViewDelegate <NSObject>

- (void)tabBar:(TTTabBarView *)tabBar didSelectItemAtIndex:(NSInteger)index;

@end


@interface TTTabBarView : UIView

@property (nonatomic, weak) id <TFTabBarViewDelegate> delegate;
@property (nonatomic, strong) CALayer *lineLayer;
@property (nonatomic, copy) NSArray *items;
@property (nonatomic, weak) TTTabBarItem *selectedItem;
@property (nonatomic, readonly) UIView *backgroundView;
@property (nonatomic, getter=isTranslucent) BOOL translucent;

- (void)setHeight:(CGFloat)height;
- (void)stopImageViewAnimation;

@end

NS_ASSUME_NONNULL_END
