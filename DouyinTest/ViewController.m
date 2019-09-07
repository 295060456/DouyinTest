//
//  ViewController.m
//  DouyinTest
//
//  Created by 梅森鹏 on 2019/9/4.
//  Copyright © 2019 simple. All rights reserved.
//

#import "ViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <Masonry.h>
#import <UIScrollView+MJExtension.h>
#import <UIScrollView+MJRefresh.h>

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

//listView
@property (nonatomic, strong) UITableView  *listView;

//data
@property (nonatomic, strong) NSMutableArray  *datas;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI
{
    if (@available(iOS 11.0, *)) {
        self.listView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.listView.estimatedRowHeight = 0;
        self.listView.estimatedSectionFooterHeight = 0;
        self.listView.estimatedSectionHeaderHeight=0 ;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self.view addSubview:self.listView];
    [self.listView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    [self.listView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    
    self.listView.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{
        
    }];
    self.listView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        
    }];
    
//    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//
//
//    }];
//
//    self.listView.mj_header = header;
    
    
    MJRefreshAutoNormalFooter * footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        //self.listView.pagingEnabled = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            
            [self.listView.mj_footer endRefreshingWithCompletionBlock:^{
                
            }];
        
            NSInteger count = self.datas.count;
            [self.datas addObjectsFromArray:@[@2,@3,@4,@6]];

            //[self.listView reloadData];
            NSMutableArray *indexPaths = [NSMutableArray array];
            for (NSInteger i = count; i < count + 4; i ++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:indexPath];
            }

            [self.listView beginUpdates];
            [self.listView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [self.listView endUpdates];
            
            //self.listView.pagingEnabled = YES;
            
            //[self.listView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
           
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.listView setContentOffset:CGPointMake(0, self.listView.contentOffset.y - 44 + self.view.bounds.size.height) animated:YES];
            });
            
        });
        
    }];

    self.listView.mj_footer = footer;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"scrollView contentOffset:%@  edge %@",NSStringFromCGPoint(scrollView.contentOffset),NSStringFromUIEdgeInsets(scrollView.contentInset));
    
    NSInteger d = scrollView.contentOffset.y / self.view.bounds.size.height;
    
   // [scrollView setContentOffset:CGPointMake(0, d * self.view.bounds.size.height)];
    
}



#pragma mark ==========<UITableViewDelegate,UITableViewDataSource>===========

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    int R = (arc4random() % 256);
    int G = (arc4random() % 256);
    int B = (arc4random() % 256);
    cell.backgroundColor = [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
    cell.textLabel.text = [NSString stringWithFormat:@"cellIndex:%ld",indexPath.row];
    return cell;
}



#pragma mark ==========get===========
- (UITableView *)listView
{
    if (_listView == nil) {
        _listView = [[UITableView alloc] init];
        _listView.dataSource = self;
        _listView.delegate = self;
        _listView.rowHeight = self.view.bounds.size.height;
        _listView.estimatedRowHeight = self.view.bounds.size.height;
        _listView.pagingEnabled = YES;
        _listView.estimatedSectionFooterHeight = 0;
    }
    return _listView;
}

- (NSMutableArray *)datas
{
    if (_datas == nil) {
        _datas = [NSMutableArray arrayWithArray:@[@1,@3,@4]];
    }
    return _datas;
}

@end
