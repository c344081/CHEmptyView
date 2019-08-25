//
//  UIScrollView+EmptyAble.h
//  CHEmptyViewDemo
//
//  Created by c344081 on 2019/1/4.
//  Copyright © 2019 c344081. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHCommonEmptyView.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, CHEmptyState) {
    CHEmptyStateNone            = 0,
    CHEmptyStateLoading         = 1 << 0,
    CHEmptyStateEmptyList       = 1 << 1,
    CHEmptyStateFailed          = 1 << 2,
};

@protocol UIScrollViewEmptyDataSource <NSObject>

/**
 特定状态下的空视图
 
 @note 内部不会缓存, 状态切换后将被移除
 @param scrollView 滚动视图
 @param state 将要转换的状态
 @return 视图
 */
- (nullable UIView *)scrollView:(UIScrollView *)scrollView emptyViewForState:(CHEmptyState)state;

@optional

/**
 背景视图
 
 @param scrollView 当前滚动视图
 @param state 将要转换的状态
 @return 背景视图
 */
- (nullable UIView *)scrollView:(UIScrollView *)scrollView emptyBackgroundViewForState:(CHEmptyState)state;

@end


@protocol UIScrollViewEmptyDelegate <NSObject>

@optional

/**
 空视图顶部偏移量, 默认135
 
 @note 按照scrollView内容区域的frame来计算即可
 @param scrollView 滚动式图
 @return 偏移量
 */
- (CGFloat)scrollView:(UIScrollView *)scrollView verticleOffsetForEmptyView:(UIView *)emptyView;

/**
 空视图中心点X轴偏移量, 默认居中

 @param scrollView scrollView
 @param emptyView 空视图
 @return 偏移量
 */
- (CGFloat)scrollView:(UIScrollView *)scrollView horizontalOffsetForEmptyView:(UIView *)emptyView;

/**
 空视图容器视图的边距

 @note 通常用来展示tableHeaderView
 @param scrollView 滚动视图
 @param containerView 空视图的容器视图
 @param emptyView 空视图
 @return 边距
 */
- (UIEdgeInsets)scrollView:(UIScrollView *)scrollView
contentInsetForContainerView:(UIView *)containerView
               ofEmptyView:(UIView *)emptyView;

/**
 特定状态下是否能显示空视图
 
 @note 默认状态不显示, 其他显示
 
 @param scrollView 滚动视图
 @param state 将要转换的状态
 @return 是否显示
 */
- (BOOL)scrollView:(UIScrollView *)scrollView shouldDisplayEmptyViewForState:(CHEmptyState)state;

/**
 即将显示空视图
 
 @note 仅在可以显示时调用
 @param scrollView 滚动视图
 @param emptyView 空视图
 @param state 状态
 */
- (void)scrollView:(UIScrollView *)scrollView willDisplayEmptyView:(UIView *)emptyView forState:(CHEmptyState)state;

/**
 空视图已显示
 
 @note 仅在可以显示时调用
 @param scrollView 滚动视图
 @param emptyView 空视图
 @param state 状态
 */
- (void)scrollView:(UIScrollView *)scrollView didDisplayEmptyView:(UIView *)emptyView forState:(CHEmptyState)state;


/**
 空视图是否允许点击
 
 @param scrollView 当前滚动视图
 @param state 当前状态
 @return 是否允许
 */
- (BOOL)emptyViewShouldAllowTouch:(UIScrollView *)scrollView forState:(CHEmptyState)state;

/**
 空视图是否允许滚动视图滚动,
 默认错误和loading不允许, e.g. 可在显示时禁止下拉刷新
 
 @param scrollView 当前滚动视图
 @return 是否允许
 */
- (BOOL)emptyViewShouldAllowScroll:(UIScrollView *)scrollView forState:(CHEmptyState)state;

/**
 空视图被点击
 
 @param scrollView 当前滚动视图
 @param view 空视图容器视图
 */
- (void)scrollView:(UIScrollView *)scrollView didTap:(UIView *)view;

@end


@interface UIScrollView (EmptyAble)

/** 空视图状态*/
@property (nonatomic, assign) CHEmptyState emptyState;

/** 空视图代理*/
@property (nonatomic, weak) id<UIScrollViewEmptyDelegate> emptyDelegate;

/** 空视图数据源*/
@property (nonatomic, weak) id<UIScrollViewEmptyDataSource> emptyDataSource;


@end

NS_ASSUME_NONNULL_END
