//
//  APTMailViewController.m
//  AdoptPetInTaipei
//
//  Created by Sam on 11/07/2017.
//  Copyright © 2017 Hiiir. All rights reserved.
//

#import "APTMailViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "DetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface APTMailViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation APTMailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL)canSendMailForDate:(NSDate *)date
{
    BOOL canSend = NO;
    NSTimeInterval timeInterval = date.timeIntervalSinceNow;
    long seconds = lroundf(timeInterval);
    int hour = (int)seconds / 3600;
    if (labs(hour) < 24) {
        canSend = YES;
    }
    return canSend;
}

- (IBAction)sendEmail:(id)sender {
    // From within your active view controller
    if ([self canSendMailForDate:[[NSUserDefaults standardUserDefaults] valueForKey:@"LastAdoptDate"]]) {
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
            mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
            [mailCont setSubject:@"動物認養申請"];
            [mailCont setToRecipients:[NSArray arrayWithObject:self.animal.email]];
            [mailCont setMessageBody:@"您的真實姓名:\n聯絡電話:\n常用email:\n我想認養:\n認養原因:\n居住城市:\n我的家庭成員:\n家中是否有其他寵物:\n請簡單自我介紹:" isHTML:NO];
            
            [self presentViewController:mailCont animated:YES completion:nil];
        }
    }
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"非常抱歉" message:@"您今天已經申請過領養，請使用分享功能讓更多朋友知道這邊有很多需要被愛的寵物唷，謝謝。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *share = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self share:nil];
        }];
        [alertController addAction:share];
        UIAlertAction *sure = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:sure];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    if (result == MFMailComposeResultSent) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"LastAdoptDate"];
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)share:(id)sender
{
    NSString *subjectContent = [NSString stringWithFormat:@"主人，我是%@，正在%@等待有緣人來帶我回家唷，這邊是我的自我介紹：\n%@", self.animal.name, self.animal.resettlement, self.animal.note];
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.animal.imageName]];
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[imageView.image, subjectContent] applicationActivities:nil];
    [activityViewController setValue:self.animal.name forKey:@"subject"];
    activityViewController.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeAddToReadingList, UIActivityTypeAirDrop, UIActivityTypeOpenInIBooks];
    [self presentViewController:activityViewController animated:YES completion:nil];
}

@end
