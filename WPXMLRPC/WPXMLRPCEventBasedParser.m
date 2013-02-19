#import "WPXMLRPCEventBasedParser.h"
#import "WPXMLRPCEventBasedParserDelegate.h"

@interface WPXMLRPCEventBasedParser () <NSXMLParserDelegate>
@end

@implementation WPXMLRPCEventBasedParser {
    NSXMLParser *myParser;
    WPXMLRPCEventBasedParserDelegate *myParserDelegate;
    BOOL isFault;
}

- (id)initWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    if (self = [self init]) {
        myParser = [[NSXMLParser alloc] initWithData:data];
        myParserDelegate = nil;
        isFault = NO;
    }
    
    return self;
}

#pragma mark -

- (id)parse {
    [myParser setDelegate:self];
    
    [myParser parse];
    
    if ([myParser parserError]) {
        return nil;
    }
    
    return [myParserDelegate elementValue];
}

- (void)abortParsing {
    [myParser abortParsing];
}

#pragma mark -

- (NSError *)parserError {
    return [myParser parserError];
}

#pragma mark -

- (BOOL)isFault {
    return isFault;
}

#pragma mark -


@end

#pragma mark -

@implementation WPXMLRPCEventBasedParser (NSXMLParserDelegate)

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)element namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributes {
    if ([element isEqualToString:@"fault"]) {
        isFault = YES;
    } else if ([element isEqualToString:@"value"]) {
        myParserDelegate = [[WPXMLRPCEventBasedParserDelegate alloc] initWithParent:nil];
        
        [myParser setDelegate:myParserDelegate];
    }
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    [self abortParsing];
}

@end
