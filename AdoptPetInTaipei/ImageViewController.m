//
//  ImageViewController.m
//  AdoptPetInTaipei
//
//  Created by Sam on 10/07/2017.
//  Copyright © 2017 Hiiir. All rights reserved.
//

#import "ImageViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ImageViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)dismissImageView:(id)sender;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.animal.imageName.length) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.animal.imageName]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)dismissImageView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
