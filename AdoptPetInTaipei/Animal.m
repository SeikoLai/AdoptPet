//
//  Animal.m
//  AdoptPetInTaipei
//
//  Created by Sam on 03/07/2017.
//  Copyright © 2017 Hiiir. All rights reserved.
//

#import "Animal.h"

//animal_id; // 動物的流水編號
//animal_subid; // 動物的區域編號
//animal_area_pkid; // 動物所屬縣市代碼
//animal_shelter_pkid; // 動物所屬收容所代碼
//animal_place; // 動物的實際所在地
//animal_kind; // 動物的類型
//animal_sex; // 動物性別
//animal_bodytype; // 動物體型
//animal_colour; // 動物毛色
//animal_age; // 動物年紀
//animal_sterilization; // 是否絕育
//animal_bacterin; // 是否施打狂犬病疫苗
//animal_foundplace; // 動物尋獲地
//animal_title; // 動物網頁標題
//animal_status; // 動物狀態
//animal_remark; // 資料備註
//animal_caption; // 其他說明
//animal_opendate; // 開放認養時間(起)
//animal_closeddate; // 開放認養時間(迄)
//animal_update; // 動物資料異動時間
//animal_createtime; // 動物資料建立時間
//shelter_name; // 動物所屬收容所名稱
//album_name; // 圖片名稱(原始名稱)
//album_file; // 圖片名稱
//album_base64; // 圖片base64編碼
//album_update;
//cDate; // 異動時間
//shelter_address; // 地址
//shelter_tel; // 聯絡電話
static NSString * const kName = @"Name";
static NSString * const kImageName = @"ImageName";
static NSString * const kVariety = @"Variety";
static NSString * const kChipNum = @"ChipNum";
static NSString * const kId = @"_id";
static NSString * const kSex = @"Sex";
static NSString * const kIsSterilization = @"IsSterilization";
static NSString * const kType = @"Type";
static NSString * const kHairType = @"HairType";
static NSString * const kAnimalAnlong = @"AnimalAnlong";
static NSString * const kBuild = @"Build";
static NSString * const kAcceptNum = @"AcceptNum";
static NSString * const kChildreAnlong = @"ChildreAnlong";
static NSString * const kReason = @"Reason";
static NSString * const kEmail = @"Email";
static NSString * const kNote = @"Note";
static NSString * const kResettlement = @"Resettlement";
static NSString * const kPhone = @"Phone";
static NSString * const kBodyweight = @"Bodyweight";
static NSString * const kAge = @"Age";
static NSString * const kAnimalTitle = @"animal_title";
static NSString * const kAlbumFile = @"album_file";
static NSString * const kAnimalKind = @"animal_kind";
static NSString * const kAnimalBodytype = @"animal_bodytype";
static NSString * const kAnimalSex = @"animal_sex";
static NSString * const kAnimalSterilization = @"animal_sterilization";
static NSString * const kAnimalColour = @"animal_colour";
static NSString * const kAnimalShelterPkid = @"animal_shelter_pkid";
static NSString * const kAnimalPlace = @"animal_place";
static NSString * const kAnimalRemark = @"animal_remark";
static NSString * const kAnimalAge = @"animal_age";
static NSString * const kAnimalOpendate = @"animal_opendate";
static NSString * const kShelterAddress = @"shelter_address";
static NSString * const kShelterTel = @"shelter_tel";

@implementation Animal

