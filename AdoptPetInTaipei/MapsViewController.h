//
//  MapsViewController.h
//  AdoptPetInTaipei
//
//  Created by Sam on 12/07/2017.
//  Copyright © 2017 Hiiir. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "Map.h"
@class Animal;

@interface MapsViewController : UIViewController

@property (nonatomic, strong) Animal *animal;
@property (nonatomic, strong) Map *map;


@end
