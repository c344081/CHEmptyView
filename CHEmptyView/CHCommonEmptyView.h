//
//  CHCommonEmptyView.h
//  CHEmptyViewDemo
//
//  Created by c344081 on 2019/1/4.
//  Copyright © 2019 c344081. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHCommonEmptyView : UIView
/** 图片视图*/
@property (nonatomic, weak, readonly) UIImageView *imageView;
/** 标题文字*/
@property (nonatomic, weak, readonly) UILabel *titleLabel;
/** 描述文字*/
@property (nonatomic, weak, readonly) UILabel *detailLabel;
/** 底部个性化按钮 */
@property (nonatomic, strong) UIButton *customButton;
/** 图片和标题之间的间距*/
@property (nonatomic, assign) CGFloat titlePaddingTop;
/** 标题和描述文字之间的间距*/
@property (nonatomic, assign) CGFloat detailPaddingTop;
/** 动作按钮顶部间距*/
@property (nonatomic, assign) CGFloat buttonPaddingTop;
/** 指定图片大小, 默认使用图片自身大小*/
@property (nonatomic, assign) CGSize imageSize;
@end

NS_ASSUME_NONNULL_END
