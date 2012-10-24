//
//  PhotoViewController.h
//  MyPhotos
//
//  Created by Igor Tihonov on 10/22/12.
//  Copyright (c) 2012 Igor Tihonov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoViewController : UIViewController

-(PhotoViewController*) initWithImages:(NSArray*)images andIndex:(NSInteger) index;

@end
