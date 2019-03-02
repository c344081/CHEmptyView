//
//  UIScrollView+EmptyAble.m
//  CHEmptyViewDemo
//
//  Created by c344081 on 2019/1/4.
//  Copyright © 2019 c344081. All rights reserved.
//

#import "UIScrollView+EmptyAble.h"
#import "CHWeakContainer.h"
#import <objc/runtime.h>

#define kEmptyContainerTag 0x8768
static char kEmptyViewCtx;


/**
 较简易的监听, 便于移除并避免外部也对`ScrollView`进行观察时的影响
 */
@interface CHEmptyViewObserver : NSObject
/** 监听到变化时调用*/
@property (nonatomic, copy) void(^block)(NSString *keyPath, id value);
@property (nonatomic, weak) id weakTarget;
@property (nonatomic, copy) NSString *key;
- (void)observerForTarget:(id)target keyPath:(NSString *)keyPath block:(void(^)(NSString *keyPath, id value))block;
@end


@implementation CHEmptyViewObserver

- (void)observerForTarget:(id)target keyPath:(NSString *)keyPath block:(void(^)(NSString *keyPath, id value))block {
    [self removeObserver];
    _weakTarget = target;
    _key = keyPath;
    _block = block;
    [target addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:&kEmptyViewCtx];
}

