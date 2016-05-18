//
//  SCHomeCategoryTableViewController.m
//  IntelligentMask
//
//  Created by baolicheng on 16/3/14.
//  Copyright © 2016年 RenRenFenQi. All rights reserved.
//

#import "SCHomeCategoryTableViewController.h"
#import <PNChart/PNChart.h>
#import "SCHomeCategoryViewModel.h"

#define LineChartHeight 200.0f

@interface SCHomeCategoryTableViewController ()
{
    NSArray *cellArr;
    
    NSArray *xLabelValues;
    NSArray *yLabelValues;
}
@property(nonatomic, strong) SCHomeCategoryViewModel *homeCategoryViewModel;
@property(nonatomic, strong) PNLineChart *lineChart;
@end

@implementation SCHomeCategoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    self.homeCategoryViewModel = [[SCHomeCategoryViewModel alloc] init];
    xLabelValues = [NSArray array];
    yLabelValues = [NSArray array];
    cellArr = @[@"IndexCellIdentify",@"IndexWarnCellIdentify",@"StoryDescCellIdentify",@"StoryIndexChartCellIdentify",@"RecoderDurationCellIdentify"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setAirIndex:(NSNumber *)index
{
    [self.homeCategoryViewModel setAirIndex:index];
}

-(void)setXLabelValues:(NSArray *)xArr WithYLabelValues:(NSArray *)yArr
{
    xLabelValues = [NSArray arrayWithArray:xArr];
    yLabelValues = [NSArray arrayWithArray:yArr];
    
    PNLineChartData *data = [PNLineChartData new];
    data.color = PNBrown;
    data.inflexionPointStyle = PNLineChartPointStyleCircle;
    data.showPointLabel = YES;
    [data setPointLabelFont:[UIFont systemFontOfSize:15.0f]];
    [data setPointLabelFormat:@"%.2f"];
    data.itemCount = xLabelValues.count;
    data.getData = ^(NSUInteger index){
        CGFloat yValue = [yLabelValues[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    if (!self.lineChart) {
        self.lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(0, 0, UIScreenMainFrame.size.width, LineChartHeight)];
        [self.lineChart setBackgroundColor:[UIColor clearColor]];
        self.lineChart.displayAnimated = YES;
        [self.lineChart setXLabels:xLabelValues];
        [self.lineChart setShowCoordinateAxis:YES];
        
        self.lineChart.chartData = @[data];
        [self.lineChart strokeChart];
    }else{
        [self.lineChart setXLabels:xLabelValues];
        [self.lineChart updateChartData:@[data]];
    }
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return cellArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            return UIScreenMainFrame.size.height - 40.0f - 44.0f - 48.0f - 5.0f;
            break;
        case 1:
            return 40.0f;
            break;
        case 2:
            return 33.0f;
            break;
        case 3:
            return LineChartHeight + 20.0f;
            break;
        case 4:
            return 37.0f;
            break;
        default:
            break;
    }
    return 0.1f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identify = [cellArr objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    [cell setBackgroundColor:[UIColor clearColor]];
    [cell.contentView setBackgroundColor:[UIColor clearColor]];
    switch (indexPath.row) {
        case 0:
        {
            UILabel *indexLabel = [cell viewWithTag:1];
            [RACObserve(self.homeCategoryViewModel, airIndex) subscribeNext:^(id x) {
                [indexLabel setText:[NSString stringWithFormat:@"%@",x]];
            }];
            UILabel *descLable = [cell viewWithTag:2];
            [RACObserve(self.homeCategoryViewModel, airIndex) subscribeNext:^(id x) {
                NSDictionary *dic = [self.homeCategoryViewModel airQualityDictionary];
                if (dic) {
                    [descLable setText:[dic objectForKey:@"desc"]];
                    [descLable setBackgroundColor:[dic objectForKey:@"color"]];
                }
            }];
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 3:
        {
            if (self.lineChart) {
                if (![cell.subviews containsObject:self.lineChart]) {
                    [cell addSubview:self.lineChart];
                    [self.lineChart setCenter:CGPointMake(UIScreenMainFrame.size.width / 2, LineChartHeight / 2 + 10.0f)];
                }
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
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
