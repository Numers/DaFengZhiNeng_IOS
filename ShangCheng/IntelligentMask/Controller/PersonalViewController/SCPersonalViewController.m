//
//  SCPersonalViewController.m
//  IntelligentMask
//
//  Created by baolicheng on 16/1/19.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCPersonalViewController.h"
#import "SCPersonalHeadView.h"
#import "CExpandHeader.h"
#import "ZXAppStartManager.h"

#import "UINavigationController+PHNavigationController.h"

#import "SCNewsViewController.h"
#import "SCMyDeviceTableViewController.h"
#import "SCShopMallViewController.h"
#import "SCDynamicWebViewController.h"
#import "SCAboutViewController.h"
#import "GlobalVar.h"

@interface SCPersonalViewController ()<UITableViewDelegate,UITableViewDataSource,SCPersonalHeadViewProtocol>
{
    SCPersonalHeadView *scPersonalHeadView;
    CExpandHeader *expandHeader;
}
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@end

@implementation SCPersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationViewColor:[UIColor colorWithRed:0.000 green:0.722 blue:0.933 alpha:1.000]];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"News_Image"] style:UIBarButtonItemStylePlain target:self action:@selector(clickNewsBtn)];
    [self.navigationItem setRightBarButtonItems:@[rightItem]];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
        
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [self.tableView setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
        
    }
    
    Member *host = [[ZXAppStartManager defaultManager] currentHost];
    scPersonalHeadView = [[SCPersonalHeadView alloc] initWithFrame:CGRectMake(0, 0, UIScreenMainFrame.size.width, 33 * UIScreenMainFrame.size.width / 64)];
    scPersonalHeadView.delegate = self;
    if (host) {
        [scPersonalHeadView setName:@"我是口罩" WithPhone:host.mobilePhone];
    }else{
        [scPersonalHeadView setName:@"我是口罩" WithPhone:@""];
    }
    expandHeader = [CExpandHeader expandWithScrollView:self.tableView expandView:scPersonalHeadView];
}

-(void)clickNewsBtn
{
    SCNewsViewController *scNewsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"NewsViewIdentify"];
    scNewsVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:scNewsVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview delegate and datasoucre
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 0)];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 0)];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalTableViewCellIdentify"];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    UILabel *lblName = (UILabel *)[cell viewWithTag:2];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    [imageView setImage:[UIImage imageNamed:@"Personal_Mask_Image"]];
                    [lblName setText:@"我的设备"];
                }
                    break;
                case 1:
                {
                    [imageView setImage:[UIImage imageNamed:@"Personal_MyOrder_Image"]];
                    [lblName setText:@"设备商城"];
                }
                    break;
                case 2:
                {
                    [imageView setImage:[UIImage imageNamed:@"Personal_Setting_Image"]];
                    [lblName setText:@"帮助中心"];
                }
                    break;
                case 3:
                {
                    [imageView setImage:[UIImage imageNamed:@"Personal_Setting_Image"]];
                    [lblName setText:@"关于"];
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    SCMyDeviceTableViewController *scMyDeviceTableVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyDeviceTableViewIdentify"];
                    scMyDeviceTableVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:scMyDeviceTableVC animated:YES];
                }
                    break;
                case 1:
                {
                    SCShopMallViewController *scShopMallVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ShopMallViewIdentify"];
                    scShopMallVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:scShopMallVC animated:YES];
                }
                    break;
                case 2:
                {
                    SCDynamicWebViewController *scDynamicWebVC = [[SCDynamicWebViewController alloc] initWithTitle:@"常见问题" WithUrl:SC_Problem_API];
                    scDynamicWebVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:scDynamicWebVC animated:YES];
                }
                    break;
                case 3:
                {
                    SCAboutViewController *scAboutVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutViewIdentify"];
                    scAboutVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:scAboutVC animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma -mark SCPersonalHeadViewProtocol
-(void)loginout
{
    [[ZXAppStartManager defaultManager] loginOut];
}
@end
