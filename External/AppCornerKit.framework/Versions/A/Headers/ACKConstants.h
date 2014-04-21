//
//  ACKContants.h
//  AppCornerKit
//
//  Created by Denis Berton on 12/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

@class ACKITunesEntity;

extern NSUInteger const kITunesMaxLimitLoadEntities;

typedef void (^ACKBooleanResultBlock)(BOOL succeeded, NSError *err);
typedef void (^ACKStringResultBlock)(NSString* str, NSError *err);
typedef void (^ACKArrayResultBlock)(NSArray* array, NSError *err);
typedef void (^ACKEntityResultBlock)(ACKITunesEntity* entity, NSError *err);

extern NSString *const kITunesEntityTypeCodeAll;
extern NSString *const kITunesEntityTypeCodeMusic;
extern NSString *const kITunesEntityTypeCodeMovie;
extern NSString *const kITunesEntityTypeCodeMusicVideo;
extern NSString *const kITunesEntityTypeCodeTVShow;
extern NSString *const kITunesEntityTypeCodeAudiobook;
extern NSString *const kITunesEntityTypeCodeEBook;
extern NSString *const kITunesEntityTypeCodePodcast;
extern NSString *const kITunesEntityTypeCodeShortFilm;
extern NSString *const kITunesEntityTypeCodeSoftware;

typedef enum {
    kITunesEntityTypeAll = 0,
    kITunesEntityTypeMusic,
    kITunesEntityTypeMovie,
    kITunesEntityTypeMusicVideo,
    kITunesEntityTypeTVShow,
    kITunesEntityTypeAudiobook,
    kITunesEntityTypeEBook,
    kITunesEntityTypePodcast,
    kITunesEntityTypeShortFilm,
    kITunesEntityTypeSoftware
} tITunesEntityType;

extern NSString *const kITunesAppChartTypeCodeTopFreeApps;
extern NSString *const kITunesAppChartTypeCodeTopPaidApps;
extern NSString *const kITunesAppChartTypeCodeTopGrossingApps;
extern NSString *const kITunesAppChartTypeCodeNewApps;
extern NSString *const kITunesAppChartTypeCodeNewFreeApps;
extern NSString *const kITunesAppChartTypeCodeNewPaidApps;

typedef enum {
    kITunesAppChartTypeTopFreeApps = 0,
    kITunesAppChartTypeTopPaidApps,
    kITunesAppChartTypeTopGrossingApps,
    kITunesAppChartTypeNewApps,
    kITunesAppChartTypeNewFreeApps,
    kITunesAppChartTypeNewPaidApps
} tITunesAppChartType;

extern NSString *const kITunesAppGenreTypeCodeAll;
extern NSString *const kITunesAppGenreTypeCodeBooks;
extern NSString *const kITunesAppGenreTypeCodeBusiness;
extern NSString *const kITunesAppGenreTypeCodeCatalogs;
extern NSString *const kITunesAppGenreTypeCodeEducation;
extern NSString *const kITunesAppGenreTypeCodeEntertainment;
extern NSString *const kITunesAppGenreTypeCodeFinance;
extern NSString *const kITunesAppGenreTypeCodeFoodDrink;
extern NSString *const kITunesAppGenreTypeCodeGames;
extern NSString *const kITunesAppGenreTypeCodeHealthFitness;
extern NSString *const kITunesAppGenreTypeCodeLifestyle;
extern NSString *const kITunesAppGenreTypeCodeMedical;
extern NSString *const kITunesAppGenreTypeCodeMusic;
extern NSString *const kITunesAppGenreTypeCodeNavigation;
extern NSString *const kITunesAppGenreTypeCodeNews;
extern NSString *const kITunesAppGenreTypeCodeNewsstand;
extern NSString *const kITunesAppGenreTypeCodePhotoVideo;
extern NSString *const kITunesAppGenreTypeCodeProductivity;
extern NSString *const kITunesAppGenreTypeCodeReference;
extern NSString *const kITunesAppGenreTypeCodeSocialNetworking;
extern NSString *const kITunesAppGenreTypeCodeSports;
extern NSString *const kITunesAppGenreTypeCodeTravel;
extern NSString *const kITunesAppGenreTypeCodeUtilities;
extern NSString *const kITunesAppGenreTypeCodeWeather;

typedef enum {
    kITunesAppGenreTypeAll = 0,
    kITunesAppGenreTypeBooks,
    kITunesAppGenreTypeBusiness,
    kITunesAppGenreTypeCatalogs,
    kITunesAppGenreTypeEducation,
    kITunesAppGenreTypeEntertainment,
    kITunesAppGenreTypeFinance,
    kITunesAppGenreTypeFoodDrink,
    kITunesAppGenreTypeGames,
    kITunesAppGenreTypeHealthFitness,
    kITunesAppGenreTypeLifestyle,
    kITunesAppGenreTypeMedical,
    kITunesAppGenreTypeMusic,
    kITunesAppGenreTypeNavigation,
    kITunesAppGenreTypeNews,
    kITunesAppGenreTypeNewsstand,
    kITunesAppGenreTypePhotoVideo,
    kITunesAppGenreTypeProductivity,
    kITunesAppGenreTypeReference,
    kITunesAppGenreTypeSocialNetworking,
    kITunesAppGenreTypeSports,
    kITunesAppGenreTypeTravel,
    kITunesAppGenreTypeUtilities,
    kITunesAppGenreTypeWeather
} tITunesAppGenreType;
