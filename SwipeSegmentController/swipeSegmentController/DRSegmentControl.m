//
//  DRSegment.m
//  SwipeSegmentController
//
//  Created by xxsy-ima001 on 15/7/8.
//  Copyright (c) 2015年 ___xiaoxiangwenxue___. All rights reserved.
//

#import "DRSegmentControl.h"
#define kSegmentItemStartTag 500
#define kThumbTopMargin 5
@interface DRSegmentControl ()
@property (nonatomic,strong) NSArray *itemArray;
@property (nonatomic,strong) NSLayoutConstraint *thumbLeadingConstraint;
@end

@implementation DRSegmentControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)itemButtonClicked:(UIButton*)bt{
    self.selectedIndex = bt.tag - kSegmentItemStartTag;
}

-(UIButton*)getItemWithTag:(NSInteger)tag withTitle:(NSString*)title{
    UIButton *bt = [[UIButton alloc] init];
    bt.backgroundColor = [UIColor clearColor];
    [bt setTitle:title forState:UIControlStateNormal];
    [bt setTitleColor:self.itemTitleTextColor?:[UIColor whiteColor] forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(itemButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    bt.tag = tag + kSegmentItemStartTag;
    return bt;
}

-(void)clear{
    if (self.thumbView) {
        [self.thumbView removeFromSuperview];
    }
    [self.itemArray enumerateObjectsUsingBlock:^(UIButton *item, NSUInteger idx, BOOL *stop) {
        [item removeFromSuperview];
    }];
}

-(void)addItemStrings:(NSArray*)itemStringArray
        withThumbView:(UIView*)thumbView
       withThumbWidth:(NSInteger)thumbWidth
    withItemAlignType:(DRSegmentControlItemAlignType)alignType{
    [self clear];
    _itemAlignType = alignType;
    _thumbWidth = thumbWidth;
    _thumbView = thumbView;
    thumbView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:thumbView];
    
    NSArray *thumbConstraints = [self thumbConstraintsWithThumbWidth:thumbWidth withThumbView:thumbView withSegmentItemAlignType:alignType withItemCount:itemStringArray.count];
    [self addConstraints:thumbConstraints];
    [thumbConstraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if (constraint.firstItem == thumbView && constraint.firstAttribute == NSLayoutAttributeLeading) {
            self.thumbLeadingConstraint = constraint;
            *stop = YES;
        }
    }];
    
    NSMutableArray *items = @[].mutableCopy;
    __block UIButton *temp = nil;
    [itemStringArray enumerateObjectsUsingBlock:^(NSString *itemString, NSUInteger idx, BOOL *stop) {
        UIButton *item = [self getItemWithTag:idx withTitle:itemString];
        item.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:item];
        temp = item;
        [items addObject:item];
    }];
    self.itemArray = items;
    [self addConstraints:[self segmentItemsConstraintsWithItemWidth:thumbWidth withSegmentItemAlignType:alignType withItems:self.itemArray]];
    [self layoutIfNeeded];
}

-(void)setSelectedIndex:(NSInteger)selectedIndex{
    _selectedIndex = selectedIndex;
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentControl:withSelectedAtIndex:)]) {
        [self.delegate segmentControl:self withSelectedAtIndex:selectedIndex];
    }
}

-(void)setSelectedIndexWithoutAction:(NSInteger)selectedIndex{
    UIView *item = [self viewWithTag:kSegmentItemStartTag + selectedIndex];
    CGFloat centerX = CGRectGetMidX(item.frame);
    self.thumbLeadingConstraint.constant = centerX + CGRectGetWidth(self.thumbView.frame);
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

-(void)setThumbProgress:(CGFloat)thumbProgress{
    _thumbProgress = thumbProgress;
    if (self.itemAlignType == DRSegmentControlItemAlignType_stretch || self.thumbWidth <= 0.000001) {
        self.thumbLeadingConstraint.constant = CGRectGetWidth(self.frame)*thumbProgress;
    }else{
        CGFloat totalWidth = self.itemArray.count*self.thumbWidth;
        self.thumbLeadingConstraint.constant = CGRectGetWidth(self.frame)/2 - totalWidth/2 + totalWidth*thumbProgress;
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        [self layoutIfNeeded];
    }];
}

