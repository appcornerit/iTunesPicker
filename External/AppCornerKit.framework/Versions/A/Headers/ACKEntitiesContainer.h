//
//  ACKEntitiesContainer.h
//  AppCornerKit
//
//  Created by Denis Berton on 25/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ACKEntitiesContainer : NSObject

@property (nonatomic, readonly) NSString *userCountry;
@property (nonatomic, readonly) tITunesEntityType entityType;
@property (nonatomic, readonly) tITunesMediaEntityType mediaEntityType;
@property (nonatomic, readonly) NSUInteger limit;

-(instancetype) init __attribute__((unavailable("init not available")));
-(id) initWithUserCountry:(NSString*)userCountry entityType:(tITunesEntityType)entityType mediaEntityType:(tITunesMediaEntityType)mediaEntityType limit:(NSUInteger)limit;

-(NSInteger)addDatasource:(NSArray*)entities foriTunesCountry:(NSString*)country;
-(void)replaceDatasourceAtIndex:(NSInteger)index entity:(NSArray*)entities foriTunesCountry:(NSString*)country;
-(void)removeDatasourceAtIndex:(NSInteger)index;
-(void)removeAllDatasources;
-(NSArray*)getDatasourceAtIndex:(NSInteger)index;
-(NSArray*)getDatasourceForCountry:(NSString*)country;
-(NSInteger)getDatasourceIndexForCountry:(NSString*)country;
-(NSInteger)datasourcesCount;
-(NSArray*)getIndexesFromEntity:(ACKITunesEntity*)entity;
-(NSArray*)getAllCountries;
-(NSString*)getCountryAtIndex:(NSInteger)index;

//advanced features
-(NSArray*)mergeEntitiesInCountriesExcludeDuplicate:(BOOL)excludeDuplicate
                            excludeNotInITunesUserCountry:(BOOL)excludeNotInITunesUserCountry
                            excludeInUserCountry:(BOOL)excludeInUserCountry;

-(NSArray*)orderByCalculatedGlobalRanking:(NSArray*)array;

@end
