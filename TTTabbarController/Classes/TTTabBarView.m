//
//   TTTabBarView.m
//   TTTabbarController_Example
//
//   Created  by chenqg on 2020/4/7
//   Copyright © 2020 heng66. All rights reserved.
//


#import "TTTabBarView.h"

@interface TTTabBarView ()

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation TTTabBarView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInitialization];
    }
    return self;
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (void)layoutSubviews {
    CGSize frameSize = self.frame.size;
    self.lineLayer.frame = CGRectMake(0, 0, frameSize.width, 1/[UIScreen mainScreen].scale);
    self.backgroundView.frame = self.frame;
    self.itemWidth = roundf(frameSize.width / self.items.count);
    
    NSInteger index = 0;
    for (TTTabBarItem *item in self.items) {
        CGFloat itemHeight = frameSize.height;
        [item setFrame:CGRectMake(index * self.itemWidth,
                                  roundf(frameSize.height - itemHeight),
                                  self.itemWidth,
                                  itemHeight)];
        [item setNeedsDisplay];
        index++;
    }
}

- (void)setItemWidth:(CGFloat)itemWidth {
    if (itemWidth > 0) {
        _itemWidth = itemWidth;
    }
}

- (void)setItems:(NSArray *)items {
    for (TTTabBarItem *item in _items) {
        [item removeFromSuperview];
    }
    
    _items = [items copy];
    for (TTTabBarItem *item in _items) {
        [item addTarget:self action:@selector(tabBarItemWasSelected:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:item];
    }
}

- (void)setHeight:(CGFloat)height {
    [self setFrame:CGRectMake(CGRectGetMinX(self.frame),
                              CGRectGetMinY(self.frame),
                              CGRectGetWidth(self.frame),
                              height)];
}

- (void)stopImageViewAnimation {
    [self.selectedItem stopRotationAnimation];
}

- (void)tabBarItemWasSelected:(TTTabBarItem *)sender {
    if (sender.isRotating) {
        return;
    }
    
    NSInteger index = [self.items indexOfObject:self.selectedItem];
    if ([self selectedItem] == sender && (index == 0 || index == 1)) {
        [[self selectedItem] startRotationAnimation];
    }
    
    [self setSelectedItem:sender];
    if ([[self delegate] respondsToSelector:@selector(tabBar:didSelectItemAtIndex:)]) {
        NSInteger newIndex = [self.items indexOfObject:self.selectedItem];
        [[self delegate] tabBar:self didSelectItemAtIndex:newIndex];
    }
}

- (void)setSelectedItem:(TTTabBarItem *)selectedItem {
    if (selectedItem == _selectedItem) {
        return;
    }
    [_selectedItem setSelected:NO];
    
    _selectedItem = selectedItem;
    [_selectedItem setSelected:YES];
}


- (void)setTranslucent:(BOOL)translucent {
    _translucent = translucent;
    
    CGFloat alpha = (translucent ? 0.9 : 1.0);
    [_backgroundView setBackgroundColor:[UIColor colorWithRed:245/255.0
                                                        green:245/255.0
                                                         blue:245/255.0
                                                        alpha:alpha]];
}

- (BOOL)isAccessibilityElement {
    return NO;
}

- (NSInteger)accessibilityElementCount {
    return self.items.count;
}

- (id)accessibilityElementAtIndex:(NSInteger)index {
    return self.items[index];
}

- (NSInteger)indexOfAccessibilityElement:(id)element {
    return [self.items indexOfObject:element];
}

#pragma mark - internal methods

- (void)commonInitialization {
    _translucent = NO;
    
    _backgroundView = [[UIView alloc] init];
    [self addSubview:_backgroundView];
    
    _lineLayer = [CALayer layer];
    _lineLayer.backgroundColor = [UIColor colorWithRed:230/255. green:230/255. blue:230/255. alpha:1].CGColor;
    [self.layer addSublayer:_lineLayer];
}

@end
