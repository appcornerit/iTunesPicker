//
//
//  AppCorner
//
//  Created by Denis Berton 2013.
//
//

#import "ITPAppIconImageView.h"

@implementation ITPAppIconImageView

- (id)initWithFrame:(CGRect)frame app:(ACKApp*)app
{
    self = [super initWithFrame:frame];
    if (self) {
        self.app = app;
    }
    return self;
}

-(void)setApp:(ACKApp *)app
{
    _app = app;
    [self loadImage];
}

-(void)loadImage
{
    if(self.placeholderActivityIndicatorView)
    {
        self.placeholderActivityIndicatorView.hidden = NO;
        [self.placeholderActivityIndicatorView removeFromSuperview];
    }
    
    if(!self.app.iconURL)
    {
        [self setImage:[UIImage imageNamed:@"common.app.placeholder.icon.png"]];
        return;
    }
    
    self.placeholderActivityIndicatorView = [[UIActivityIndicatorView alloc] initWithFrame:self.bounds];
    [self.placeholderActivityIndicatorView startAnimating];
    self.placeholderActivityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    self.placeholderActivityIndicatorView.hidden = NO;
    [self addSubview:self.placeholderActivityIndicatorView];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[[NSURL alloc] initWithString:self.app.iconURL]];
    [request setHTTPShouldHandleCookies:NO];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    __weak __typeof(&*self)weakSelf = self;
    [self setImageWithURLRequest:request placeholderImage:[UIImage imageNamed:@"common.app.placeholder.icon.png"] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        weakSelf.image = image;
        CALayer *mask = [CALayer layer];
        mask.contents = (id)[[UIImage imageNamed:@"apppicker.appicon.mask.png"] CGImage];
        mask.frame = CGRectMake(0, 0, weakSelf.frame.size.width, weakSelf.frame.size.height);
        weakSelf.layer.mask = mask;
        weakSelf.layer.masksToBounds = YES;
        [weakSelf.placeholderActivityIndicatorView stopAnimating];
        weakSelf.placeholderActivityIndicatorView.hidden = YES;
//        weakSelf.image = [weakSelf applyMask:image];
        [weakSelf setNeedsDisplay];
    }failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [weakSelf.placeholderActivityIndicatorView stopAnimating];
        weakSelf.placeholderActivityIndicatorView.hidden = YES;
    }];
}


- (UIImage*)applyMask:(UIImage*)image
{
    // Drawing code
    if (!self.app.iconIsPrerendered)
    {
        UIGraphicsBeginImageContext(image.size);
        [image drawAtPoint:CGPointZero];
        CGRect imageRect = (CGRect) {
            .size = image.size
        };
        [[UIImage imageNamed:@"apppicker.appicon.overlay.png"] drawInRect:imageRect];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    CGImageRef maskRef = [UIImage imageNamed:@"apppicker.appicon.mask.png"].CGImage;
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    CGImageRef maskedImageRef = CGImageCreateWithMask([image CGImage], mask);
    image = [UIImage imageWithCGImage:maskedImageRef];
    CGImageRelease(mask);
    CGImageRelease(maskedImageRef);
    return image;
}


@end
