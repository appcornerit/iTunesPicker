//
//  AppCornerQuery.h
//  AppCornerKit
//
//  Created by Denis Berton on 10/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ACKConstants.h"
#import "ACKITunesEntity.h"
#import <UIKit/UIKit.h>

@interface ACKITunesQuery : NSObject

@property(nonatomic, strong) NSString* userCountry; //assign ISO country code to load existInUserCountry in ACKITunesEntity
@property(nonatomic, assign, readonly) BOOL isLoading; //use KVO to handle a loading HUD
@property(nonatomic, assign) NSURLRequestCachePolicy cachePolicyLoadEntity;
@property(nonatomic, assign) NSURLRequestCachePolicy cachePolicyExistsEntity;
@property(nonatomic, assign) NSURLRequestCachePolicy cachePolicySearchTerms;
@property(nonatomic, assign) NSURLRequestCachePolicy cachePolicyChart;
@property(nonatomic, assign) NSOperationQueuePriority priority;
@property(nonatomic, assign) NSTimeInterval memoryCacheExpiration; //entities cache time (default 1h) to reduce bandwidth request, 0 not use cache

+(NSArray*) getITunesStoreCountries;
+(NSArray*) getITunesEntityType;
+(NSArray*) getITunesMediaEntityType;

//App
+(NSArray*) getAppChartType;
+(NSArray*) getAppIPadChartType;
+(NSArray*) getAppGenreType;
//App Mac
+(NSArray*) getAppMacChartType;
+(NSArray*) getAppMacGenreType;
//Music
+(NSArray*) getMusicChartType;
+(NSArray*) getMusicGenreType;
//Movie
+(NSArray*) getMovieChartType;
+(NSArray*) getMovieGenreType;
//Book
+(NSArray*) getBookChartType;
+(NSArray*) getBookGenreType;
//Music videos
+(NSArray*) getMusicVideosChartType;
+(NSArray*) getMusicVideosGenreType;

+(void) getITunesStoreCountryUserAccountByProductId:(NSString*)inAppPurchaseProductId completionBlock:(ACKStringResultBlock)completion;

-(void) searchEntitiesForTerms:(NSString*)searchTerms inITunesStoreCountry:(NSString*)country withMediaType:(tITunesMediaEntityType)mediaType withAttribute:(NSString*)attribute limit:(NSUInteger)limit completionBlock:(ACKArrayResultBlock)completion;

-(void) existsEntity:(ACKITunesEntity *)entity inITunesStoreCountry:(NSString*)country completionBlock:(ACKBooleanResultBlock)completion;
-(void) existsEntities:(NSArray *)entities inITunesStoreCountry:(NSString*)country withType:(tITunesEntityType)type completionBlock:(ACKArrayResultBlock)completion;

-(void) loadEntity:(ACKITunesEntity*)entity inITunesStoreCountry:(NSString*)country completionBlock:(ACKEntityResultBlock)completion;
-(void) loadEntities:(NSArray*)entities inITunesStoreCountry:(NSString*)country keepEntitiesNotInCountry:(BOOL)keepEntitiesNotInCountry completionBlock:(ACKArrayResultBlock)completion;

-(void) openEntity:(ACKITunesEntity*)entity inITunesStoreCountry:(NSString*)country isGift:(BOOL)gift completionBlock:(ACKBooleanResultBlock)completion;
-(void) presentStoreProduct:(ACKITunesEntity*)entity inITunesStoreCountry:(NSString*)country inUIViewController:(UIViewController*)viewController  completionBlock:(ACKBooleanResultBlock)completion; //iOS8

-(void) loadEntitiesForArtistId:(NSString *)artistId inITunesCountry:(NSString*)country withType:(tITunesEntityType)type completionBlock:(ACKArrayResultBlock)completion;

//App
-(void) loadAppChartInITunesStoreCountry:(NSString*)country  withMediaType:(tITunesMediaEntityType)mediaEntityType withType:(tITunesAppChartType)type withGenre:(tITunesAppGenreType)genre limit:(NSUInteger)limit completionBlock:(ACKArrayResultBlock)completion;
//Music
-(void) loadMusicChartInITunesStoreCountry:(NSString*)country withType:(tITunesMusicChartType)type withGenre:(tITunesMusicGenreType)genre explicit:(BOOL)addExplict limit:(NSUInteger)limit completionBlock:(ACKArrayResultBlock)completion;
//Movie
-(void) loadMovieChartInITunesStoreCountry:(NSString*)country withType:(tITunesMovieChartType)type withGenre:(tITunesMovieGenreType)genre limit:(NSUInteger)limit completionBlock:(ACKArrayResultBlock)completion;
//Book
-(void) loadBookChartInITunesStoreCountry:(NSString*)country withType:(tITunesBookChartType)type withGenre:(tITunesBookGenreType)genre limit:(NSUInteger)limit completionBlock:(ACKArrayResultBlock)completion;
//Music Videos
-(void) loadMusicVideosChartInITunesStoreCountry:(NSString*)country withType:(tITunesMusicVideosChartType)type withGenre:(tITunesMusicVideosGenreType)genre explicit:(BOOL)addExplict limit:(NSUInteger)limit completionBlock:(ACKArrayResultBlock)completion;


//Load remote configuration from your server like @"http://example.com/defaults.plist"
- (void)loadRemoteConfigurationFromURL:(NSURL *)url
                               success:(void (^)(NSDictionary *defaults))success
                               failure:(void (^)(NSError *error))failure;

//In memory cache clean
+(void)cleanCacheExceptTypes:(NSArray*)iTunesEntityTypes;

//remove all pending query request
+(void)cancellAllQuery;

@end
