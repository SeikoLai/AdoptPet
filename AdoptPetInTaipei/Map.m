//
//  Map.m
//  AdoptPetInTaipei
//
//  Created by Sam on 12/07/2017.
//  Copyright © 2017 Hiiir. All rights reserved.
//

#import "Map.h"

@implementation Map
+ (instancetype)mapsWithInfo:(NSDictionary *)info
{
    return [[Map alloc] initWithInfo:info];
}
- (instancetype)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        self.name = info[@"name"];
        self.opening_hours = info[@"opening_hours"];
        self.photos = info[@"photos"];
        self.Id = info[@"id"];
        self.geometry = info[@"geometry"];
        self.rating = [[info[@"rating"] description] doubleValue];
        self.reference = info[@"reference"];
        self.types = info[@"types"];
        self.place_id = info[@"place_id"];
        self.icon = info[@"icon"];
        self.formatted_address = info[@"formatted_address"];
    }
    return self;
}
@end