- (void)removeObserver {
    if (_key) {
        [_weakTarget removeObserver:self forKeyPath:_key context:&kEmptyViewCtx];
        _key = nil;
        _weakTarget = nil;
        _block = nil;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    id value = [_weakTarget valueForKeyPath:keyPath];
    !_block ?: _block(keyPath, value);
}

- (void)dealloc {
    [self removeObserver];
}

@end


@implementation UIScrollView (EmptyAble)

- (void)setEmptyState:(CHEmptyState)emptyState {
    objc_setAssociatedObject(self, @selector(emptyState), @(emptyState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    // 处理滚动状态
    BOOL allowScroll = emptyState != CHEmptyStateFailed && emptyState != CHEmptyStateLoading;
    if ([self.emptyDelegate respondsToSelector:@selector(emptyViewShouldAllowScroll:forState:)]) {
        allowScroll = [self.emptyDelegate emptyViewShouldAllowScroll:self forState:self.emptyState];
    }
    self.scrollEnabled = allowScroll;
    
    // 处理容器视图
    UIView *containerView = [self viewWithTag:kEmptyContainerTag];
    if (containerView) {
        [containerView removeFromSuperview];
    }
    
    // 此状态是否展示空视图(None状态始终不展示)
    BOOL shouldDisplay = emptyState != CHEmptyStateNone;
    if ([self.emptyDelegate respondsToSelector:@selector(scrollView:shouldDisplayEmptyViewForState:)]) {
        shouldDisplay &= [self.emptyDelegate scrollView:self shouldDisplayEmptyViewForState:emptyState];
    }
    if (!shouldDisplay) { return; }
    
    
    // 处理空视图
    UIView *emptyView = nil;
    if ([self.emptyDataSource respondsToSelector:@selector(scrollView:emptyViewForState:)]) {
        emptyView = [self.emptyDataSource scrollView:self emptyViewForState:emptyState];
    }
    
    if (!emptyView) { return; }
    
    containerView = [[UIView alloc] init];
    [self addSubview:containerView];
    containerView.tag = kEmptyContainerTag;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(CH_empty_tap:)];
    [containerView addGestureRecognizer:tapGesture];
//    if (@available(iOS 11.0, *)) {
//        containerView.translatesAutoresizingMaskIntoConstraints = NO;
//        NSMutableArray<NSLayoutConstraint *> *constraints = [NSMutableArray array];
//        [constraints addObject:[containerView.leadingAnchor constraintEqualToAnchor:self.contentLayoutGuide.leadingAnchor]];
//        [constraints addObject:[containerView.trailingAnchor constraintEqualToAnchor:self.frameLayoutGuide.trailingAnchor]];
//        [constraints addObject:[containerView.topAnchor constraintEqualToAnchor:self.contentLayoutGuide.topAnchor]];
//        [constraints addObject:[containerView.bottomAnchor constraintEqualToAnchor:self.frameLayoutGuide.bottomAnchor]];
//        [NSLayoutConstraint activateConstraints:constraints];
//    } else {
        CHEmptyViewObserver *observer = objc_getAssociatedObject(containerView, _cmd);
        if (!observer) {
            observer = [[CHEmptyViewObserver alloc] init];
            objc_setAssociatedObject(containerView, _cmd, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            __weak __auto_type weakSelf = self;
            __weak __auto_type weakContainerView = containerView;
            [observer observerForTarget:self keyPath:@"contentOffset" block:^(NSString *keyPath, id value) {
                __strong __auto_type self = weakSelf;
                __strong __auto_type containerView = weakContainerView;
                CGPoint offset = [value CGPointValue];
                containerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame) + offset.x, CGRectGetHeight(self.frame) + offset.y);
            }];
        }
//    }
    
    // 添加背景视图
    UIView *backgroundView = nil;
    if ([self.emptyDataSource respondsToSelector:@selector(scrollView:emptyBackgroundViewForState:)]) {
        backgroundView = [self.emptyDataSource scrollView:self emptyBackgroundViewForState:emptyState];
    }
    if (backgroundView) {
        [containerView addSubview:backgroundView];
        backgroundView.frame = containerView.bounds;
        backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    
    // add emptyView
    [containerView addSubview:emptyView];
    if ([self.emptyDelegate respondsToSelector:@selector(scrollView:willDisplayEmptyView:forState:)]) {
        [self.emptyDelegate scrollView:self willDisplayEmptyView:emptyView forState:emptyState];
    }
    CGRect frame = emptyView.frame;
    frame.size = [emptyView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    emptyView.frame = frame;
    CGFloat offsetY = 135 * CGRectGetWidth(UIScreen.mainScreen.bounds) / 375.0;
    CGFloat offsetX = -self.contentInset.left;
    if ([self.emptyDelegate respondsToSelector:@selector(scrollView:verticleOffsetForEmptyView:)]) {
        offsetY = [self.emptyDelegate scrollView:self verticleOffsetForEmptyView:emptyView];
    }
    
    if ([self.emptyDelegate respondsToSelector:@selector(scrollView:horizontalOffsetForEmptyView:)]) {
        offsetX = [self.emptyDelegate scrollView:self horizontalOffsetForEmptyView:self];
    }
    emptyView.translatesAutoresizingMaskIntoConstraints = NO;
    [emptyView.centerXAnchor constraintEqualToAnchor:containerView.centerXAnchor constant:offsetX].active = YES;
    [emptyView.topAnchor constraintEqualToAnchor:containerView.topAnchor constant:offsetY].active = YES;
    
    if ([self.emptyDelegate respondsToSelector:@selector(scrollView:didDisplayEmptyView:forState:)]) {
        [self.emptyDelegate scrollView:self didDisplayEmptyView:emptyView forState:emptyState];
    }
}

- (CHEmptyState)emptyState {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (id<UIScrollViewEmptyDelegate>)emptyDelegate {
    CHWeakContainer *container = objc_getAssociatedObject(self, _cmd);
    return container.weakObject;
}

- (void)setEmptyDelegate:(id<UIScrollViewEmptyDelegate>)emptyDelegate {
    CHWeakContainer *container = [[CHWeakContainer alloc] initWithWeakObject:emptyDelegate];
    objc_setAssociatedObject(self, @selector(emptyDelegate), container, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<UIScrollViewEmptyDataSource>)emptyDataSource {
    CHWeakContainer *container = objc_getAssociatedObject(self, _cmd);
    return container.weakObject;
}

- (void)setEmptyDataSource:(id<UIScrollViewEmptyDataSource>)emptyDataSource {
    CHWeakContainer *container = [[CHWeakContainer alloc] initWithWeakObject:emptyDataSource];
    objc_setAssociatedObject(self, @selector(emptyDataSource), container, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - action

- (void)CH_empty_tap:(UITapGestureRecognizer *)tap {
    BOOL allowTouch = YES;
    if ([self.emptyDelegate respondsToSelector:@selector(emptyViewShouldAllowTouch:forState:)]) {
        allowTouch &= [self.emptyDelegate emptyViewShouldAllowTouch:self forState:self.emptyState];
    }
    if (!allowTouch) {  return; }
    
    if ([self.emptyDelegate respondsToSelector:@selector(scrollView:didTap:)]) {
        [self.emptyDelegate scrollView:self didTap:[self CHEmptyContainer]];
    }
}

#pragma mark - private

#pragma mark - getter

- (UIView *)CHEmptyContainer {
    return [self viewWithTag:kEmptyContainerTag];
}

@end
