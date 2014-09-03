//
//  ACKShareITunesEntity.h
//  AppCornerKit
//
//  Created by Denis Berton on 21/07/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACKItunesEntity.h"

@interface ACKShareITunesEntity : NSObject

+(void) presentShareInUIViewController:(UIViewController*)viewController
                       forITunesEntity:(ACKITunesEntity*)iTunesEntity
                  inITunesStoreCountry:(NSString*)country
                            withString:(NSString*)string
                            completion:(void (^)(void))completion;

@end
