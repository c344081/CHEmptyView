//
//  CHWeakContainer.h
//  CHEmptyViewDemo
//
//  Created by c344081 on 2019/1/4.
//  Copyright © 2019 c344081. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 主要用于关联引用中实现弱引用
 */
@interface CHWeakContainer : NSObject
/** 弱引用对象*/
@property (nonatomic, weak) id weakObject;

- (instancetype)initWithWeakObject:(id _Nullable)weakObject;

@end

NS_ASSUME_NONNULL_END
