//
//  ViewController.m
//  AdoptPetInTaipei
//
//  Created by Sam on 03/07/2017.
//  Copyright © 2017 Hiiir. All rights reserved.
//

#import "ViewController.h"
#import "Animal.h"
#import "CollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DetailViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "APTCollectionReusableHeaderView.h"
#import "ImageDownloader.h"

@interface ViewController () <UISearchBarDelegate, UISearchControllerDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate>
{
    NSMutableArray *_dogs;
    NSMutableArray *_cats;
    NSMutableArray *_otherPets;
    NSMutableArray *_pets;
    APTCollectionReusableHeaderView *_headerView;
    NSMutableArray *_results;
}

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *animals;
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;

- (IBAction)selectKind:(id)sender;

@end

@implementation ViewController

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _animals = [NSMutableArray array];
        _pets = [NSMutableArray array];
        _dogs = [NSMutableArray array];
        _cats = [NSMutableArray array];
        _otherPets = [NSMutableArray array];
        _results = [NSMutableArray array];
        self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        self.searchController.searchBar.delegate = self;
        self.searchController.delegate = self;
        self.searchController.hidesNavigationBarDuringPresentation = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([CollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"Cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([APTCollectionReusableHeaderView class]) bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"APTCollectionReusableHeaderView"];
    ((UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout).sectionHeadersPinToVisibleBounds = YES;
    _imageDownloadsInProgress = [NSMutableDictionary dictionary];
    [self updateDate];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeRight:)];
    swipeRight.delegate = self;
    swipeRight.numberOfTouchesRequired = 1;
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeLeft:)];
    swipeLeft.numberOfTouchesRequired = 1;
    swipeLeft.delegate = self;
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    
    [self.collectionView addGestureRecognizer:swipeRight];
    [self.collectionView addGestureRecognizer:swipeLeft];
}

// -------------------------------------------------------------------------------
//    dealloc
//  If this view controller is going away, we need to cancel all outstanding downloads.
// -------------------------------------------------------------------------------
- (void)dealloc
{
    // terminate all pending download connections
    [self terminateAllDownloads];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self adjustmentCollectionViewLayout];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self adjustmentCollectionViewLayout];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ([self.searchController.searchBar becomeFirstResponder]) {
        [self.searchController.searchBar resignFirstResponder];
        if (self.searchController.searchBar.text.length == 0) {
            self.searchController.active = NO;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    // terminate all pending download connections
    [self terminateAllDownloads];
}

- (void)lastUpdateTimeWithCompleteHandler:(void(^)(NSDate *date))completeHandler
{
    NSURL *url = [NSURL URLWithString:DataSourceIdPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data.length && error == nil) {
            NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
            NSArray *results = info[@"result"][@"results"];
            if (info[@"result"] == nil || results == nil || results.count == 0) {
                completeHandler(nil);
            }
            else {
                NSString *dateString = results[0][@"metadata_modified"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *date = [dateFormatter dateFromString:dateString];
                completeHandler(date);
            }
        }
    }];
    [task resume];
}

- (void)updateDate
{
    id animalData = [[NSUserDefaults standardUserDefaults] objectForKey:@"Animal"];
    if ([self needUpdateSource] || ![animalData isKindOfClass:[NSArray class]] || animalData == nil) {
        [self loadData];
    }
    else {
        [self processingDataWithInfo:animalData];
    }
}

- (BOOL)needUpdateSource
{
    __block BOOL update = [[NSUserDefaults standardUserDefaults] objectForKey:@"Animal"] == nil;
    [self lastUpdateTimeWithCompleteHandler:^(NSDate *date) {
        if (date) {
            update = [[[NSDate date] laterDate:date] isEqualToDate:date];
        }
    }];
    return update;
}

- (void)loadData
{
    NSURL *url = [NSURL URLWithString:TaiwanGovDataSourcePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data.length && error == nil) {
            NSMutableArray *animalInfos = [NSMutableArray arrayWithArray:[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]];
            for (NSMutableDictionary *animalInfo in animalInfos) {
                for (NSString *key in [animalInfo allKeys]) {
                    if (animalInfo[key] && (animalInfo[key] == NULL || animalInfo[key] == nil || animalInfo[key] == [NSNull null])) {
                        animalInfo[key] = @"";
                    }
                }
            }
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Animal"];
            [[NSUserDefaults standardUserDefaults] setObject:animalInfos forKey:@"Animal"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self processingDataWithInfo:animalInfos];
        }
        else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
    [task resume];
    
}

