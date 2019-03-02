//
//  CHWeakContainer.m
//  CHEmptyViewDemo
//
//  Created by c344081 on 2019/1/4.
//  Copyright © 2019 c344081. All rights reserved.
//

#import "CHWeakContainer.h"

@implementation CHWeakContainer

- (instancetype)initWithWeakObject:(id)weakObject {
    self = [super init];
    if (self) {
        self.weakObject = weakObject;
    }
    return self;
}

@end
