//
//
//  AppCorner
//
//  Created by Denis Berton 2013.
//
//


#import <UIKit/UIKit.h>
#import "UIImageView+AFNetworking.h"

@interface ITPAppIconImageView : UIImageView

@property (nonatomic,strong) ACKApp* app;

- (id)initWithFrame:(CGRect)frame app:(ACKApp*)app;
    
@property (nonatomic, strong) UIActivityIndicatorView *placeholderActivityIndicatorView;

@end
