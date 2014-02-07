//
//  ViewController.m
//  MyPhotos
//
//  Created by Igor Tihonov on 10/10/12.
//  Copyright (c) 2012 Igor Tihonov. All rights reserved.
//

#import "GridViewController.h"
#import "PhotoViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface GridViewController (){
    
}

@property (strong, nonatomic) NSMutableArray *thumbnails;
@property (strong, nonatomic) NSMutableArray *originals;

@end

@implementation GridViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"My Photos";
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"MyCell"];
    
    self.thumbnails = [[NSMutableArray alloc] init];
    self.originals = [[NSMutableArray alloc] init];
    ALAssetsLibrary *library = [self defaultLibrary];
    
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                               [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                                   if(asset){
                                       UIImage *image = [self resizeImage:[UIImage imageWithCGImage:asset.aspectRatioThumbnail]];
                                       [self.thumbnails addObject:image];
                                       [self.originals addObject:asset];
                                       
                                       [self.collectionView reloadData];
                                   }
                               }];
                               
                               [self.collectionView reloadData];
                           }
                         failureBlock:^(NSError *error) {
                             NSLog(@"Failed to read assets");
                         }];
}

-(UIImage*) resizeImage:(UIImage*) original
{
    CGSize newSize = CGSizeMake(330, 300);
    
    UIGraphicsBeginImageContext(newSize);
    [original drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resized;
}

- (ALAssetsLibrary *) defaultLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return self.thumbnails.count;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MyCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    UIImage *image = [self.thumbnails objectAtIndex:indexPath.row];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    [cell.contentView addSubview:imageView];
    
    return cell;
}


#pragma mark – UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIImage *image = [self.thumbnails objectAtIndex:indexPath.row];
    
    return CGSizeMake(image.size.width, image.size.height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0,0,0,0);
}

@end
