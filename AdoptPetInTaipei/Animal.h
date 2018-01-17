//
//  Animal.h
//  AdoptPetInTaipei
//
//  Created by Sam on 03/07/2017.
//  Copyright © 2017 Hiiir. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Animal : NSObject

@property (nonatomic, copy) NSString *name; // (名稱)
@property (nonatomic, copy) NSString *sex; // (性別)
@property (nonatomic, copy) NSString *type; // (動物種類)
@property (nonatomic, copy) NSString *build; //(體型)
@property (nonatomic, copy) NSString *age; // (年齡)
@property (nonatomic, copy) NSString *variety; // (品種)
@property (nonatomic, copy) NSString *reason; // (進所原因)
@property (nonatomic, copy) NSString *acceptNum; // (收容編號)
@property (nonatomic, copy) NSString *chipNum; // (晶片號碼)
@property (nonatomic, assign, getter=isSterilization) BOOL sterilization; // (絕育否)
@property (nonatomic, copy) NSString *hairType; // (毛色)
@property (nonatomic, copy) NSString *note; // (描述)
@property (nonatomic, copy) NSString *resettlement; // (位置)
@property (nonatomic, copy) NSString *phone;// (聯絡電話)
@property (nonatomic, copy) NSString *email; //(聯絡email)
@property (nonatomic, copy) NSString *childreAnlong; // (可否與其他孩童相處)
@property (nonatomic, copy) NSString *animalAnlong; // (可否與其他動物相處)
@property (nonatomic, copy) NSString *bodyweight;// (體重)
@property (nonatomic, copy) NSString *imageName; //(圖片)
@property (nonatomic, copy) NSString *acceptDate;
@property (nonatomic, strong) UIImage *image;


+ (instancetype)animalWithInfo:(NSDictionary *)info;
- (NSArray<NSDictionary *> *)properties;
- (BOOL)matchByToken:(NSString *)token;
- (BOOL)matchByTokens:(NSArray<NSString *> *)tokens;
@end
