//
//  ViewController.m
//  MyPhotos
//
//  Created by Igor Tihonov on 10/10/12.
//  Copyright (c) 2012 Igor Tihonov. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController (){
    NSMutableArray *images;
}

@end

@implementation ViewController

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
    images = [[NSMutableArray alloc] init];
    ALAssetsLibrary *library = [self defaultLibrary];
    [library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                           usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                               [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop) {
                                   if(asset){
                                       UIImage *image = [UIImage imageWithCGImage:asset.aspectRatioThumbnail];
                                       [images addObject:image];
                                   }
                               }];
                               
 
                           }
                         failureBlock:^(NSError *error) {
                             NSLog(@"Failed to read assets");
                         }];
}

@end
