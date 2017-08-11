//
//  NoteViewController.m
//  AdoptPetInTaipei
//
//  Created by Sam on 09/07/2017.
//  Copyright © 2017 Hiiir. All rights reserved.
//

#import "NoteViewController.h"

@interface NoteViewController ()

@property (strong, nonatomic) IBOutlet UILabel *noteLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation NoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"備註";
    
    self.noteLabel.text = self.note;
    self.imageView.image = self.image;
    
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2.0;
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.borderWidth = 1.0f;
    self.imageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
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

@end
