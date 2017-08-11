//
//  APTMailViewController.h
//  AdoptPetInTaipei
//
//  Created by Sam on 11/07/2017.
//  Copyright © 2017 Hiiir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Animal.h"

@interface APTMailViewController : UIViewController

@property (nonatomic, strong) Animal *animal;
- (IBAction)sendEmail:(id)sender;
@end
