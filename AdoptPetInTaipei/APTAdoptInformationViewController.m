//
//  APTAdoptInformationViewController.m
//  AdoptPetInTaipei
//
//  Created by Sam on 20/07/2017.
//  Copyright © 2017 Hiiir. All rights reserved.
//

#import "APTAdoptInformationViewController.h"
#import "APTMapHelper.h"
#import "MapsViewController.h"

@interface APTAdoptInformationViewController () <UIDocumentInteractionControllerDelegate> {
    NSArray *_headers;
    NSArray *_informations;
}
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@end

@implementation APTAdoptInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _headers = self.informatonInfo[@"header"];
    _informations = self.informatonInfo[@"information"];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _informations.count;
}

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _headers.count ? _headers[section] : nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)_informations[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"InformationCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InformationCell"];
    }
    cell.textLabel.text = _informations[indexPath.section][indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.userInteractionEnabled = NO;
    cell.textLabel.textColor = [UIColor blackColor];
    if ((([_headers[indexPath.section] isEqualToString:@"迎風狗運動公園"] || [_headers[indexPath.section] isEqualToString:@"華山公園狗活動區"]) && [cell.textLabel.text containsString:@"位置"]) || [_headers[indexPath.section] isEqualToString:@"受理地點"] || [_headers[indexPath.section] isEqualToString:@"地址"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.userInteractionEnabled = YES;
        cell.textLabel.textColor = [UIColor blackColor];
    }
    else if ([_informations[indexPath.section][indexPath.row] isEqualToString:@"灑葬區使用申請書"] && [_headers[indexPath.section] isEqualToString:@"遺灰處理申請文件"]) {
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        cell.userInteractionEnabled = YES;
        cell.textLabel.textColor = [UIColor colorWithRed:5.0f/255.0f green:122.0f/255.0f blue:251.0f/255.0f alpha:1.0f];
    }
    else if ([_headers[indexPath.section] containsString:@"電話"]) {
        cell.userInteractionEnabled = YES;
        cell.textLabel.textColor = [UIColor colorWithRed:5.0f/255.0f green:122.0f/255.0f blue:251.0f/255.0f alpha:1.0f];
    }

    cell.textLabel.font = [UIFont systemFontOfSize:14.0f];
    cell.textLabel.numberOfLines = 0;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:_informations[indexPath.section][indexPath.row] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]}];
    CGFloat height = [attributedString boundingRectWithSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 20.0f, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size.height + 20.0f;
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return _headers.count ? 44.0f : 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ((cell.accessoryType == UITableViewCellAccessoryDisclosureIndicator && ([_headers[indexPath.section] isEqualToString:@"迎風狗運動公園"] || [_headers[indexPath.section] isEqualToString:@"華山公園狗活動區"]))) {
        [APTMapHelper fetchLocationByPlaceName:_headers[indexPath.section] withCompleteHandler:^(Map *map, NSError *error) {
            if (map && !error) {
                MapsViewController *mapsViewController = [[MapsViewController alloc] init];
                mapsViewController.map = map;
                dispatch_async(dispatch_get_main_queue(), ^{
                   [self.navigationController pushViewController:mapsViewController animated:YES]; 
                });
            }
        }];
    }
    else if ([_headers[indexPath.section] isEqualToString:@"受理地點"] || [_headers[indexPath.section] isEqualToString:@"地址"]) {
        [APTMapHelper fetchLocationByPlaceName:_informations[indexPath.section][indexPath.row] withCompleteHandler:^(Map *map, NSError *error) {
            if (map && !error) {
                MapsViewController *mapsViewController = [[MapsViewController alloc] init];
                mapsViewController.map = map;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.navigationController pushViewController:mapsViewController animated:YES];
                });
            }
        }];
    }
    else if ([_informations[indexPath.section][indexPath.row] isEqualToString:@"灑葬區使用申請書"] && [_headers[indexPath.section] isEqualToString:@"遺灰處理申請文件"]) {
        [self openBurialApplicationPDF:nil];
    }
    else if ([_headers[indexPath.section] containsString:@"電話"]) {
        [self call:cell.textLabel.text];
    }
}

- (void)openEnrollmentPDF:(id)sender
{    
    [self presentPreviewWithURL:[[NSBundle mainBundle] URLForResource:@"登記單位" withExtension:@"pdf"]];
}

- (void)openLigationApplicationPDF:(id)sender
{
    [self presentPreviewWithURL:[[NSBundle mainBundle] URLForResource:@"絕育補助申請書" withExtension:@"pdf"]];
}

- (void)openIncinerationApplicationPDF:(id)sender
{
    [self presentPreviewWithURL:[[NSBundle mainBundle] URLForResource:@"寵物委託焚化申請書" withExtension:@"pdf"]];
}

- (void)openBurialApplicationPDF:(id)sender
{
    [self presentPreviewWithURL:[[NSBundle mainBundle] URLForResource:@"灑葬區使用申請書" withExtension:@"pdf"]];
}

- (void)presentPreviewWithURL:(NSURL *)URL
{
    self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
    [self.documentInteractionController setDelegate:self];
    [self.documentInteractionController presentPreviewAnimated:YES];
}

- (void)call:(id)sender
{
    if (((NSString *)sender).length) {
        NSString *phone = sender;
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"撥打電話", @"撥打電話") message:phone preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *callout = [UIAlertAction actionWithTitle:@"通話" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSURL *phoneNumber = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"tel:%@", phone]];
            [[UIApplication sharedApplication] openURL:phoneNumber options:@{UIApplicationOpenURLOptionUniversalLinksOnly : @YES} completionHandler:^(BOOL success) {
                if (success) {
                    
                }
            }];
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alertController addAction:callout];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - UIDocumentInteractionControllerDelegate

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

@end
