//
//  SCNewsViewController.m
//  IntelligentMask
//
//  Created by baolicheng on 16/2/2.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCNewsViewController.h"
#import "SCNewsDetailsViewController.h"
#import "SCNewsManager.h"
#import "Message.h"
#import "ZXAppStartManager.h"
#import "MJRefresh.h"
static NSString *cellIdentify = @"SCNewsTabelViewCellIdentify";
@interface SCNewsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *newsList;
    
    BOOL hasMore;
    NSInteger loadPage;
}
@property(nonatomic, strong) IBOutlet UILabel *lblNoNews;
@property(nonatomic, strong) IBOutlet UIButton *btnKnown;
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation SCNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setTitle:@"消息"];
    newsList = [NSMutableArray array];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self tableViewAddHeader];
    [self tableViewAddFoot];
    
    [self setSubViewHiddenStatusWithGoodListCount:1];
    loadPage = 1;
    [self requestNewsListWithPage:loadPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableViewAddHeader
{
    __weak SCNewsViewController *weakSelf = self;
    [self.tableView addHeaderWithCallback:^{
        [weakSelf refreshTableView];
    }];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"仁仁分期玩命刷新中...";
}

-(void)tableViewAddFoot
{
    __weak SCNewsViewController *weakSelf = self;
    [self.tableView addFooterWithCallback:^{
        [weakSelf insertRowAtBottom];
    }];
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"仁仁分期玩命加载中...";
}

-(void)setHasMore:(BOOL)more
{
    hasMore = more;
    if (hasMore) {
        [self tableViewFootViewInit];
    }else{
        [self tableViewFootViewOver];
        [self.tableView footerEndRefreshing];
        [self.tableView removeFooter];
    }
}

-(void)tableViewFootViewInit
{
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 21)];
    [lable setTextAlignment:NSTextAlignmentCenter];
    [lable setFont:[UIFont systemFontOfSize:15.0f]];
    [lable setTextColor:[UIColor grayColor]];
    lable.text = @"还有更多...";
    [self.tableView setTableFooterView:lable];
}

-(void)tableViewFootViewOver
{
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 21)];
    [lable setTextAlignment:NSTextAlignmentCenter];
    [lable setFont:[UIFont systemFontOfSize:15.0f]];
    [lable setTextColor:[UIColor grayColor]];
    lable.text = @"已全部加载";
    [self.tableView setTableFooterView:lable];
}

-(void)refreshTableView
{
    loadPage = 1;
    [self setHasMore:YES];
    [self tableViewAddFoot];
    
    [self requestNewsListWithPage:loadPage];
}

- (void)insertRowAtBottom {
    int64_t delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (hasMore) {
            loadPage = loadPage + 1;
            [self requestNewsListWithPage:loadPage];
        }
    });
}


-(void)requestNewsListWithPage:(NSInteger)page
{
    Member *host = [[ZXAppStartManager defaultManager] currentHost];
    if (!host) {
        return;
    }
    if (page == 1) {
        [AppUtils showProgressBarForView:self.view];
    }
    [[SCNewsManager defaultManager] requestNewsListWithPage:page WithMember:host Success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *resultDic = (NSDictionary *)responseObject;
        if (resultDic) {
            NSDictionary *dataDic = [resultDic objectForKey:@"data"];
            if (dataDic) {
                NSInteger lastPage = [[dataDic objectForKey:@"last"] integerValue];
                if (lastPage == page) {
                    [self setHasMore:NO];
                }else if (page < lastPage){
                    [self setHasMore:YES];
                }
                NSArray *list = [dataDic objectForKey:@"data"];
                if (list) {
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    for (NSDictionary *m in list) {
                        Message *message = [[Message alloc] init];
                        message.messageId = [NSString stringWithFormat:@"%@",[m objectForKey:@"msg_id"]];
                        message.content = [m objectForKey:@"content"];
                        [arr addObject:message];
                    }
                    if (arr.count > 0) {
                        if (page == 1) {
                            newsList = [NSMutableArray arrayWithArray:arr];
                        }else{
                            [newsList addObjectsFromArray:arr];
                        }
                    }
                    
                    [self setSubViewHiddenStatusWithGoodListCount:newsList.count];
                    [self.tableView reloadData];
                }
            }
        }
        if (page == 1) {
            [AppUtils hideProgressBarForView:self.view];
            [self.tableView headerEndRefreshing];
        }else{
            [self.tableView footerEndRefreshing];
        }
    } Error:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (page == 1) {
            [AppUtils hideProgressBarForView:self.view];
            [self.tableView headerEndRefreshing];
        }else{
            [self.tableView footerEndRefreshing];
        }

    } Failed:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (page == 1) {
            [AppUtils hideProgressBarForView:self.view];
            [self.tableView headerEndRefreshing];
        }else{
            [self.tableView footerEndRefreshing];
        }
    }];
}

-(void)setSubViewHiddenStatusWithGoodListCount:(NSInteger)count
{
    if (count > 0) {
        [self.tableView setHidden:NO];
        [self.lblNoNews setHidden:YES];
        [self.btnKnown setHidden:YES];
    }else{
        [self.tableView setHidden:YES];
        [self.lblNoNews setHidden:NO];
        [self.btnKnown setHidden:NO];
    }
}

-(IBAction)clickKnowBtn:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73.0f;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return newsList.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentify];
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {
            //Data processing
            Message *message = [newsList objectAtIndex:indexPath.section];
            dispatch_async(dispatch_get_main_queue(), ^{
                //Update Interface
                [cell.textLabel setText:message.content];
            });
        }
    });
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Message *message = [newsList objectAtIndex:indexPath.section];
    SCNewsDetailsViewController *scNewsDetailsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsDetailsViewIdentify"];
    [scNewsDetailsVC setTextViewContent:message.content];
    [self.navigationController pushViewController:scNewsDetailsVC animated:YES];
}

@end
