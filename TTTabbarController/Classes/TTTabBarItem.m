//
//   TTTabBarItem.m
//   TTTabbarController_Example
//
//   Created  by chenqg on 2020/4/7
//   Copyright © 2020 heng66. All rights reserved.
//


#import "TTTabBarItem.h"

@interface TTTabBarItem ()

@property (nonatomic, strong) UIImageView *itemImgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImage *unselectedImage;
@property (nonatomic, strong) UIImage *selectedImage;

@end

@implementation TTTabBarItem

#pragma mark - life cycle

- (void)layoutSubviews {
    CGSize itemSize = self.frame.size;
    self.itemImgView.frame = CGRectMake(0, 10, itemSize.width, 19);
    self.titleLabel.frame = CGRectMake(0, itemSize.height-16, itemSize.width, 16);
}

#pragma mark - public methods

- (void)setSelectedImage:(UIImage *)selectedImage unselectedImage:(UIImage *)unselectedImage {
    self.selectedImage = selectedImage;
    self.unselectedImage = unselectedImage;
    
    if (unselectedImage) {
        self.itemImgView.image = unselectedImage;
    } else {
        if (selectedImage) {
            self.itemImgView.image = selectedImage;
        }
    }
}

- (void)startRotationAnimation {
    self.isRotating = YES;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    animation.duration = 0.8;
    animation.cumulative = YES;
    animation.removedOnCompletion = NO;
    animation.repeatCount = 66;
    [self.itemImgView.layer addAnimation:animation forKey:nil];
}

- (void)stopRotationAnimation {
    self.isRotating = NO;
    [self.itemImgView.layer removeAllAnimations];
}

#pragma makr - setters

- (void)setTitle:(NSString *)title {
    if (title) {
        _title = title;
        self.titleLabel.text = title;
    }
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    [self stopRotationAnimation];
    if (selected) {
        self.itemImgView.image = self.selectedImage;
        self.titleLabel.textColor = [UIColor redColor];
    } else {
        self.itemImgView.image = self.unselectedImage;
        self.titleLabel.textColor = [UIColor grayColor];
    }
}

#pragma mark - getters

- (UIImageView *)itemImgView {
    if (!_itemImgView) {
        _itemImgView = [[UIImageView alloc] init];
        _itemImgView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_itemImgView];
    }
    return _itemImgView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:10];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

@end
