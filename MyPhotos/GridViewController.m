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
    NSMutableArray *thumbnails;
    NSMutableArray *assets;
}

@end

@implementation GridViewController

- (ALAssetsLibrary *) defaultLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"My Photos";
    
    [self.collectionView setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
    [self.collectionView registerClass:[PSUICollectionViewCell class] forCellWithReuseIdentifier:@"MY_CELL"];
    
    thumbnails = [[NSMutableArray alloc] init];
    assets = [[NSMutableArray alloc] init];
    ALAssetsLibrary *library = [self defaultLibrary];
    
    
    [library enumerateGroupsWithTypes:ALAssetsGroupAll
                           usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                               [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                                   if(asset){
                                       UIImage *image = [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
                                       [thumbnails addObject:image];
                                       [assets addObject:asset];
                                   }
                               }];
                               
                               [self.collectionView reloadData];
                           }
                         failureBlock:^(NSError *error) {
                             NSLog(@"Failed to read assets");
                         }];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return thumbnails.count;
}

- (PSUICollectionViewCell *)collectionView:(PSUICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    PSUICollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"MY_CELL" forIndexPath:indexPath];
    
    if(cell.contentView.subviews.count > 0){
        [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    UIImage *image = [thumbnails objectAtIndex:indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.layer.borderWidth = 3.0;
    imageView.layer.borderColor = [UIColor whiteColor].CGColor;
    imageView.layer.shadowColor = [UIColor blackColor].CGColor;
    imageView.layer.shadowOpacity = 1.0f;
    imageView.layer.shadowOffset = CGSizeMake(0, 0.5f);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:imageView.bounds];
    imageView.layer.shadowPath = path.CGPath;
    
    [cell.contentView addSubview:imageView];
    
    return cell;
}

- (void)collectionView:(PSUICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoViewController *photoViewController = [[PhotoViewController alloc] initWithImages:assets andIndex:indexPath.row];
    
    [self.navigationController pushViewController:photoViewController animated:YES];
}

- (UIEdgeInsets)collectionView:(PSUICollectionView *)collectionView
                   layout:(PSUICollectionViewLayout*)collectionViewLayout
   insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (CGSize)collectionView:(PSUICollectionView *)collectionView
                  layout:(PSUICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIImage *img = [thumbnails objectAtIndex:indexPath.row];
    return CGSizeMake(img.size.width, img.size.height);
}

- (CGFloat)collectionView:(PSUICollectionView *)collectionView
                   layout:(PSUICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (CGFloat)collectionView:(PSUICollectionView *)collectionView
                   layout:(PSUICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    return interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                               duration:(NSTimeInterval)duration{
    [self.collectionView reloadData];
}


@end
