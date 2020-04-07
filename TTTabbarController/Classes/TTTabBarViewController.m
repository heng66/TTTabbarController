//
//   TTTabBarViewController.m
//   TTTabbarController_Example
//
//   Created  by chenqg on 2020/4/7
//   Copyright © 2020 heng66. All rights reserved.
//


#import "TTTabBarViewController.h"
#import "UIImage+Assets.h"
#import <objc/runtime.h>

static TTTabBarViewController *tabbarVC = nil;

@interface UIViewController (TTTabBarController)

- (void)tt_setTabBarController:(TTTabBarViewController *)tabBarController;

@end

@implementation UIViewController (TTTabBarController)

- (void)tt_setTabBarController:(TTTabBarViewController *)tabBarController {
    objc_setAssociatedObject(self, @selector(tt_tabBarController), tabBarController, OBJC_ASSOCIATION_ASSIGN);
}

@end

@interface TTTabBarViewController ()<TFTabBarViewDelegate>

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) TTTabBarView *tabBar;

@end

@implementation TTTabBarViewController

#pragma mark - life cycle

+ (TTTabBarViewController *)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabbarVC = [[TTTabBarViewController alloc] init];
    });
    return tabbarVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.tabBar];
    [self configTabbarController];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(stopAnimation)
                                                 name:@"stopAnimation"
                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    [self setSelectedIndex:[self selectedIndex]];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat tabBarHeight = 49;
    CGFloat bottomMargin = 0;
    if (@available(iOS 11.0, *)) {
        bottomMargin = self.view.safeAreaInsets.bottom;
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    self.tabBar.frame = CGRectMake(0, screenHeight - tabBarHeight - bottomMargin, screenWidth, tabBarHeight);
    self.contentView.frame = CGRectMake(0, 0, screenWidth, screenHeight - tabBarHeight - bottomMargin);
    self.selectedViewController.view.frame = self.contentView.bounds;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.selectedViewController.preferredStatusBarStyle;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return self.selectedViewController.preferredStatusBarUpdateAnimation;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    UIInterfaceOrientationMask orientationMask = UIInterfaceOrientationMaskAll;
    for (UIViewController *viewController in [self viewControllers]) {
        if (![viewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
            return UIInterfaceOrientationMaskPortrait;
        }
        
        UIInterfaceOrientationMask supportedOrientations = [viewController supportedInterfaceOrientations];
        if (orientationMask > supportedOrientations) {
            orientationMask = supportedOrientations;
        }
    }
    return orientationMask;
}

#pragma mark - public methods

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
    [self.view layoutIfNeeded];
    
    _tabBarHidden = hidden;
    [self.view setNeedsLayout];
    
    if (!_tabBarHidden) {
        [[self tabBar] setHidden:NO];
    }
    
    [UIView animateWithDuration:(animated ? 0.24 : 0) animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished){
        if (self.tabBarHidden) {
            [[self tabBar] setHidden:YES];
        }
    }];
}

- (void)setTabBarHidden:(BOOL)hidden {
    [self setTabBarHidden:hidden animated:NO];
}

- (void)tabBar:(TTTabBarView *)tabBar didSelectItemAtIndex:(NSInteger)index {
    if (index < 0 || index >= [[self viewControllers] count]) {
        return;
    }
    
    SEL selector = NSSelectorFromString(@"refreshTapGRAction:");
    if (index == self.selectedIndex && [self.selectedViewController respondsToSelector:selector]) {
        // 通过IMP方式调用方法避免产生警告
        IMP imp = [self.selectedViewController methodForSelector:selector];
        void (*function)(id, SEL, UIGestureRecognizer *) = (void *)imp;
        function(self.selectedViewController, selector, nil);
    }
    [self setSelectedIndex:index];
    
}

#pragma mark - internal methods

- (void)configTabbarController {
    NSArray *listArray = @[@{@"title": @"首页",
                             @"normalImg": @"home",
                             @"selectedImg": @"refresh"},
                           @{@"title": @"视频",
                             @"normalImg": @"vedio",
                             @"selectedImg": @"refresh"},
                           @{@"title": @"我的",
                             @"normalImg": @"mine",
                             @"selectedImg": @"mine_selected"}];
    
    UIViewController *homeVC = [[NSClassFromString(@"HomeViewController") alloc] init];
    UIViewController *vedioVC = [[NSClassFromString(@"VedioViewController") alloc] init];
    UIViewController *mineVC = [[NSClassFromString(@"MineViewController") alloc] init];
    
    [self setViewControllers:@[homeVC, vedioVC, mineVC]];
    
    NSInteger index = 0;
    for (TTTabBarItem *item in self.tabBar.items) {
        NSDictionary *infoDic = listArray[index];
        NSString *normalImgName = [infoDic valueForKey:@"normalImg"];
        NSString *selectedImgName = [infoDic valueForKey:@"selectedImg"];
        UIImage *normalImg = [UIImage tt_imageWithImageName:normalImgName targetCls:[self class]];
        UIImage *selectedImg = [UIImage tt_imageWithImageName:selectedImgName targetCls:[self class]];
        
        item.title = [infoDic valueForKey:@"title"];
        [item setSelectedImage:selectedImg unselectedImage:normalImg];
        index++;
    }
}

