//
//  SAHTMLSerializer.m
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-12.
//

#import "SAHTMLSerializer.h"
#import <HTMLReader/HTMLReader.h>

@implementation SAHTMLSerializer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.acceptableContentTypes = [[NSSet alloc] initWithObjects:@"text/html", nil];
    }
    return self;
}

#pragma mark AFURLResponseSerialization

- (id)responseObjectForResponse:(NSURLResponse *)response
                           data:(NSData *)data
                          error:(NSError *__autoreleasing *)error
{
    NSString *string = [[NSString alloc] initWithData:data encoding:NSWindowsCP1252StringEncoding];
    return [HTMLDocument documentWithString:string];
}

@end
