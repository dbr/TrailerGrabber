#import <Cocoa/Cocoa.h>

@interface AppCon : NSObject {
    IBOutlet NSArrayController *ArrayCon;
    IBOutlet NSSearchField *SearchField;
    
    NSMutableArray *trailers;
}

-(void)refresh:(id)sender;
-(void)filter:(id)sender;

@end
