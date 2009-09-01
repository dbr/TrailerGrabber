#import "Trailer.h"


@implementation Trailer

-(NSMutableAttributedString*)displayString {
    // Formats the main column using the title/description.
    NSMutableAttributedString *ns = [[[NSMutableAttributedString alloc] initWithString:title] autorelease];
    [ns addAttribute:NSFontAttributeName value:[NSFont userFontOfSize:20] range:NSMakeRange(0, [title length])];
    
    if(description){
        [ns appendAttributedString:[[[NSMutableAttributedString alloc] initWithString:@"\n"] autorelease]];
        [ns appendAttributedString:[[[NSMutableAttributedString alloc] initWithString:description] autorelease]];
    }
    return ns;
}

-(void)defaultPoster {
	// Sets the poster to the default image
	NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
	NSString *defaultPosterPath = [resourcePath stringByAppendingPathComponent:@"defaultPoster.png"];
	//NSImage *posterImage = [[NSImage alloc] initWithContentsOfFile:defaultPosterPath];
	NSImage *posterImage = [[[NSImage alloc] initWithContentsOfFile:defaultPosterPath] autorelease];
	self.poster = [posterImage TIFFRepresentation];
}

- (void)loadPoster {
    NSURL *myURL = [NSURL URLWithString:poster_url];
	
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:myURL
												cachePolicy:NSURLRequestReturnCacheDataElseLoad
											timeoutInterval:30];
	
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		__block NSError *error;
		NSData *urlData;
		__block NSURLResponse *response;

		urlData = [NSURLConnection sendSynchronousRequest:urlRequest
										returningResponse:&response
													error:&error];
		dispatch_async(dispatch_get_main_queue(), ^{
			if(error) {
				NSLog(@"Error while retriving poster: %@", [error localizedDescription]);
			}
			self.poster = urlData;
		});
		
	});
	
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:60];
    [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
}

@synthesize title;
@synthesize description;
@synthesize poster;
@synthesize preview_url;
@synthesize poster_url;
@synthesize shouldDownload;
@end
