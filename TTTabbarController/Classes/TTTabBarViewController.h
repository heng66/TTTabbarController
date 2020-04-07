//
//   TTTabBarViewController.h
//   TTTabbarController_Example
//
//   Created  by chenqg on 2020/4/7
//   Copyright © 2020 heng66. All rights reserved.
//
   

#import <UIKit/UIKit.h>
#import "TTTabBarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TTTabBarViewController : UIViewController

+ (TTTabBarViewController *)sharedInstance;

@property (nonatomic, copy) NSArray<UIViewController *> *viewControllers;
@property (nonatomic, readonly) TTTabBarView *tabBar;
@property (nonatomic, weak) UIViewController *selectedViewController;
@property (nonatomic, assign) NSUInteger selectedIndex;
@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end

@interface UIViewController (TTTabBarControllerItem)

@property(nonatomic, setter = tt_setTabBarItem:) TTTabBarItem *tt_tabBarItem;
@property(nonatomic, readonly) TTTabBarViewController *tt_tabBarController;

@end

NS_ASSUME_NONNULL_END
