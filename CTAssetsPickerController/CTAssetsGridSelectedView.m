/*
 
 MIT License (MIT)
 
 Copyright (c) 2013 Clement CN Tsang
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 */

#import <PureLayout/PureLayout.h>
#import "CTAssetsPickerDefines.h"
#import "CTAssetsGridSelectedView.h"
#import "CTAssetCheckmark.h"
#import "CTAssetSelectionLabel.h"




@interface CTAssetsGridSelectedView ()

@property (nonatomic, strong) CTAssetCheckmark *checkmark;
@property (nonatomic, strong) CTAssetSelectionLabel *selectionIndexLabel;

@end





@implementation CTAssetsGridSelectedView {
    CALayer *_innerLayer;
    UIView *_backgroundView;
    BOOL _didSetupConstraints;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self setupViews];
        self.showsSelectionIndex = NO;
    }
    
    return self;
}


#pragma mark - Setup

- (void)setupViews
{
    _backgroundView = [UIView newAutoLayoutView];
    [self addSubview:_backgroundView];

    _backgroundView.backgroundColor = CTAssetsGridSelectedViewBackgroundColor;
    _backgroundView.layer.borderColor = CTAssetsGridSelectedViewTintColor.CGColor;

    _innerLayer = [CALayer new];
    _innerLayer.borderColor = CTAssetsGridSelectedViewTintColor.CGColor;
    _innerLayer.frame = _backgroundView.layer.bounds;
    [_innerLayer removeFromSuperlayer];
    [_backgroundView.layer addSublayer:_innerLayer];

    CTAssetCheckmark *checkmark = [CTAssetCheckmark newAutoLayoutView];
    self.checkmark = checkmark;
    [self addSubview:checkmark];
    
    CTAssetSelectionLabel *selectionIndexLabel = [CTAssetSelectionLabel newAutoLayoutView];
    self.selectionIndexLabel = selectionIndexLabel;
    
    [self addSubview:self.selectionIndexLabel];
}

-(void)layoutSubviews {
    [super layoutSubviews];

    _innerLayer.frame = self.layer.bounds;
}

-(void)updateConstraints {
    if (!_didSetupConstraints) {
        [_backgroundView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];

        _didSetupConstraints = YES;
    }

    [super updateConstraints];
}

#pragma mark - Accessors

- (void)setShowsSelectionIndex:(BOOL)showsSelectionIndex
{
    _showsSelectionIndex = showsSelectionIndex;
    
    if (showsSelectionIndex)
    {
        self.checkmark.hidden = YES;
        self.selectionIndexLabel.hidden = NO;
    }
    else
    {
        self.checkmark.hidden = NO;
        self.selectionIndexLabel.hidden = YES;
    }
}

- (void)setSelectionIndex:(NSUInteger)selectionIndex
{
    _selectionIndex = selectionIndex;
    self.selectionIndexLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)(selectionIndex + 1)];
}


#pragma mark - Apperance

- (UIColor *)selectedBackgroundColor
{
    return _backgroundView.backgroundColor;
}

- (void)setSelectedBackgroundColor:(UIColor *)backgroundColor
{
    UIColor *color = (backgroundColor) ? backgroundColor : CTAssetsGridSelectedViewBackgroundColor;
    _backgroundView.backgroundColor = color;
}

- (CGFloat)borderWidth
{
    return _backgroundView.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _backgroundView.layer.borderWidth = borderWidth;
    _innerLayer.borderWidth = borderWidth;
}

- (void)setTintColor:(UIColor *)tintColor
{
    UIColor *color = (tintColor) ? tintColor : CTAssetsGridSelectedViewTintColor;
    _backgroundView.layer.borderColor = color.CGColor;
    _innerLayer.borderColor = color.CGColor;
}

- (void)setOuterCornerRadius:(CGFloat)cornerRadius
{
    _backgroundView.layer.cornerRadius = cornerRadius;
}

- (void)setInnerCornerRadius:(CGFloat)cornerRadius
{
    _innerLayer.cornerRadius = cornerRadius;
}

#pragma mark - Accessibility Label

- (NSString *)accessibilityLabel
{
    return self.selectionIndexLabel.text;
}


@end
