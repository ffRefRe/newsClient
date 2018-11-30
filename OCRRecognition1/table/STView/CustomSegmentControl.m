//
//  CustomSegmentControl.m
//  SwipeTableView
//
//  Created by Roy lee on 16/5/28.
//  Copyright © 2016年 Roy lee. All rights reserved.
//

#import "CustomSegmentControl.h"
#import "UIView+STFrame.h"
#define RGBColor(r,g,b)     [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

@interface CustomSegmentControl ()

@property (nonatomic, strong) UIScrollView * contentView;
@property (nonatomic, strong) NSArray * items;

@end

@implementation CustomSegmentControl

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithItems:(NSArray *)items {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        if (items.count > 0) {
            self.items = items;
        }
    }
    return self;
}

- (void)commonInit {
 

    _contentView = [[UIScrollView alloc]init];
    [self addSubview:_contentView];
    _selectedSegmentIndex = 0;
    
    int tempX = 90 * 6;
    CGSize size = _contentView.contentSize;
    
    size.width = tempX;
    //设置不显示横拉动条
    _contentView.showsHorizontalScrollIndicator = NO;
    //showsVerticalScrollIndicator 设置竖滚动条是否显示
    _contentView.contentSize = size;
    //设置反弹效果
    _contentView.bounces = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    for (UIView *subView in _contentView.subviews) {
        [subView removeFromSuperview];
    }
    
    _contentView.backgroundColor = _backgroundColor;
    _contentView.frame = self.bounds;
    for (int i = 0; i < _items.count; i ++) {
        UIButton * itemBt = [UIButton buttonWithType:UIButtonTypeCustom];
        itemBt.tag = 666 + i;
        [itemBt setTitleColor:_textColor forState:UIControlStateNormal];
        [itemBt setTitleColor:_selectedTextColor forState:UIControlStateSelected];
        [itemBt setTitle:_items[i] forState:UIControlStateNormal];
        [itemBt.titleLabel setFont:_font];
//        NSLog(@"%f",self.st_width);
        CGFloat itemWidth = self.st_width/_items.count;
        itemBt.st_size = CGSizeMake(itemWidth, self.st_height);
        itemBt.st_x    = itemWidth * i;
        if (i == _selectedSegmentIndex) {
            itemBt.backgroundColor = _selectionIndicatorColor;
            itemBt.selected = YES;
        }else {
            itemBt.backgroundColor = [UIColor clearColor];
        }
        [itemBt addTarget:self action:@selector(didSelectedSegment:) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:itemBt];
    }
}

- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
    UIButton * oldItemBt      = [_contentView viewWithTag:666 + _selectedSegmentIndex];
    oldItemBt.backgroundColor = [UIColor clearColor];
    oldItemBt.selected        = NO;
    
    UIButton * itemBt      = [_contentView viewWithTag:666 + selectedSegmentIndex];
    itemBt.backgroundColor = _selectionIndicatorColor;
    itemBt.selected        = YES;
    _selectedSegmentIndex  = selectedSegmentIndex;
}

- (void)didSelectedSegment:(UIButton *)itemBt {
    UIButton * oldItemBt      = [_contentView viewWithTag:666 + _selectedSegmentIndex];
    oldItemBt.backgroundColor = [UIColor clearColor];
    oldItemBt.selected        = NO;
    
    itemBt.backgroundColor = _selectionIndicatorColor;
    itemBt.selected        = YES;
    _selectedSegmentIndex  = itemBt.tag - 666;
    if (self.IndexChangeBlock) {
        self.IndexChangeBlock(_selectedSegmentIndex);
    }
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}

@end





