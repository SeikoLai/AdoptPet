//
//  DetailViewController.m
//  AdoptPetInTaipei
//
//  Created by Sam on 06/07/2017.
//  Copyright © 2017 Hiiir. All rights reserved.
//

#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NoteViewController.h"
#import "ImageViewController.h"
#import "MapsViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "Map.h"
#import "APTMapHelper.h"

@interface DetailViewController () {
    Map *_map;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self.animal.type isEqualToString:@"犬"]) {
        self.title = self.animal.name.length ? self.animal.name : @"汪星人";
    }
    else if ([self.animal.type isEqualToString:@"貓"]) {
        self.title = self.animal.name.length ? self.animal.name : @"喵星人";
    }
    else {
        self.title = self.animal.name.length ? self.animal.name : @"可愛星人";
    }
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.animal.imageName]];
    
    [APTMapHelper fetchLocationByPlaceName:self.animal.resettlement withCompleteHandler:^(Map *map, NSError *error) {
        if (error == nil && map) {
            _map = map;
        }
    }];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(share:)];
}

- (void)share:(id)sender
{
    NSString *subjectContent = [NSString stringWithFormat:@"主人，我是%@，正在%@等待有緣人來帶我回家唷，這邊是我的自我介紹：\n%@", self.animal.name, self.animal.resettlement, self.animal.note];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[self.imageView.image, subjectContent] applicationActivities:nil];
    [activityViewController setValue:self.animal.name forKey:@"subject"];
    activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypeOpenInIBooks];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.animal properties].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.detailTextLabel.textColor = [UIColor grayColor];
    cell.userInteractionEnabled = NO;
    [((NSDictionary *)[self.animal properties][indexPath.row]) enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        cell.textLabel.text = key;
        cell.detailTextLabel.text = obj;
        if (((NSString *)obj).length && [key isEqualToString:@"備註"]) {
            NSAttributedString *attributedCaptionString = [[NSAttributedString alloc] initWithString:obj attributes:@{NSFontAttributeName: cell.detailTextLabel.font}];
            CGSize textBoundingSize = [attributedCaptionString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGRectGetWidth(cell.detailTextLabel.bounds)) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
            if (textBoundingSize.width > CGRectGetWidth(cell.detailTextLabel.bounds)) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.userInteractionEnabled = YES;
        }
        else if (((NSString *)obj).length && [key isEqualToString:@"收容單位"] && _map.name.length) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.userInteractionEnabled = YES;
        }
        else if (((NSString *)obj).length && ([key isEqualToString:@"聯絡電話"] || [key isEqualToString:@"聯絡信箱"])) {
            cell.detailTextLabel.textColor = [UIColor colorWithRed:5.0f/255.0f green:122.0f/255.0f blue:251.0f/255.0f alpha:1.0f];
            cell.userInteractionEnabled = YES;
        }
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (((NSString *)[self.animal properties][indexPath.row][@"聯絡電話"]).length) {
        [self call:[self.animal properties][indexPath.row][@"聯絡電話"]];
    }
    else if (((NSString *)[self.animal properties][indexPath.row][@"聯絡信箱"]).length) {
        [super sendEmail:[self.animal properties][indexPath.row][@"聯絡信箱"]];
    }
    else if (((NSString *)[self.animal properties][indexPath.row][@"收容單位"]).length && _map.name.length) {
        MapsViewController *mapsViewController = [[MapsViewController alloc] initWithNibName:NSStringFromClass([MapsViewController class]) bundle:nil];
        mapsViewController.animal = self.animal;
        mapsViewController.map = _map;
        [self.navigationController pushViewController:mapsViewController animated:YES];
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 44.0f;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[self.animal properties].count-1 inSection:0]].frame];
    UIButton *adoptButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [adoptButton setTitle:@"認養" forState:UIControlStateNormal];
    adoptButton.titleLabel.textColor = [UIColor whiteColor];
    adoptButton.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    adoptButton.backgroundColor = [UIColor colorWithRed:74.0f/255.0f green:74.0f/255.0f blue:74.0f/255.0f alpha:1.0f];
    adoptButton.layer.cornerRadius = 3.0f;
    CGRect frame = ((UITableViewCell *)[tableView visibleCells].lastObject).bounds;
    frame.origin.x += 10.0f;
    frame.origin.y += 5.0f;
    frame.size.width -= 20.0f;
    frame.size.height -= 10.0f;
    adoptButton.frame = frame;
    [adoptButton addTarget:self action:@selector(sendEmail:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:adoptButton];
    return view;
}

#pragma mark - Navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender
{
    if (!([identifier isEqualToString:@"ImageViewController"] || ([((UITableViewCell *)sender).textLabel.text isEqualToString:@"備註"] && ((UITableViewCell *)sender).accessoryType == UITableViewCellAccessoryDisclosureIndicator))) {
        return NO;
    }
    return YES;
}
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"NoteViewController"]) {
        ((NoteViewController *)segue.destinationViewController).note = self.animal.note;
        ((NoteViewController *)segue.destinationViewController).image = self.imageView.image;
    }
    else if ([segue.identifier isEqualToString:@"ImageViewController"]) {
        ((ImageViewController *)segue.destinationViewController).animal = self.animal;
    }
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

@end
