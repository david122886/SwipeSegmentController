//
//  SwipeSegmentViewController.m
//  SwipeSegementControllerContainer
//
//  Created by xxsy-ima001 on 15/7/8.
//  Copyright (c) 2015年 ___xiaoxiangwenxue___. All rights reserved.
//

#import "SwipeSegmentViewController.h"

@interface SwipeSegmentViewController ()<UIScrollViewDelegate,DRSegmentControlDelegate>
@property (nonatomic,strong) NSArray *childControllerArray;

@property (nonatomic,strong) DRSegmentControl *segmentControlView;
@property (nonatomic,strong) UIScrollView *contentScrollView;

///是否添加观察者模式
@property (nonatomic,assign) BOOL hasAddKVOForScrollView;
@end

@implementation SwipeSegmentViewController

-(void)clearChildController{
    [self.childControllerArray enumerateObjectsUsingBlock:^(UIViewController *controller, NSUInteger idx, BOOL *stop) {
        [controller willMoveToParentViewController:nil];
        [controller beginAppearanceTransition:NO animated:NO];
        [controller.view removeFromSuperview];
        [controller endAppearanceTransition];
        [controller removeFromParentViewController];
    }];
}

-(void)addSegmentControlIntoNavigationBar{
    self.segmentControlView.frame = self.navigationController.navigationBar.bounds;
    self.segmentControlView.backgroundColor = [UIColor clearColor];
    self.segmentControlView.delegate = self;
    self.segmentControlView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self.navigationController.navigationBar addSubview:self.segmentControlView];
    
    self.contentScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.contentScrollView];
    self.contentScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentScrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentScrollView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_contentScrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentScrollView)]];
}

-(void)addSegmentControlUnderNavigationBar{
    self.segmentControlView.translatesAutoresizingMaskIntoConstraints = NO;
    self.segmentControlView.backgroundColor = [UIColor lightGrayColor];
    self.segmentControlView.delegate = self;
    [self.view addSubview:self.segmentControlView];
    
    self.contentScrollView = [[UIScrollView alloc] init];
    [self.view addSubview:self.contentScrollView];
    self.contentScrollView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_segmentControlView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_segmentControlView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_segmentControlView(==44)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_segmentControlView)]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_contentScrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentScrollView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_segmentControlView][_contentScrollView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_contentScrollView,_segmentControlView)]];
}

-(void)setupSubViewAutolayout{
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count >= 2) {
        [self addSegmentControlUnderNavigationBar];
    }else{
        [self addSegmentControlIntoNavigationBar];
    }
}

-(void)setupChildControllerViewAutolayout{
    __block UIViewController *temp = nil;
    NSInteger count = self.childControllerArray.count;
    [self.childControllerArray enumerateObjectsUsingBlock:^(UIViewController *controller, NSUInteger idx, BOOL *stop) {
        [self addChildViewController:controller];
        controller.view.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentScrollView addSubview:controller.view];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:controller.view attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.contentScrollView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:controller.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.contentScrollView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
        [self.contentScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subView]|" options:0 metrics:nil views:@{@"subView":controller.view}]];
        if (!temp) {
            [self.contentScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subView]" options:0 metrics:nil views:@{@"subView":controller.view}]];
        }else
        if (count == idx+1) {
            [self.contentScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[temp][subView(==temp)]|" options:0 metrics:nil views:@{@"subView":controller.view,@"temp":temp.view}]];
        }else{
            [self.contentScrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[temp][subView(==temp)]" options:0 metrics:nil views:@{@"subView":controller.view,@"temp":temp.view}]];
        }
        temp = controller;
        [controller beginAppearanceTransition:NO animated:NO];
        [controller endAppearanceTransition];
        [controller didMoveToParentViewController:self];
    }];
}

-(void)setupControllerTitleAutolayout{
    NSMutableArray *titles = @[].mutableCopy;
    [self.childControllerArray enumerateObjectsUsingBlock:^(UIViewController *controller, NSUInteger idx, BOOL *stop) {
        [titles addObject:controller.title];
    }];
    if (!self.thumbView) {
        self.thumbView = [[UIView alloc] init];
        self.thumbView.backgroundColor = [UIColor redColor];
        self.thumbView.layer.cornerRadius = 18;
    }
    
    [self.segmentControlView addItemStrings:titles withThumbView:self.thumbView];
}

-(void)setupContentScrollViewData{
    self.contentScrollView.delegate = self;
    self.contentScrollView.bounces = NO;
    self.contentScrollView.pagingEnabled = YES;
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (!self.hasAddKVOForScrollView) {
        [self.contentScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
        self.hasAddKVOForScrollView = YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.hasAddKVOForScrollView) {
        [self.contentScrollView removeObserver:self forKeyPath:@"contentOffset"];
        self.hasAddKVOForScrollView = NO;
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setupSubViewAutolayout];
    self.contentScrollView.backgroundColor = [UIColor whiteColor];
    [self setupChildControllerViewAutolayout];
    [self setupControllerTitleAutolayout];
    [self setupContentScrollViewData];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)addChildViewControllers:(NSArray*)childControllers withSegmentControl:(Class)segmentControl{
    [self clearChildController];
    self.childControllerArray = childControllers;
    
    [self.segmentControlView removeFromSuperview];
    self.segmentControlView = [[segmentControl alloc] init];
}

#pragma mark -
#pragma mark -- UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
}
#pragma mark -


#pragma mark -
#pragma mark -- DRSegmentControlDelegate
-(void)segmentControl:(DRSegmentControl *)segmentControl withSelectedAtIndex:(NSInteger)index{
    UIViewController *child = self.childControllerArray[index];
    [self.contentScrollView scrollRectToVisible:child.view.frame animated:NO];
}
#pragma mark -

#pragma mark --

#pragma mark 监听历史记录，收藏和本地之间切换时scrollview变化
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    UIScrollView *scrollView = (UIScrollView*)object;
    if ([keyPath isEqualToString:@"contentOffset"] && scrollView && scrollView == self.contentScrollView) {
        self.segmentControlView.thumbProgress = (CGFloat)scrollView.contentOffset.x/scrollView.contentSize.width;
    }
}
#pragma mark --

#pragma mark -
#pragma mark -- property
#pragma mark -
@end
