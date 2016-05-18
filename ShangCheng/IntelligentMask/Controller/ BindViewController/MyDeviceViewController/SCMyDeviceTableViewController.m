//
//  SCMyDeviceTableViewController.m
//  IntelligentMask
//
//  Created by baolicheng on 16/3/23.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCMyDeviceTableViewController.h"
#import "SCMyDeviceViewModel.h"
#import "SCSearchBluetoothViewController.h"

@interface SCMyDeviceTableViewController ()
{
    NSArray *deviceArray;
}
@property(nonatomic, strong) SCMyDeviceViewModel *myDeviceViewModel;
@end

@implementation SCMyDeviceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myDeviceViewModel = [[SCMyDeviceViewModel alloc] init];
    [[self.myDeviceViewModel.requestMyDeviceSignal subscribeNext:^(id x) {
        if (x != nil) {
            deviceArray = [NSArray arrayWithArray:x];
        }else{
            deviceArray = [NSArray array];
        }
        [self.tableView reloadData];
    } error:^(NSError *error) {
        
    } completed:^{
        
    }] dispose];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    self.tableView.tableFooterView = [UIView new];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setTitle:@"我的设备"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    if (deviceArray.count == 0) {
        return 1;
    }
    return deviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if (deviceArray.count == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"MyDeviceCellIdentify" forIndexPath:indexPath];
    }else{
        
    }
    // Configure the cell...
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (deviceArray.count == 0) {
        switch (indexPath.row) {
            case 0:
            {
                SCSearchBluetoothViewController *scSearchBluetoothVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchBluetoothViewIdentify"];
                [self.navigationController pushViewController:scSearchBluetoothVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
