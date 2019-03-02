//
//  EmptyViewUtil.m
//  CHEmptyViewDemo
//
//  Created by c344081 on 2019/1/4.
//  Copyright © 2019 c344081. All rights reserved.
//

#import "EmptyViewUtil.h"


#define kDefaultEmptyImageName @"empty"
#define kDefaultErrorImageName @"error"

@implementation EmptyViewUtil

+ (CHCommonEmptyView *)emptyViewWithTitle:(NSString *)title {
    CHCommonEmptyView *emptyView = [[CHCommonEmptyView alloc] init];
    emptyView.titleLabel.text = title;
    emptyView.imageView.image = [UIImage imageNamed:kDefaultEmptyImageName];
    return emptyView;
}

+ (CHCommonEmptyView *)errorView {
    CHCommonEmptyView *emptyView = [[CHCommonEmptyView alloc] init];
    emptyView.titleLabel.text = @"网络不给力，请稍后重试";
    emptyView.detailLabel.text = @"请点击页面刷新";
    emptyView.imageView.image = [UIImage imageNamed:kDefaultErrorImageName];
    return emptyView;
}

+ (UIActivityIndicatorView *)loadingView {
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView startAnimating];
    return indicatorView;
}

@end