- (void)encodeWithCoder:(NSCoder *)encoder
{
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.sex forKey:@"sex"];
    [encoder encodeObject:self.type forKey:@"type"];
    [encoder encodeObject:self.build forKey:@"build"];
    [encoder encodeObject:self.age forKey:@"age"];
    [encoder encodeObject:self.variety forKey:@"variety"];
    [encoder encodeObject:self.reason forKey:@"reason"];
    [encoder encodeObject:self.acceptNum forKey:@"acceptNum"];
    [encoder encodeObject:self.chipNum forKey:@"chipNum"];
    [encoder encodeBool:self.sterilization forKey:@"sterilization"];
    [encoder encodeObject:self.hairType forKey:@"hairType"];
    [encoder encodeObject:self.note forKey:@"note"];
    [encoder encodeObject:self.resettlement forKey:@"resettlement"];
    [encoder encodeObject:self.phone forKey:@"phone"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.childreAnlong forKey:@"childreAnlong"];
    [encoder encodeObject:self.animalAnlong forKey:@"animalAnlong"];
    [encoder encodeObject:self.bodyweight forKey:@"bodyweight"];
    [encoder encodeObject:self.imageName forKey:@"imageName"];
    [encoder encodeObject:self.acceptDate forKey:@"acceptDate"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        //decode properties, other class vars
        self.name = [decoder decodeObjectForKey:@"name"];
        self.sex = [decoder decodeObjectForKey:@"sex"];
        self.type = [decoder decodeObjectForKey:@"type"];
        self.build = [decoder decodeObjectForKey:@"build"];
        self.age = [decoder decodeObjectForKey:@"age"];
        self.variety = [decoder decodeObjectForKey:@"variety"];
        self.reason = [decoder decodeObjectForKey:@"reason"];
        self.acceptNum = [decoder decodeObjectForKey:@"acceptNum"];
        self.chipNum = [decoder decodeObjectForKey:@"chipNum"];
        self.sterilization = [decoder decodeBoolForKey:@"sterilization"];
        self.hairType = [decoder decodeObjectForKey:@"hairType"];
        self.resettlement = [decoder decodeObjectForKey:@"resettlement"];
        self.phone = [decoder decodeObjectForKey:@"phone"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.childreAnlong = [decoder decodeObjectForKey:@"childreAnlong"];
        self.animalAnlong = [decoder decodeObjectForKey:@"animalAnlong"];
        self.bodyweight = [decoder decodeObjectForKey:@"bodyweight"];
        self.imageName = [decoder decodeObjectForKey:@"imageName"];
        self.acceptDate = [decoder decodeObjectForKey:@"acceptDate"];
    }
    return self;
}

+ (instancetype)animalWithInfo:(NSDictionary *)info
{
    return [[Animal alloc] initWithInfo:info];
}
//1.幼齡：3個月齡以下，年輕：3個月齡至1年，成年：1至7歲，老年：7歲以上
//2.體型：幼：幼齡，小型：9公斤以下，中型：9至23公斤，大型：23公斤以上

- (instancetype)initWithInfo:(NSDictionary *)info
{
    self = [super init];
    if (self) {
        _name = info[kName];
        _sex = [info[kSex] isEqualToString:@"雌"] ? @"女生" : @"男生";
        _type = info[kType];
        _build = info[kBuild];
        _age = [info[kAge] isEqualToString:@"幼齡"] ? @"3個月以下" : [info[kAge] isEqualToString:@"年輕"] ? @"3個月至1歲" : [info[kAge] isEqualToString:@"成年"] ? @"1至7歲" : @"7歲以上";
        _variety = info[kVariety];
        _reason = info[kReason];
        _acceptNum = info[kAcceptNum];
        _chipNum = info[kChipNum];
        _sterilization = ![info[kIsSterilization] isEqualToString:@"未絕育"];
        _hairType = info[kHairType];
        _note = info[kNote];
        _resettlement = [info[kResettlement] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]][0];
        _resettlement = [_resettlement componentsSeparatedByString:@"0"][0];
        _phone = info[kPhone];
        _email = info[kEmail];
        _childreAnlong = info[kChildreAnlong];
        _animalAnlong = info[kAnimalAnlong];
        _bodyweight = ((NSString *)info[kBodyweight]).length ? info[kBodyweight] : [info[kBuild] isEqualToString:@"幼"] ? @"9公斤以下"  : [info[kBuild] isEqualToString:@"小"] ? @"9公斤以下" : [info[kBuild] isEqualToString:@"中"] ? @"9至23公斤" : @"23公斤以上";
        _imageName = info[kImageName];
        
        NSString *dateString = [NSString stringWithFormat:@"%ld", ([[_acceptNum substringWithRange:NSMakeRange(0, 7)] integerValue] + 19110000)];
        if (dateString.length == 8) {
            _acceptDate = [NSString stringWithFormat:@"%@年%@月%@日", [dateString substringWithRange:NSMakeRange(0, 4)], [dateString substringWithRange:NSMakeRange(4, 2)], [dateString substringWithRange:NSMakeRange(6, 2)]];
        }
    }
    return self;
}

