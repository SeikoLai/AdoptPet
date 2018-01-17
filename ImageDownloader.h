//
//  ImageDownloader.h
//  AdoptPetInTaipei
//
//  Created by Sam Lai on 16/01/2018.
//  Copyright © 2018 SSL. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Animal;

@interface ImageDownloader : NSObject
@property (nonatomic, strong) Animal *animal;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;
@end
