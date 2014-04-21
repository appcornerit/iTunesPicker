iTunesPicker
============

Discover, search and compare rankings for apps, books, movies and music **from iTunes in any available countries**.

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
[pickerTableView loadEntitiesForArtistId:@"YOUR ARTIST ID HERE" inAppStoreCountry:iTunesUserCountry withType:kITunesEntityTypeSoftware completionBlock:^(NSArray *array, NSError *err) {
        [self.navigationController pushViewController:pickerTableView animated:YES];
}];
```

To retrive the "ITUNES COUNTRY ISO CODE" you can use:

- a country picker in iTunesPicker (user choice)
- current locale (the iTunes account could be in a different country)
- the best way is use an in-app purchase pruduct identifier:

```objc
[ACKITunesQuery getITunesStoreCountryUserAccountByProductId:@"AN IN-APP PURCHASE PRODUCT ID" completionBlock:^(NSString *country, NSError *err) {
 //country is the ITUNES (AppStore) COUNTRY
}];
```


**Author**: Denis Berton [@DenisBerton](https://twitter.com/DenisBerton)

![Alt text](preview/preview.png "Preview picker") 
![Alt text](preview/previewDetail.png "Preview detail") 


#### Project Status
iTunesPicker works with **apps only**, I'm developing the missing iTunes items: books, movies and music.
In the next step I will add rankings's trends (up/down arrows) for each item.

I'd love to have your contribution to iTunesPicker. There are several ways to contribute:

- Build an interface for iPad 
- Suggest new features

Work in progress, stay tuned!