- (void)processingDataWithInfo:(NSArray *)info
{
    if (info == nil || info.count == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"異常" message:@"非常抱歉，目前無法從台北市政府公開資料平台取得資訊，請稍後再試，謝謝。" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *close = [UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:close];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
    }
    
    NSArray *results = info;
    NSArray *dogInfos = [results filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject[@"Type"] isEqualToString:@"犬"] || [evaluatedObject[@"animal_kind"] isEqualToString:@"狗"];
    }]];
    for (NSDictionary *info in dogInfos) {
        [_dogs addObject:[Animal animalWithInfo:info]];
    }
    if (_dogs.count) {
        [_pets addObject:_dogs];
    }
    _animals = _pets[0];
    if (_animals.count) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _headerView.segmentedControl.selectedSegmentIndex = 0;
            [self.collectionView reloadData];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.searchController.hidesNavigationBarDuringPresentation = NO;
                self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
                self.searchController.dimsBackgroundDuringPresentation = NO;
                self.searchController.searchBar.placeholder = @"搜尋";
                self.navigationItem.titleView = self.searchController.searchBar;
            });
        });
    }
    NSArray *catInfos = [results filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject[@"Type"] isEqualToString:@"貓"] || [evaluatedObject[@"animal_kind"] isEqualToString:@"貓"];
    }]];
    for (NSDictionary *info in catInfos) {
        [_cats addObject:[Animal animalWithInfo:info]];
    }
    if (_cats.count) {
        [_pets addObject:_cats];
    }
    NSArray *otherInfos = [results filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject[@"Type"] isEqualToString:@"其他"] || [evaluatedObject[@"animal_kind"] isEqualToString:@"兔"] || [evaluatedObject[@"animal_kind"] isEqualToString:@"其他"];
    }]];
    for (NSDictionary *info in otherInfos) {
        [_otherPets addObject:[Animal animalWithInfo:info]];
    }
    if (_otherPets.count) {
        [_pets addObject:_otherPets];
    }
}

- (void)adjustmentCollectionViewLayout
{
    if (self.collectionView.frame.origin.y < CGRectGetMaxY(self.navigationController.navigationBar.frame)) {
        CGRect frame = self.collectionView.frame;
        frame.origin.y = CGRectGetHeight(self.navigationController.navigationBar.frame) + 10.0f;
        self.collectionView.frame = frame;
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _animals.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    Animal *animal = _animals[indexPath.item];
    if (!animal.image) {
        if (self.collectionView.dragging == NO && self.collectionView.decelerating == NO)
        {
            [self startImageDownload:animal forIndexPath:indexPath];
        }
        // if a download is deferred or in progress, return a placeholder image
        cell.imageView.image = _headerView.segmentedControl.selectedSegmentIndex == 0 ? [UIImage imageNamed:@"dog.png"] : (_headerView.segmentedControl.selectedSegmentIndex == 1 ? [UIImage imageNamed:@"cat.png"] : [UIImage imageNamed:@"rabbit.png"]);
    }
    else {
        cell.imageView.image = animal.image;
    }
    cell.layer.cornerRadius = cell.frame.size.width / 2.0;
    cell.layer.masksToBounds = YES;
    cell.layer.borderWidth = 1.0f;
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        _headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"APTCollectionReusableHeaderView" forIndexPath:indexPath];
        [_headerView.segmentedControl addTarget:self action:@selector(selectKind:) forControlEvents:UIControlEventValueChanged];
    }
    return _headerView;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"DetailViewController" sender:self];
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = (CGRectGetWidth(self.view.frame)-12.0f)/3.0f;
    CGFloat height = width;
    return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 3.0f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 3.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return _results.count  ? CGSizeZero : CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 50.0f);
}

#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar.text.length) {
        NSLinguisticTaggerOptions options = NSLinguisticTaggerOmitWhitespace | NSLinguisticTaggerOmitPunctuation;
        NSLinguisticTagger *tagger = [[NSLinguisticTagger alloc] initWithTagSchemes: [NSLinguisticTagger availableTagSchemesForLanguage:@"zh-Hant"] options:options];
        tagger.string = searchBar.text;
        NSMutableSet *tokens = [NSMutableSet set];
        [tagger enumerateTagsInRange:NSMakeRange(0, [searchBar.text length]) scheme:NSLinguisticTagSchemeTokenType options:options usingBlock:^(NSString *tag, NSRange tokenRange, NSRange sentenceRange, BOOL *stop) {
            NSString *token = [searchBar.text substringWithRange:tokenRange];
            NSLog(@"%@: %@", token, tag);
            if ([token containsString:@"台"]) {
                token = [token stringByReplacingOccurrencesOfString:@"台" withString:@"臺"];
            }
            if (token.length && ![token isEqualToString:@"的"]) {
                [tokens addObject:token];
            }
        }];
        
        NSArray *results = [[self resultSetFromLinguisticTokens:[tokens allObjects]] allObjects];
        if (results.count) {
            if (_results.count) {
                [_results removeAllObjects];
            }
            _results = [results mutableCopy];
            _animals = _results;
            [self.collectionView.collectionViewLayout invalidateLayout];
            [self.collectionView reloadData];
        }
        else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"找不到%@，換個關鍵字試試看吧", searchBar.text] preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"確定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if (searchBar) {
        [_results removeAllObjects];
        if (((NSArray *)_pets[0]).count) {
            _animals = _pets[0];
        }
        else {
            [self loadData];
        }
        _headerView.segmentedControl.selectedSegmentIndex = 0;
        [self.collectionView.collectionViewLayout invalidateLayout];
        [self.collectionView reloadData];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length == 0) {
        [self.searchController.searchBar.delegate searchBarCancelButtonClicked:self.searchController.searchBar];
    }
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"DetailViewController"]) {
        Animal *animal = _animals[((NSIndexPath *)[self.collectionView indexPathsForSelectedItems][0]).item];
        if (animal) {
            DetailViewController *destinationViewController = segue.destinationViewController;
            destinationViewController.animal = animal;
        }
    }
}

