iTunesPicker
============

Discover, search and compare rankings for apps, books, movies and music **from iTunes in any available country**.

#### Why another picker?
- iTunes charts are available only for your country, with iTunesPicker you can discover apps (and others items) in the world rankings and compare the position (top 200 is the iTunes API limit) for an app (book,movie,music) in the world rankings.

- you can include iTunesPicker in your app to encourage the download of your others apps (without breaking the approval rule 2.25), you can show your others apps in the App Store with a few lines of code. 

```objc
//Sample code in ITPPickerDetailViewController.m
NSString* iTunesUserCountry = @"ITUNES COUNTRY ISO CODE";
//ACKEntitiesContainer can handle/compare multiple coutries
self.entitiesDatasources = [[ACKEntitiesContainer alloc]initWithUserCountry:iTunesUserCountry entityType:kITunesEntityTypeSoftware limit:kITunesMaxLimitLoadEntities];
//ITPPickerTableViewController is controller to show your apps
ITPPickerTableViewController* pickerTableView = [[ITPPickerTableViewController alloc]initWithNibName:nil bundle:nil];
pickerTableView.delegate = self;
[pickerTableView loadEntitiesForArtistId:@"YOUR ARTIST ID HERE" inITunesCountry:iTunesUserCountry withType:kITunesEntityTypeSoftware completionBlock:^(NSArray *array, NSError *err) {
        [self.navigationController pushViewController:pickerTableView animated:YES];
}];
```

To retrive the "ITUNES COUNTRY ISO CODE" you can use:

- a country picker in iTunesPicker (user choice)
- current locale (the iTunes account could be in a different country)
- use in-app purchase pruduct identifier (probably the best way):

```objc
[ACKITunesQuery getITunesStoreCountryUserAccountByProductId:@"AN IN-APP PURCHASE PRODUCT ID" completionBlock:^(NSString *country, NSError *err) {
 //country is the ITUNES (AppStore) COUNTRY
}];
```

iTunesPicker requires iOS 7 and ARC and has been tested on iPhone 5S.

**Author**: Denis Berton [@DenisBerton](https://twitter.com/DenisBerton)

![Alt text](preview/list.png "Preview picker list") 
![Alt text](preview/detail.png "Preview picker detail") 
![Alt text](preview/comparison.png "Preview ranking positions") 
During development the layout could be changed.


#### Project Status
iTunesPicker works with **apps**, songs and albums partially , I'm developing the missing iTunes items: books, movies and music.
In the next step I will add rankings's trends (up/down arrows) for each item, and add this repo to the cocoapods repo list.

I'd love to have your contribution to iTunesPicker. There are several ways to contribute:

- Build an interface for iPad 
- Suggest new features

Work in progress, stay tuned!
