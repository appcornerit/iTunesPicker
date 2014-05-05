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

typedef enum {
    kITunesMediaEntityTypeSoftware = 0,
    kITunesMediaEntityTypeSoftwareiPad,
    kITunesMediaEntityTypeSoftwareMac,
    kITunesMediaEntityTypeAllArtist,
    kITunesMediaEntityTypeAllTrack,
    kITunesMediaEntityTypeMusicArtist,
    kITunesMediaEntityTypeMusicTrack, //can include both songs and music videos
    kITunesMediaEntityTypeMusicAlbum,
    kITunesMediaEntityTypeMusicMix,
    kITunesMediaEntityTypeMusicSong,
    kITunesMediaEntityTypeMusicVideoMusic,
    kITunesMediaEntityTypeMovie,
    kITunesMediaEntityTypeMovieArtist,
    kITunesMediaEntityTypeTVShowEpisode,
    kITunesMediaEntityTypeTVShowSeason,
    kITunesMediaEntityTypeAudiobook,
    kITunesMediaEntityTypeAudiobookAuthor,
    kITunesMediaEntityTypeEBook,
    kITunesMediaEntityTypePodcast,
    kITunesMediaEntityTypePodcastAuthor,
    kITunesMediaEntityTypeShortFilm,
    kITunesMediaEntityTypeShortFilmArtist
} tITunesMediaEntityType;


//App

typedef enum {
    kITunesAppChartTypeTopFreeApps = 0,
    kITunesAppChartTypeTopPaidApps,
    kITunesAppChartTypeTopGrossingApps,
    kITunesAppChartTypeNewApps,
    kITunesAppChartTypeNewFreeApps,
    kITunesAppChartTypeNewPaidApps
} tITunesAppChartType;

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

//Music

typedef enum {
    kITunesMusicChartTypeTopAlbums = 0,
//    kITunesMusicChartTypeTopiMixes,
    kITunesMusicChartTypeTopSongs
} tITunesMusicChartType;

typedef enum {
    kITunesMusicGenreTypeAll = 0,
    kITunesMusicGenreTypeAlternative,
    kITunesMusicGenreTypeAnime,
    kITunesMusicGenreTypeBlues,
    kITunesMusicGenreTypeBrazilian,
    kITunesMusicGenreTypeChildrenMusic,
    kITunesMusicGenreTypeChinese,
    kITunesMusicGenreTypeChristianGospel,
    kITunesMusicGenreTypeClassical,
    kITunesMusicGenreTypeComedy,
    kITunesMusicGenreTypeCountry,
    kITunesMusicGenreTypeDance,
    kITunesMusicGenreTypeDisney,
    kITunesMusicGenreTypeEasyListening,
    kITunesMusicGenreTypeElectronic,
    kITunesMusicGenreTypeEnka,
    kITunesMusicGenreTypeFitnessWorkout,
    kITunesMusicGenreTypeFrenchPop,
    kITunesMusicGenreTypeGermanFolk,
    kITunesMusicGenreTypeGermanPop,
    kITunesMusicGenreTypeHipHopRap,
    kITunesMusicGenreTypeHoliday,
    kITunesMusicGenreTypeIndian,
    kITunesMusicGenreTypeInstrumental,
    kITunesMusicGenreTypeJPop,
    kITunesMusicGenreTypeJazz,
    kITunesMusicGenreTypeKPop,
    kITunesMusicGenreTypeKaraoke,
    kITunesMusicGenreTypeKayokyoku,
    kITunesMusicGenreTypeKorean,
    kITunesMusicGenreTypeLatino,
    kITunesMusicGenreTypeNewAge,
    kITunesMusicGenreTypeOpera,
    kITunesMusicGenreTypePop,
    kITunesMusicGenreTypeRBSoul,
    kITunesMusicGenreTypeReggae,
    kITunesMusicGenreTypeRock,
    kITunesMusicGenreTypeSingerSongwriter,
    kITunesMusicGenreTypeSoundtrack,
    kITunesMusicGenreTypeSpokenWord,
    kITunesMusicGenreTypeVocal,
    kITunesMusicGenreTypeWorld
} tITunesMusicGenreType;

extern NSString *const kITunesMusicNotExplicit;

//Movie

typedef enum {
    kITunesMovieChartTypeTopMovies = 0,
    kITunesMovieChartTypeTopVideoRentals
} tITunesMovieChartType;

typedef enum {
    kITunesMovieGenreTypeAll = 0,
    kITunesMovieGenreTypeActionAdventure,
    kITunesMovieGenreTypeAfrican,
    kITunesMovieGenreTypeAnime,
    kITunesMovieGenreTypeBollywood,
    kITunesMovieGenreTypeClassics,
    kITunesMovieGenreTypeComedy,
    kITunesMovieGenreTypeConcertFilms,
    kITunesMovieGenreTypeDocumentary,
    kITunesMovieGenreTypeDrama,
    kITunesMovieGenreTypeForeign,
    kITunesMovieGenreTypeHoliday,
    kITunesMovieGenreTypeHorror,
    kITunesMovieGenreTypeIndependent,
    kITunesMovieGenreTypeJapaneseCinema,
    kITunesMovieGenreTypeJidaigeki,
    kITunesMovieGenreTypeKidsFamily,
    kITunesMovieGenreTypeKoreanCinema,
    kITunesMovieGenreTypeMadeForTV,
    kITunesMovieGenreTypeMiddleEastern,
    kITunesMovieGenreTypeMusicDocumentaries,
    kITunesMovieGenreTypeMusicFeatureFilms,
    kITunesMovieGenreTypeMusicals,
    kITunesMovieGenreTypeRegionalIndian,
    kITunesMovieGenreTypeRomance,
    kITunesMovieGenreTypeRussian,
    kITunesMovieGenreTypeSciFiFantasy,
    kITunesMovieGenreTypeShortFilms,
    kITunesMovieGenreTypeSpecialInterest,
    kITunesMovieGenreTypeSports,
    kITunesMovieGenreTypeThriller,
    kITunesMovieGenreTypeTokusatsu,
    kITunesMovieGenreTypeTurkish,
    kITunesMovieGenreTypeUrban,
    kITunesMovieGenreTypeWestern
} tITunesMovieGenreType;
