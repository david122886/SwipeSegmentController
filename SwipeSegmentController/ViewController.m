//
//  ViewController.m
//  SwipeSegmentController
//
//  Created by xxsy-ima001 on 15/7/8.
//  Copyright (c) 2015年 ___xiaoxiangwenxue___. All rights reserved.
//

#import "ViewController.h"
#import "SwipeSegmentViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    UIViewController *c1 = [[UIViewController alloc] init];
    c1.title = @"精选";
    c1.view.backgroundColor = [UIColor redColor];
    
    UIViewController *c2 = [[UIViewController alloc] init];
    c2.title = @"分类";
    c2.view.backgroundColor = [UIColor greenColor];
    
    UIViewController *c3 = [[UIViewController alloc] init];
    c3.title = @"排行";
    c3.view.backgroundColor = [UIColor blueColor];
    
    UIViewController *c4 = [[UIViewController alloc] init];
    c4.title = @"包月";
    c4.view.backgroundColor = [UIColor blueColor];
    
    UIViewController *c5 = [[UIViewController alloc] init];
    c5.title = @"免费";
    c5.view.backgroundColor = [UIColor blueColor];
    
    
    if ([segue.identifier isEqualToString:@"cover"]) {
        [(SwipeSegmentViewController*)segue.destinationViewController addChildViewControllers:@[c1,c2,c3,c4,c5] withSegmentControl:[DRSegmentControl class]];
        
        UIView *thumbView = [[UIView alloc] init];
        thumbView.backgroundColor = [UIColor greenColor];
        thumbView.layer.cornerRadius = 15;
        
        [(SwipeSegmentViewController*)segue.destinationViewController setThumbView:thumbView];
    }else if([segue.identifier isEqualToString:@"underline"]){
        [(SwipeSegmentViewController*)segue.destinationViewController addChildViewControllers:@[c1,c2,c3,c4,c5] withSegmentControl:[DRUnderlineSegmentControl class]];
    }else{
        UINavigationController *navi = segue.destinationViewController;
        [(SwipeSegmentViewController*)[navi.viewControllers lastObject] addChildViewControllers:@[c1,c2,c3,c4,c5] withSegmentControl:[DRUnderlineSegmentControl class]];
    }
}
@end
