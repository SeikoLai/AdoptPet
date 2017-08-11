//
//  APTInformationViewController.m
//  AdoptPetInTaipei
//
//  Created by Sam on 13/07/2017.
//  Copyright © 2017 Hiiir. All rights reserved.
//

#import "APTInformationViewController.h"
#import "APTAdoptInformationViewController.h"

@interface APTInformationViewController () {
    NSArray *_informationList;
}

@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;

@end

@implementation APTInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"information" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    _informationList = json[@"data"];
    self.title = @"知識專區";
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _informationList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    cell.textLabel.text = _informationList[indexPath.row][@"title"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIViewController *controller = [[APTAdoptInformationViewController alloc] init];
    controller.title = _informationList[indexPath.row][@"title"];
    ((APTAdoptInformationViewController *)controller).informatonInfo = _informationList[indexPath.row][@"content"];
    if ([_informationList[indexPath.row][@"title"] isEqualToString:@"寵物登記"]) {
        ((APTAdoptInformationViewController *)controller).navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"登記單位" style:UIBarButtonItemStylePlain target:controller action:NSSelectorFromString(@"openEnrollmentPDF:")];
    }
    else if ([_informationList[indexPath.row][@"title"] isEqualToString:@"絕育補助"]) {
        ((APTAdoptInformationViewController *)controller).navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"補助申請書" style:UIBarButtonItemStylePlain target:controller action:NSSelectorFromString(@"openLigationApplicationPDF:")];
    }
    else if ([_informationList[indexPath.row][@"title"] isEqualToString:@"寵物屍體焚化"]) {
        ((APTAdoptInformationViewController *)controller).navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"焚化申請書" style:UIBarButtonItemStylePlain target:controller action:NSSelectorFromString(@"openIncinerationApplicationPDF:")];
    }
    if (controller) {
        [self.navigationController pushViewController:controller animated:YES];
    }
}

@end