- (IBAction)selectKind:(id)sender {
    if (sender && _animals.count) {
        _animals = _pets[((UISegmentedControl *)sender).selectedSegmentIndex];
        [self.collectionView reloadData];
        self.collectionView.contentOffset = CGPointZero;
    }
}

- (NSMutableSet *)resultSetFromLinguisticTokens:(NSArray *)tokens
{
    NSMutableSet *set = [NSMutableSet set];
    for (NSArray *pets in _pets) {
        for (Animal *animal in pets) {
            if ([animal matchByTokens:tokens]) {
                [set addObject:animal];
            }
        }
    }
    return set;
}

#pragma mark - UISwipeGestureRecognizer Action
- (void)didSwipeRight:(UISwipeGestureRecognizer *)recognizer
{    
    NSUInteger currentIndex = _headerView.segmentedControl.selectedSegmentIndex;
    NSUInteger numberOfSegments = _headerView.segmentedControl.numberOfSegments;
    
    currentIndex++;
    currentIndex %= numberOfSegments;
    
    _headerView.segmentedControl.selectedSegmentIndex = currentIndex;
    [self selectKind:_headerView.segmentedControl];
}

- (void)didSwipeLeft:(UISwipeGestureRecognizer *)recognizer
{
    NSUInteger currentIndex = _headerView.segmentedControl.selectedSegmentIndex;
    NSUInteger numberOfSegments = _headerView.segmentedControl.numberOfSegments;
    
    currentIndex += numberOfSegments;
    currentIndex--;
    currentIndex %= numberOfSegments;
    
    _headerView.segmentedControl.selectedSegmentIndex = currentIndex;
    [self selectKind:_headerView.segmentedControl];
}

// -------------------------------------------------------------------------------
//    terminateAllDownloads
// -------------------------------------------------------------------------------
- (void)terminateAllDownloads
{
    // terminate all pending download connections
    NSArray *allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:NSSelectorFromString(@"cancelDownload")];
    
    [self.imageDownloadsInProgress removeAllObjects];
}

#pragma mark - Table cell image support

// -------------------------------------------------------------------------------
//    startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startImageDownload:(Animal *)animal forIndexPath:(NSIndexPath *)indexPath
{
    ImageDownloader *imageDownloader = (self.imageDownloadsInProgress)[indexPath];
    if (imageDownloader == nil)
    {
        imageDownloader = [[ImageDownloader alloc] init];
        imageDownloader.animal = animal;
        [imageDownloader setCompletionHandler:^{
            
            CollectionViewCell *cell = (CollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
            
            // Display the newly loaded image
            cell.imageView.image = animal.image;
            
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        (self.imageDownloadsInProgress)[indexPath] = imageDownloader;
        [imageDownloader startDownload];
    }
}

// -------------------------------------------------------------------------------
//    loadImagesForOnscreenRows
//  This method is used in case the user scrolled into a set of cells that don't
//  have their app icons yet.
// -------------------------------------------------------------------------------
- (void)loadImagesForOnscreenRows
{
    if (self.animals.count > 0)
    {
        NSArray *visiblePaths = [self.collectionView indexPathsForVisibleItems];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Animal *animal = _animals[indexPath.row];
            
            if (!animal.image)
                // Avoid the app icon download if the app already has an icon
            {
                [self startImageDownload:animal forIndexPath:indexPath];
            }
        }
    }
}


#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//    scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}

// -------------------------------------------------------------------------------
//    scrollViewDidEndDecelerating:scrollView
//  When scrolling stops, proceed to load the app icons that are on screen.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}
@end
