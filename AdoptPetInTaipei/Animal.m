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
//animal_kind; // 動物的類型 [貓 | 狗 | 鳥 ..]
//animal_sex; // 動物性別 [M | F | N](公、母、未輸入)
//animal_bodytype; // 動物體型 [MINI | SMALL | MEDIUM | BIG](迷你、小 型、中型、大型)
//animal_colour; // 動物毛色 [黑色 | 灰色 | 白色.. ]
//animal_age; // 動物年紀 [CHILD | ADULT](幼年、成年)
//animal_sterilization; // 是否絕育 [T | F | N](是、否、未輸入)
//animal_bacterin; // 是否施打狂犬病疫苗 [T | F | N](是、否、未輸入)
//animal_foundplace; // 動物尋獲地
//animal_title; // 動物網頁標題
//animal_status; // 動物狀態 [NONE | OPEN | ADOPTED | OTHER | DEAD] (未公告、開放認養、已認養、其他、死亡)
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
static NSString * const kAnimalId = @"animal_id";

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
        _name = info[kAnimalTitle];
        _sex = [info[kAnimalSex] isEqualToString:@"M"] ? @"男生" : ([info[kAnimalSex] isEqualToString:@"F"] ? @"女生" : @"無資料");
        _type = info[kAnimalKind];
        _build = [self bodyFromTypeString:info[kAnimalBodytype]];
        _age = [info[kAnimalAge] isEqualToString:@"CHILD"] ? @"幼年" : @"成年";
        _variety = info[kVariety];
        _reason = info[kReason];
        _acceptNum = info[kAnimalId];
        _chipNum = info[kAnimalId];
        _sterilization = [info[kAnimalSterilization] isEqualToString:@"T"];
        _hairType = info[kAnimalColour];
        _note = info[kAnimalRemark];
        _resettlement = info[kShelterAddress];
        _phone = info[kShelterTel];
        _email = info[kEmail];
        _childreAnlong = info[kChildreAnlong];
        _animalAnlong = info[kAnimalAnlong];
        _imageName = info[kAlbumFile];
        _bodyweight = [self bodyweightFromTypeString:info[kAnimalBodytype]];
        _acceptDate = [NSString stringWithFormat:@"%@年%@月%@日", [info[kAnimalOpendate] substringWithRange:NSMakeRange(0, 4)], [info[kAnimalOpendate] substringWithRange:NSMakeRange(5, 2)], [info[kAnimalOpendate] substringWithRange:NSMakeRange(8, 2)]];
    }
    return self;
}

- (NSString *)bodyweightFromTypeString:(NSString *)typeString
{
    NSString *bodyweight = nil;
    if ([typeString isEqualToString:@"MINI"]) {
        bodyweight = @"3公斤以下";
    }
    else if ([typeString isEqualToString:@"SMALL"]) {
        bodyweight = @"3至9公斤";
    }
    else if ([typeString isEqualToString:@"MEDIUM"]) {
        bodyweight = @"9至23公斤";
    }
    else if ([typeString isEqualToString:@"BIG"]) {
        bodyweight = @"23公斤以上";
    }
    return bodyweight;
}

- (NSString *)bodyFromTypeString:(NSString *)typeString
{
    NSString *body = nil;
    if ([typeString isEqualToString:@"MINI"]) {
        body = @"迷你";
    }
    else if ([typeString isEqualToString:@"SMALL"]) {
        body = @"小型";
    }
    else if ([typeString isEqualToString:@"MEDIUM"]) {
        body = @"中型";
    }
    else if ([typeString isEqualToString:@"BIG"]) {
        body = @"大型";
    }
    return body;
}

- (NSArray<NSDictionary *> *)properties
{
    return @[@{@"性別":_sex}, @{@"年紀":_age}, /*@{@"品種":_variety},*/ @{@"絕育":_sterilization?@"是":@"否"}, @{@"體型":_build}, @{@"體重":_bodyweight}, /*@{@"進所原因":_reason},*/ @{@"晶片號碼":_chipNum}, @{@"毛色":_hairType}, /*@{@"孩童相處":_childreAnlong}, @{@"動物相處":_animalAnlong},*/ @{@"收容編號":_acceptNum}, @{@"收容單位":_resettlement}, @{@"收容日期":_acceptDate}, @{@"聯絡電話":_phone}, /*@{@"聯絡信箱":_email},*/ @{@"備註":_note}];
}

- (BOOL)matchByToken:(NSString *)token
{
    BOOL match = [self.name containsString:token] || [self.sex containsString:token] || ([self.type containsString:token] || [self matchTypeByToken:token]) || [self.build containsString:token] || [self.age containsString:token] || [self.variety containsString:token] || [self.reason containsString:token] || [self.acceptNum containsString:token] || [self.chipNum containsString:token] || ([token isEqualToString:@"絕育"] && self.sterilization) || ([token isEqualToString:@"未絕育"] && !self.sterilization) || [self.phone containsString:token] || [self matchWeightByToken:token] || ([self matchCountyByToken:token].count > 0 && [self.resettlement containsString:token]) || ([self compareHairColorWithToken:token].length > 0 && [self.hairType containsString:token]);
    
    return match;
}

- (BOOL)matchTypeByToken:(NSString *)token
{
    if (([token containsString:@"犬"] || [token containsString:@"狗"] || [token containsString:@"汪"] || ([token isEqualToString:@"汪星人"] || [@"汪星人" containsString:token]) || [token isEqualToString:@"汪汪"] || [token isEqualToString:@"狗狗"]) && ([self.type isEqualToString:@"犬"] || [self.type isEqualToString:@"狗"])) {
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

- (NSArray *)hairColors
{
    return @[@"紅", @"橙", @"黃", @"綠", @"藍", @"靛", @"紫", @"黑", @"白", @"灰", @"咖啡", @"棕", @"米", @"花"];
}

- (NSString *)compareHairColorWithToken:(NSString *)token
{
    NSArray *colors = [self hairColors];
    NSString *hairColor = nil;
    for (NSString *color in colors) {
        if ([token containsString:color]) {
            hairColor = color;
            break;
        }
    }
    return hairColor;
}

- (NSDictionary *)matchCountyByToken:(NSString *)token
{
    NSDictionary *countiesInfos = [self postalCode];
    NSDictionary *countyInfo = nil;
    for (NSString *key in [countiesInfos allKeys]) {
        if ([key containsString:token]) {
            countyInfo = countiesInfos[key];
            break;
        }
    }
    return countyInfo;
}

- (BOOL)matchWeightByToken:(NSString *)token
{
    NSInteger weight = [token integerValue];
    if (weight > 0) {
        if (weight < 3 && [self.bodyweight isEqualToString:@"3公斤以下"]) {
        }
        else if (weight > 3 && weight < 9 && [self.bodyweight isEqualToString:@"3至9公斤"]) {
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

- (NSDictionary *)postalCode
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"postalCode" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:filePath];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

@end