- (NSInteger)indexForViewController:(UIViewController *)viewController {
    UIViewController *searchedController = viewController;
    while (searchedController.parentViewController != nil && searchedController.parentViewController != self) {
        searchedController = searchedController.parentViewController;
    }
    return [[self viewControllers] indexOfObject:searchedController];
}

- (void)stopAnimation {
    [self.tabBar stopImageViewAnimation];
}

#pragma mark - setters

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    if (selectedIndex >= self.viewControllers.count) {
        return;
    }
    
    if ([self selectedViewController]) {
        [[self selectedViewController] willMoveToParentViewController:nil];
        [[[self selectedViewController] view] removeFromSuperview];
        [[self selectedViewController] removeFromParentViewController];
    }
    
    _selectedIndex = selectedIndex;
    [[self tabBar] setSelectedItem:[[self tabBar] items][selectedIndex]];
    
    [self setSelectedViewController:[[self viewControllers] objectAtIndex:selectedIndex]];
    [self addChildViewController:[self selectedViewController]];
    [[[self selectedViewController] view] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [[self contentView] addSubview:[[self selectedViewController] view]];
    [[self selectedViewController] didMoveToParentViewController:self];
    
    [self.view setNeedsLayout];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)setViewControllers:(NSArray *)viewControllers {
    if (_viewControllers && _viewControllers.count) {
        for (UIViewController *viewController in _viewControllers) {
            [viewController willMoveToParentViewController:nil];
            [viewController.view removeFromSuperview];
            [viewController removeFromParentViewController];
        }
    }
    
    if (viewControllers && [viewControllers isKindOfClass:[NSArray class]]) {
        _viewControllers = [viewControllers copy];
        
        NSMutableArray *tabBarItems = [[NSMutableArray alloc] init];
        
        for (UIViewController *viewController in viewControllers) {
            TTTabBarItem *tabBarItem = [[TTTabBarItem alloc] init];
            [tabBarItem setTitle:viewController.title];
            [tabBarItems addObject:tabBarItem];
            [viewController tt_setTabBarController:self];
        }
        
        [[self tabBar] setItems:tabBarItems];
    } else {
        for (UIViewController *viewController in _viewControllers) {
            [viewController tt_setTabBarController:nil];
        }
        
        _viewControllers = nil;
    }
}

#pragma mark - getters

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        [_contentView setBackgroundColor:[UIColor whiteColor]];
        [_contentView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth|
                                           UIViewAutoresizingFlexibleHeight)];
    }
    return _contentView;
}

- (TTTabBarView *)tabBar {
    if (!_tabBar) {
        _tabBar = [[TTTabBarView alloc] init];
        _tabBar.backgroundColor = [UIColor whiteColor];
        _tabBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth |
                                    UIViewAutoresizingFlexibleTopMargin |
                                    UIViewAutoresizingFlexibleLeftMargin |
                                    UIViewAutoresizingFlexibleRightMargin |
                                    UIViewAutoresizingFlexibleBottomMargin);
        [_tabBar setDelegate:self];
    }
    return _tabBar;
}

- (UIViewController *)selectedViewController {
    return [[self viewControllers] objectAtIndex:[self selectedIndex]];
}

@end


@implementation UIViewController (TTTabBarControllerItem)

- (TTTabBarViewController *)tt_tabBarController {
    TTTabBarViewController *tabBarController = objc_getAssociatedObject(self, @selector(tt_tabBarController));
    
    if (!tabBarController && self.parentViewController) {
        tabBarController = [self.parentViewController tt_tabBarController];
    }
    
    return tabBarController;
}

- (TTTabBarItem *)tt_tabBarItem {
    TTTabBarViewController *tabBarController = [self tt_tabBarController];
    NSInteger index = [tabBarController indexForViewController:self];
    return [[[tabBarController tabBar] items] objectAtIndex:index];
}

- (void)tt_setTabBarItem:(TTTabBarItem *)tabBarItem {
    TTTabBarViewController *tabBarController = [self tt_tabBarController];
    
    if (!tabBarController) {
        return;
    }
    
    TTTabBarView *tabBar = [tabBarController tabBar];
    NSInteger index = [tabBarController indexForViewController:self];
    
    NSMutableArray *tabBarItems = [[NSMutableArray alloc] initWithArray:[tabBar items]];
    [tabBarItems replaceObjectAtIndex:index withObject:tabBarItem];
    [tabBar setItems:tabBarItems];
}

@end
