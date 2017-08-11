//
//  APTMapHelper.m
//  AdoptPetInTaipei
//
//  Created by Sam on 21/07/2017.
//  Copyright © 2017 Hiiir. All rights reserved.
//

#import "APTMapHelper.h"
#import "Map.h"

@implementation APTMapHelper

+ (instancetype)singleton
{
    static APTMapHelper *singleton;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        singleton = [[APTMapHelper alloc] init];
    });
    return singleton;
}

+ (void)fetchLocationByPlaceName:(NSString *)placeName withCompleteHandler:(void(^)(Map *map, NSError *error))completeHandler
{
    return [[APTMapHelper singleton] fetchLocationByPlaceName:placeName withCompleteHandler:completeHandler];
}

- (void)fetchLocationByPlaceName:(NSString *)placeName withCompleteHandler:(void(^)(Map *map, NSError *error))completeHandler
{
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/textsearch/json?query=%@&key=%@", placeName, PlacesAPIWebServicekey];
    urlString = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data.length && error == nil) {
            NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            BOOL status = info && info[@"status"] && [info[@"status"] isEqualToString:@"OK"];
            if (status) {
                NSDictionary *resultsInfo = ((NSArray *)info[@"results"])[0];
                completeHandler([Map mapsWithInfo:resultsInfo], nil);
            }
        }
        else {
            completeHandler(nil, error);
        }
    }];
    [task resume];
}

@end
