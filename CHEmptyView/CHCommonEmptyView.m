//
//  CHCommonEmptyView.m
//  CHEmptyViewDemo
//
//  Created by c344081 on 2019/1/4.
//  Copyright © 2019 c344081. All rights reserved.
//

#import "CHCommonEmptyView.h"

@interface CHCommonEmptyView ()
/** 图片视图*/
@property (nonatomic, weak, readwrite) UIImageView *imageView;
/** 描述文字*/
@property (nonatomic, weak, readwrite) UILabel *titleLabel;
/** 描述文字*/
@property (nonatomic, weak, readwrite) UILabel *detailLabel;
/** wrap view*/
@property (nonatomic, weak) UIStackView *wrapView;
/** image & title wrapper*/
@property (nonatomic, weak) UIStackView *imageTitleWrapView;
/** detail wrapper*/
@property (nonatomic, weak) UIStackView *detailWrapView;
@end

@implementation CHCommonEmptyView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titlePaddingTop = 8;
        self.buttonPaddingTop = 5;
        self.detailPaddingTop = 6.5;
        
        UIStackView *wrapView = [[UIStackView alloc] init];
        [self addSubview:wrapView];
        self.wrapView = wrapView;
        wrapView.axis = UILayoutConstraintAxisVertical;
        wrapView.spacing = self.buttonPaddingTop;
        
        UIStackView *detailWrapView = [[UIStackView alloc] init];
        [wrapView addArrangedSubview:detailWrapView];
        self.detailWrapView = detailWrapView;
        detailWrapView.axis = UILayoutConstraintAxisVertical;
        detailWrapView.spacing = self.detailPaddingTop;
        
        // image + title
        UIStackView *stackView = [[UIStackView alloc] init];
        [detailWrapView addArrangedSubview:stackView];
        self.imageTitleWrapView = stackView;
        stackView.axis = UILayoutConstraintAxisVertical;
        stackView.spacing = self.titlePaddingTop;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [stackView addArrangedSubview:imageView];
        self.imageView = imageView;
        
        UILabel *titleLabel = [[UILabel alloc] init];
        [stackView addArrangedSubview:titleLabel];
        self.titleLabel = titleLabel;
        titleLabel.font = [UIFont systemFontOfSize:16];
        titleLabel.textColor = [UIColor colorWithWhite:155/255.f alpha:1.0];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        
        UILabel *detailLabel = [[UILabel alloc] init];
        [detailWrapView addArrangedSubview:detailLabel];
        self.detailLabel = detailLabel;
        detailLabel.font = [UIFont systemFontOfSize:12];
        detailLabel.textColor = [UIColor colorWithRed:212/255.f green:212/255.f blue:214/255.f alpha:1.0];
        detailLabel.textAlignment = NSTextAlignmentCenter;
        
        // layout
        wrapView.translatesAutoresizingMaskIntoConstraints = NO;
        NSMutableArray *constraints = [NSMutableArray array];
        [constraints addObject:[wrapView.leadingAnchor constraintEqualToAnchor:self.leadingAnchor]];
        [constraints addObject:[wrapView.trailingAnchor constraintEqualToAnchor:self.trailingAnchor]];
        [constraints addObject:[wrapView.topAnchor constraintEqualToAnchor:self.topAnchor]];
        [constraints addObject:[wrapView.bottomAnchor constraintEqualToAnchor:self.bottomAnchor]];
        [NSLayoutConstraint activateConstraints:constraints];
    }
    return self;
}

- (void)setButtonPaddingTop:(CGFloat)buttonPaddingTop {
    _buttonPaddingTop = buttonPaddingTop;
    self.wrapView.spacing = buttonPaddingTop;
}

- (void)setTitlePaddingTop:(CGFloat)titlePaddingTop {
    _titlePaddingTop = titlePaddingTop;
    self.imageTitleWrapView.spacing = titlePaddingTop;
}

- (void)setDetailPaddingTop:(CGFloat)detailPaddingTop {
    _detailPaddingTop = detailPaddingTop;
    self.detailWrapView.spacing = detailPaddingTop;
}

- (void)setCustomButton:(UIButton *)customButton {
    [_customButton removeFromSuperview];
    [self.wrapView addArrangedSubview:customButton];
    _customButton = customButton;
}

- (void)setImageSize:(CGSize)imageSize {
    _imageSize = imageSize;
    CGRect frame = self.imageView.frame;
    frame.size = imageSize;
    self.imageView.frame = frame;
}

@end
