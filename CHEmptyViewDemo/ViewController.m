//
//  ViewController.m
//  CHEmptyViewDemo
//
//  Created by chenhao on 2019/3/2.
//  Copyright © 2019 c344081. All rights reserved.
//

#import "ViewController.h"
#import "Item.h"
#import "UIScrollView+EmptyAble.h"
#import "EmptyViewUtil.h"

#define kHeaderViewH 55

@interface ViewController () <UIScrollViewEmptyDataSource, UIScrollViewEmptyDelegate>
/** 数据源*/
@property (nonatomic, strong) NSMutableArray<Item *> *dataSource;
/** 数据*/
@property (nonatomic, copy) NSArray<Item *> *items;
/** 错误*/
@property (nonatomic, assign) BOOL hasError;
/** 无数据*/
@property (nonatomic, assign) BOOL hasData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableHeaderView = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), kHeaderViewH);
        [button addTarget:self action:@selector(headerAction:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@"This is a headerView" forState:UIControlStateNormal];
        button.backgroundColor = UIColor.darkGrayColor;
        button;
    });
    self.tableView.emptyDelegate = self;
    self.tableView.emptyDataSource = self;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(loadData) forControlEvents:UIControlEventValueChanged];
    self.tableView.refreshControl = refreshControl;
    [self beginRefresh];
}

#pragma mark - action

- (void)headerAction:(id)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (IBAction)normalAction:(id)sender {
    self.hasData = YES;
    self.hasError = NO;
    [self beginRefresh];
}

- (IBAction)emptyAction:(id)sender {
    self.hasData = NO;
    self.hasError = NO;
    [self beginRefresh];
}

- (IBAction)failedAction:(id)sender {
    self.hasData = NO;
    self.hasError = YES;
    [self beginRefresh];
}

#pragma mark - private

- (void)beginRefresh {
    if (self.tableView.refreshControl.isRefreshing) {
        return;
    }
    [self.tableView setContentOffset:CGPointZero animated:YES];
    [self.tableView setContentOffset:CGPointMake(0, -114) animated:YES];
    [self.tableView.refreshControl beginRefreshing];
    [self loadData];
}

- (void)loadData {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tableView.refreshControl endRefreshing];
        if (self.hasError) {
            self.tableView.emptyState = CHEmptyStateFailed;
            return;
        }
        if (!self.hasData) {
            [self.dataSource removeAllObjects];
        } else {
            [self.dataSource setArray:self.items];
        }
        self.tableView.emptyState = self.dataSource.count > 0 ? CHEmptyStateNone : CHEmptyStateEmptyList;
        [self.tableView reloadData];
    });
}

#pragma mark - UIScrollViewEmptyDataSource

- (UIView *)scrollView:(UIScrollView *)scrollView emptyViewForState:(CHEmptyState)state {
    UIView *view = nil;
    switch (state) {
        case CHEmptyStateLoading:
            // custom loading
            view = EmptyViewUtil.loadingView;
            break;
        case CHEmptyStateFailed:
            view = EmptyViewUtil.errorView;
            break;
        case CHEmptyStateEmptyList:
            view = [EmptyViewUtil emptyViewWithTitle:@"no data"];
            break;
        default:
            break;
    }
    return view;
}

- (UIView *)scrollView:(UIScrollView *)scrollView emptyBackgroundViewForState:(CHEmptyState)state {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.f green:arc4random_uniform(256)/255.f blue:arc4random_uniform(256)/255.f alpha:1.0];
    return view;
}

#pragma mark - UIScrollViewEmptyDelegate

- (void)scrollView:(UIScrollView *)scrollView didTap:(UIView *)view {
    [self beginRefresh];
}

- (UIEdgeInsets)scrollView:(UIScrollView *)scrollView contentInsetForContainerView:(UIView *)containerView ofEmptyView:(UIView *)emptyView {
    // extra inset
    return UIEdgeInsetsMake(CGRectGetHeight(self.tableView.tableHeaderView.frame), 0 ,0 ,0);
}

- (CGFloat)scrollView:(UIScrollView *)scrollView verticleOffsetForEmptyView:(UIView *)emptyView {
    // 居中显示
    CGFloat height = CGRectGetHeight(self.navigationController.navigationBar.frame);
    height += CGRectGetHeight(UIApplication.sharedApplication.statusBarFrame);
    return (CGRectGetHeight(UIScreen.mainScreen.bounds) - CGRectGetHeight(emptyView.frame)) * 0.5 - height;
}

#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const reuseId = @"reuseId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    Item *obj = self.dataSource[indexPath.row];
    cell.textLabel.text = obj.title;
    return cell;
}

#pragma mark - getter

- (NSMutableArray<Item *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSArray<Item *> *)items {
    if (!_items) {
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 0; i < 50; ++i) {
            Item *obj = [[Item alloc] init];
            obj.title = [NSString stringWithFormat:@"第%d行", i];
            [arrayM addObject:obj];
        }
        _items = arrayM.copy;
    }
    return _items;
}

@end
