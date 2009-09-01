#import "AppCon.h"
#import "Trailer.h"

@implementation AppCon

-(id)init{
    [super init];
    trailers = [NSMutableArray array];
    return self;
}

- (void)awakeFromNib{
    [self refresh:self];
}

-(void)processXml:(NSData *)urlData{
	NSError *error;
	
    // Parse XML into document thingy
    	
	NSXMLDocument *doc = [[NSXMLDocument alloc] initWithData:urlData
                                                     options:0
                                                       error:&error];
	[doc autorelease];
    
    if(!doc){
		NSLog(@"%@", [error localizedDescription]);
		//TODO: Better error message
		NSAlert *alert = [NSAlert alertWithError:error];
		[alert runModal];
		return;
    }
        
    NSArray *movies = [doc objectsForXQuery:@"records/movieinfo" error:&error];
    
    if(!movies){
        //TODO: Better error message
        NSLog(@"What the deuce? %@", [error localizedDescription]);
    }
    
    for(NSXMLElement *curmovie in movies){
        Trailer *newtrailer = [[[Trailer alloc] init] autorelease];
        
        // Get info/title into newtrailer.title
        NSArray *title = [curmovie objectsForXQuery:@"info/title" error:&error];
        newtrailer.title = [[title objectAtIndex:0] stringValue];
        
        // Get info/description
        NSArray *description = [curmovie objectsForXQuery:@"info/description" error:&error];
        newtrailer.description = [[description objectAtIndex:0] stringValue];
        
        // Get preview/large
        NSArray *preview = [curmovie objectsForXQuery:@"preview/large" error:&error];
        newtrailer.preview_url = [[preview objectAtIndex:0] stringValue];
        
        // Get poster/location
        NSArray *poster = [curmovie objectsForXQuery:@"poster/location" error:&error];
        newtrailer.poster_url = [[poster objectAtIndex:0] stringValue];
		
		[newtrailer defaultPoster];
		newtrailer.shouldDownload = [NSNumber numberWithBool:NO];

        [newtrailer loadPoster];
        
        [ArrayCon addObject:newtrailer];
    }

}
-(void)refresh:(id)sender {
    // Setup URL
	//TODO: Move this to preference
    NSURL *url_720p = [NSURL URLWithString:@"http://www.apple.com/trailers/home/xml/current_720p.xml"];
    
    // ..and the request
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url_720p
                                             cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                         timeoutInterval:30];
    // ..finally make the request!
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    
    // Check for errors
    if(!urlData){
        NSAlert *alert = [NSAlert alertWithMessageText:@"Sorry, there seems to be some problem getting the XML feed"
										 defaultButton:@"Appology accepted"
									   alternateButton:nil
										   otherButton:nil
							 informativeTextWithFormat:[NSString stringWithFormat:@"Ensure Apple still exist and have a functioning website. Also check you internet connection hasn't exploded (Oh, the error was.. %@)", [error localizedDescription]]];
        
        [alert runModal];
        return;
    }
    
	[self processXml:urlData];

}

-(void)filter:(id)sender{
    NSString *filter = [NSString stringWithFormat:@"title like [c] \"%@*\"", [SearchField stringValue]];
    [ArrayCon setFilterPredicate:[NSPredicate predicateWithFormat:filter]];
}

@end