- (NSArray<NSDictionary *> *)properties
{
    return @[@{@"性別":_sex}, @{@"年紀":_age}, @{@"品種":_variety}, @{@"絕育":_sterilization?@"是":@"否"}, @{@"體型":_build}, @{@"體重":_bodyweight}, @{@"進所原因":_reason}, @{@"晶片號碼":_chipNum}, @{@"毛色":_hairType}, @{@"孩童相處":_childreAnlong}, @{@"動物相處":_animalAnlong}, @{@"收容編號":_acceptNum}, @{@"收容單位":_resettlement}, @{@"收容日期":_acceptDate}, @{@"聯絡電話":_phone}, @{@"聯絡信箱":_email}, @{@"備註":_note}];
}

- (BOOL)matchByToken:(NSString *)token
{
    BOOL match = [self.name containsString:token] || [self.sex containsString:token] || ([self.type containsString:token] || [self matchTypeByToken:token]) || [self.build containsString:token] || [self.age containsString:token] || [self.variety containsString:token] || [self.reason containsString:token] || [self.acceptNum containsString:token] || [self.chipNum containsString:token] || ([token isEqualToString:@"絕育"] && self.sterilization) || ([token isEqualToString:@"未絕育"] && !self.sterilization) || ([self.hairType containsString:token] || [token containsString:self.hairType]) || [self.resettlement containsString:token] || [self.phone containsString:token] || [self.email containsString:token] || [self.childreAnlong containsString:token] || [self.animalAnlong containsString:token] || [self matchWeightByToken:token];
    return match;
}

- (BOOL)matchTypeByToken:(NSString *)token
{
    if (([token containsString:@"犬"] || [token containsString:@"狗"] || [token containsString:@"汪"] || ([token isEqualToString:@"汪星人"] || [@"汪星人" containsString:token]) || [token isEqualToString:@"汪汪"] || [token isEqualToString:@"狗狗"]) && [self.type isEqualToString:@"犬"]) {
        return YES;
    }
    else if (([token containsString:@"貓"] || [token containsString:@"喵"] || [token isEqualToString:@"喵喵"] || ([token containsString:@"喵星人"] || [@"喵星人" containsString:token]) || [token isEqualToString:@"貓貓"] || [token isEqualToString:@"貓咪"]) && [self.type isEqualToString:@"貓"]) {
        return YES;
    }
    else if (([token containsString:@"寵物兔"] || [token containsString:@"兔"] || [token containsString:@"兔子"] || [token isEqualToString:@"兔兔"]) && ([self.type isEqualToString:@"寵物兔"] || [self.variety isEqualToString:@"寵物兔"])) {
        return YES;
    }
    return NO;
}

- (BOOL)matchWeightByToken:(NSString *)token
{
    NSInteger weight = [token integerValue];
    if (weight > 0) {
        if (weight < 9 && [self.bodyweight isEqualToString:@"9公斤以下"]) {
            return YES;
        }
        else if (weight >= 9 && weight <= 23 && [self.bodyweight isEqualToString:@"9至23公斤"]) {
            return YES;
        }
        else if (weight > 23 && [self.bodyweight isEqualToString:@"23公斤以上"]) {
            return YES;
        }
        else if (weight == [self.bodyweight integerValue]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)matchByTokens:(NSArray<NSString *> *)tokens
{
    NSInteger completeMatchSize = 0;
    for (NSString *token in tokens) {
        if ([self matchByToken:token]) {
            completeMatchSize++;
        }
    }
    if (completeMatchSize == tokens.count) {
        return YES;
    }
    return NO;
}

@end