-(void)setItemTitleTextColor:(UIColor *)itemTitleTextColor{
    _itemTitleTextColor = itemTitleTextColor;
    [self.itemArray enumerateObjectsUsingBlock:^(UIButton *item, NSUInteger idx, BOOL *stop) {
        [item setTitleColor:itemTitleTextColor forState:UIControlStateNormal];
    }];
}


#pragma mark -
#pragma mark -- 子类继承实现
-(NSArray*)thumbConstraintsWithThumbWidth:(CGFloat)thumbWidth
                            withThumbView:(UIView*)thumbView
                 withSegmentItemAlignType:(DRSegmentControlItemAlignType)itemAlignType
                            withItemCount:(NSInteger)itemCount
{
     NSMutableArray *constraints = @[].mutableCopy;
    if (thumbWidth < 0.00001 || itemAlignType == DRSegmentControlItemAlignType_stretch) {
        ///均分
        CGFloat itemWidth = itemCount<=0?CGRectGetWidth([[UIScreen mainScreen] bounds]):CGRectGetWidth([[UIScreen mainScreen] bounds])/itemCount;
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[thumbView(==width)]" options:0 metrics:@{@"width":@(itemWidth)} views:NSDictionaryOfVariableBindings(thumbView)]];
    }else{
        ///中间靠拢
        CGFloat totalWidth = itemCount*self.thumbWidth;
        CGFloat left = CGRectGetWidth([[UIScreen mainScreen] bounds])/2 - totalWidth/2;
        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-(left)-[thumbView(==width)]" options:0 metrics:@{@"width":@(thumbWidth),@"left":@(left)} views:NSDictionaryOfVariableBindings(thumbView)]];
    }
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-space-[thumbView]-space-|" options:0 metrics:@{@"space":@(kThumbTopMargin)} views:NSDictionaryOfVariableBindings(thumbView)]];
    return constraints;
}


///实现自己分段控件item布局 autolayout
-(NSArray*)segmentItemsConstraintsWithItemWidth:(CGFloat)itemWidth
                       withSegmentItemAlignType:(DRSegmentControlItemAlignType)itemAlignType
                                      withItems:(NSArray*)itemsArray
{
    NSMutableArray *constraints = @[].mutableCopy;
    __block UIButton *temp = nil;
    
    if (itemWidth < 0.00001 || itemAlignType == DRSegmentControlItemAlignType_stretch) {
        ///平铺
        NSInteger itemCount = itemsArray.count;
        [itemsArray enumerateObjectsUsingBlock:^(UIButton *item, NSUInteger idx, BOOL *stop) {
            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[item]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(item)]];
            if (!temp) {
                [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[item]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(item)]];
            }else
                if (idx == itemCount -1) {
                    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[temp][item(==temp)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(item,temp)]];
                    [constraints addObject:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:temp attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
                }else{
                    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[temp][item(==temp)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(item,temp)]];
                    [constraints addObject:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:temp attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
                }
            
            temp = item;
        }];
    }else{
        ///居中
        NSInteger midIndex = itemsArray.count/2;
        UIButton *item = [itemsArray objectAtIndex:midIndex];
        if (itemsArray.count%2 == 0) {
            [constraints addObject:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:itemWidth/2.0]];
        }else{
            [constraints addObject:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
        }

        [itemsArray enumerateObjectsUsingBlock:^(UIButton *item, NSUInteger idx, BOOL *stop) {
            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[item]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(item)]];
            if (temp) {
                [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"[temp][item(==width)]" options:0 metrics:@{@"width":@(itemWidth)} views:NSDictionaryOfVariableBindings(item,temp)]];
            }else{
                [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"[item(==width)]" options:0 metrics:@{@"width":@(itemWidth)} views:NSDictionaryOfVariableBindings(item)]];
            }
            temp = item;
        }];
    }
    return constraints;
}
#pragma mark -
@end
