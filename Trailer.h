#import <Cocoa/Cocoa.h>


@interface Trailer : NSObject {
    NSString *title;
    NSString *description;
    NSString *preview_url;
    NSString *poster_url;
    NSData *poster;
    bool download;
    
    NSMutableData *responseData;
}

-(NSMutableAttributedString*)displayString;
- (void)loadPoster;

@property (readwrite, copy) NSString *title;
@property (readwrite, copy) NSString *description;
@property (readwrite, copy) NSString *preview_url;
@property (readwrite, copy) NSString *poster_url;
@property (readwrite, copy) NSData *poster;
@property (readwrite, assign) bool download;
@end
