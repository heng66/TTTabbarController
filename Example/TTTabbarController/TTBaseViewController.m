//
//   TTBaseViewController.m
//   TTTabbarController_Example
//
//   Created  by chenqg on 2020/4/7
//   Copyright © 2020 heng66. All rights reserved.
//


#import "TTBaseViewController.h"

#define isIphoneX ({BOOL isPhoneX = NO; if (@available(iOS 11.0, *)) {isPhoneX = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0;} (isPhoneX);})
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kNavigationViewHeight (isIphoneX ? 84 : 64)
#define KNavigationiphoneXHeight (isIphoneX ? 20 : 0)

@interface TTBaseViewController ()

@property (nonatomic, strong) UIView *navigationView;

@end

@implementation TTBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.navigationView];
    
}

#pragma mark - getter

- (UIView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationViewHeight)];
        [_navigationView setBackgroundColor:[UIColor whiteColor]];
        _navigationView.userInteractionEnabled = YES;
        [_navigationView addSubview:self.navtitleLabel];
    }
    return _navigationView;
}

- (UILabel *)navtitleLabel {
    if (!_navtitleLabel) {
        _navtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 20+KNavigationiphoneXHeight, kScreenWidth-128, 44)];
        _navtitleLabel.backgroundColor = [UIColor clearColor];
        _navtitleLabel.font = [UIFont systemFontOfSize:16];
        _navtitleLabel.textColor = [UIColor redColor];
        _navtitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _navtitleLabel;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
