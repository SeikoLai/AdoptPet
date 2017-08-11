//
//  Map.h
//  AdoptPetInTaipei
//
//  Created by Sam on 12/07/2017.
//  Copyright © 2017 Hiiir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Map : NSObject

@property (nonatomic, assign) BOOL status;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSDictionary *opening_hours;
@property (nonatomic, copy) NSArray *photos;
@property (nonatomic, copy) NSString *Id;
@property (nonatomic, copy) NSDictionary *geometry;
@property (nonatomic, assign) double rating;
@property (nonatomic, copy) NSString *reference;
@property (nonatomic, copy) NSArray *types;
@property (nonatomic, copy) NSString *place_id;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *formatted_address;

+ (instancetype)mapsWithInfo:(NSDictionary *)info;

@end
