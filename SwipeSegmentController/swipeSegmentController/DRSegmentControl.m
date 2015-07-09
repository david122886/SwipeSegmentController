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
-(NSInteger)getThumbViewWidthWithItemStringArray:(NSArray*)itemStringArray{
    if (!itemStringArray || itemStringArray.count <= 0) {
        return CGRectGetWidth([[UIScreen mainScreen] bounds]);
    }
    return CGRectGetWidth([[UIScreen mainScreen] bounds])/itemStringArray.count;
}

-(void)clear{
    if (self.thumbView) {
        [self.thumbView removeFromSuperview];
    }
    [self.itemArray enumerateObjectsUsingBlock:^(UIButton *item, NSUInteger idx, BOOL *stop) {
        [item removeFromSuperview];
    }];
}

-(void)addItemStrings:(NSArray*)itemStringArray withThumbView:(UIView*)thumbView{
    [self clear];
    _thumbView = thumbView;
    thumbView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:thumbView];
    
    NSInteger thumbWidth = [self getThumbViewWidthWithItemStringArray:itemStringArray];
    NSArray *thumbConstraints = [self thumbConstraintsWithThumbWidth:thumbWidth withThumbView:thumbView];
    [self addConstraints:thumbConstraints];
    [thumbConstraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger idx, BOOL *stop) {
        if (constraint.firstItem == thumbView && constraint.firstAttribute == NSLayoutAttributeLeading) {
            self.thumbLeadingConstraint = constraint;
            *stop = YES;
        }
    }];
    
    NSMutableArray *items = @[].mutableCopy;
    __block UIButton *temp = nil;
    NSInteger itemCount = itemStringArray.count;
    [itemStringArray enumerateObjectsUsingBlock:^(NSString *itemString, NSUInteger idx, BOOL *stop) {
        UIButton *item = [self getItemWithTag:idx withTitle:itemString];
        item.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:item];
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[item]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(item)]];
        if (!temp) {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[item]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(item)]];
        }else
        if (idx == itemCount -1) {
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[temp][item(==temp)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(item,temp)]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:temp attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
        }else{
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[temp][item(==temp)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(item,temp)]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:item attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:temp attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
        }

        temp = item;
        [items addObject:item];
    }];
    self.itemArray = items;
    
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
    self.thumbLeadingConstraint.constant = CGRectGetWidth(self.frame)*thumbProgress;
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
-(NSArray*)thumbConstraintsWithThumbWidth:(CGFloat)thumbWidth withThumbView:(UIView*)thumbView{
    NSMutableArray *constraints = @[].mutableCopy;
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[thumbView(==width)]" options:0 metrics:@{@"width":@(thumbWidth)} views:NSDictionaryOfVariableBindings(thumbView)]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-space-[thumbView]-space-|" options:0 metrics:@{@"space":@(kThumbTopMargin)} views:NSDictionaryOfVariableBindings(thumbView)]];
    return constraints;
}

#pragma mark -
@end
