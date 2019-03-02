//
//  EmptyViewUtil.h
//  CHEmptyViewDemo
//
//  Created by c344081 on 2019/1/4.
//  Copyright © 2019 c344081. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHCommonEmptyView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EmptyViewUtil : NSObject

+ (CHCommonEmptyView *)emptyViewWithTitle:(NSString *)title;

+ (CHCommonEmptyView *)errorView;

+ (UIActivityIndicatorView *)loadingView;

@end

NS_ASSUME_NONNULL_END
