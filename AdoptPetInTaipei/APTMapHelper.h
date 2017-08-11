//
//  APTMapHelper.h
//  AdoptPetInTaipei
//
//  Created by Sam on 21/07/2017.
//  Copyright © 2017 Hiiir. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Map;

@interface APTMapHelper : NSObject

+ (instancetype)singleton;
+ (void)fetchLocationByPlaceName:(NSString *)placeName withCompleteHandler:(void(^)(Map *map, NSError *error))completeHandler;

@end
