#import "Trailer.h"


@implementation Trailer

-(NSMutableAttributedString*)displayString {
    // Formats the main column using the title/description.
    NSMutableAttributedString *ns = [[NSMutableAttributedString alloc] initWithString:title];
    [ns addAttribute:NSFontAttributeName value:[NSFont userFontOfSize:20] range:NSMakeRange(0, [title length])];
    
    if(description){
        [ns appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"\n"]];
        [ns appendAttributedString:[[NSMutableAttributedString alloc] initWithString:description]];
    }
    return ns;
}
//-(NSData*)poster{
//    [self load];
//    return nil;
//    if(poster_cache != nil){
//        NSLog(@"Poster is cached!");
//        return self.poster_cache;
//    }
//    
//    NSURL *url = [NSURL URLWithString:poster_url];
//    NSLog(@"Getting poster %@", poster_url);
//    NSImage *poster_img = [[NSImage alloc] initWithData:[url resourceDataUsingCache:YES]];
//    poster_cache = [poster_img TIFFRepresentation];
//    return poster_cache;
//}

- (void)loadPoster {
    NSURL *myURL = [NSURL URLWithString:poster_url];
    NSURLRequest *request = [NSURLRequest requestWithURL:myURL
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:60];
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection
didReceiveResponse:(NSURLResponse *)response {
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection
    didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error {
    [responseData release];
    [connection release];
    NSLog(@"Error retreving data for %@: %@", poster_url, [error localizedDescription]);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [self willChangeValueForKey:@"poster"];
    poster = responseData;
    [self didChangeValueForKey:@"poster"];
    responseData = nil;
    [responseData release];
    [connection release];
}


@synthesize title;
@synthesize description;
@synthesize poster;
@synthesize preview_url;
@synthesize poster_url;
@synthesize download;
@end
