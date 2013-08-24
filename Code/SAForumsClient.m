//
//  SAForumsClient.m
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-10.
//

#import "SAForumsClient.h"
#import <AFNetworking/AFNetworking.h>
#import <HTMLReader/HTMLDocument.h>
#import "SAHTMLSerializer.h"

@interface SAHTTPClient : AFHTTPClient

@end

@interface SAForumsClient ()

@property (strong, nonatomic) AFHTTPClient *HTTPClient;

@end

@implementation SAForumsClient

+ (instancetype)client
{
    static SAForumsClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (NSString *)loggedInUserID
{
    NSHTTPCookieStorage *storage = self.HTTPClient.session.configuration.HTTPCookieStorage;
    for (NSHTTPCookie *cookie in [storage cookiesForURL:self.HTTPClient.baseURL]) {
        if ([cookie.name isEqualToString:@"bbuserid"]) {
            return cookie.value;
        }
    }
    return nil;
}

- (NSURLSessionDataTask *)logInWithUsername:(NSString *)username
                                   password:(NSString *)password
                          completionHandler:(void (^)(NSError *error))completionHandler
{
    // Force the login URL to HTTPS; everything else can happen over HTTP.
    return [self.HTTPClient POST:@"https://forums.somethingawful.com/account.php"
                      parameters:@{ @"action": @"login",
                                    @"username": username,
                                    @"password": password }
                         success:^(NSHTTPURLResponse *response, id responseObject)
    {
        if (completionHandler) {
            completionHandler(nil);
        }
    } failure:^(NSError *underlyingError) {
        if (completionHandler) {
            NSInteger code = SAForumsClientErrorUnknown;
            NSString *description = @"An unknown error occurred";
            if ([underlyingError.domain isEqualToString:AFNetworkingErrorDomain] &&
                underlyingError.code == NSURLErrorBadServerResponse) {
                code = SAForumsClientErrorInvalidUsernameOrPassword;
                description = @"Invalid username or password";
            }
            NSError *error = [NSError errorWithDomain:SAForumsClientErrorDomain
                                                 code:code
                                             userInfo:@{ NSLocalizedDescriptionKey: description,
                                                         NSUnderlyingErrorKey: underlyingError }];
            completionHandler(error);
        }
    }];
}

- (NSURLSessionDataTask *)fetchPostsFromThreadWithID:(NSString *)threadID
                                                page:(NSInteger)page
                                   completionHandler:(void (^)(NSError *error, NSArray *posts))completionHandler
{
    return [self.HTTPClient GET:@"showthread.php"
                     parameters:@{ @"threadid": threadID,
                                   @"pagenumber": @(page),
                                   @"perpage": @40 }
                        success:^(NSHTTPURLResponse *response, HTMLDocument *document)
    {
        NSMutableArray *posts = [NSMutableArray new];
        for (HTMLElementNode *element in document.treeEnumerator) {
            if (![element isKindOfClass:[HTMLElementNode class]]) {
                continue;
            }
            if (![element.tagName isEqualToString:@"table"]) {
                continue;
            }
            HTMLAttribute *classAttribute;
            for (HTMLAttribute *attribute in element.attributes) {
                if ([attribute.name isEqualToString:@"class"]) {
                    classAttribute = attribute;
                    break;
                }
            }
            if (![classAttribute.value hasPrefix:@"post"]) {
                continue;
            }
            NSMutableAttributedString *post = [NSMutableAttributedString new];
            for (HTMLTextNode *textNode in element.treeEnumerator) {
                if ([textNode isKindOfClass:[HTMLTextNode class]]) {
                    [post.mutableString appendString:textNode.data];
                }
            }
            [posts addObject:post];
        }
        if (completionHandler) {
            completionHandler(nil, posts);
        }
    } failure:^(NSError *error) {
        if (completionHandler) {
            completionHandler(error, nil);
        }
    }];
}

- (NSURLSessionDataTask *)fetchSmilies:(void (^)(NSError *error, NSArray *smilies))completionHandler
{
    return [self.HTTPClient GET:@"misc.php"
                     parameters:@{ @"action": @"showsmilies" }
                        success:^(NSHTTPURLResponse *response, HTMLDocument *document)
            {
                NSMutableArray *smilies = [NSMutableArray new];
                for (HTMLElementNode *element in document.treeEnumerator) {
                    if (![element isKindOfClass:[HTMLElementNode class]]) {
                        continue;
                    }
                    if (![element.tagName isEqualToString:@"li"]) {
                        continue;
                    }
                    HTMLAttribute *classAttribute;
                    for (HTMLAttribute *attribute in element.attributes) {
                        if ([attribute.name isEqualToString:@"class"]) {
                            classAttribute = attribute;
                            break;
                        }
                    }
                    if (![classAttribute.value hasPrefix:@"smilie"]) {
                        continue;
                    }
                    NSMutableAttributedString *text = [NSMutableAttributedString new];
                    for (HTMLTextNode *textNode in element.treeEnumerator) {
                        if ([textNode isKindOfClass:[HTMLTextNode class]]) {
                            // for some reason there are a bunch of whitespace nodes
                            if (!([textNode.data rangeOfString:@":"].location == NSNotFound)) {
                            [text.mutableString appendString:textNode.data];
                            }
                        }
                    }
                    [smilies addObject:text];
                }
                if (completionHandler) {
                    completionHandler(nil, smilies);
                }
            } failure:^(NSError *error) {
                if (completionHandler) {
                    completionHandler(error, nil);
                }
            }];
}

- (AFHTTPClient *)HTTPClient
{
    if (_HTTPClient) return _HTTPClient;
    NSURL *url = [NSURL URLWithString:@"http://forums.somethingawful.com/"];
    _HTTPClient = [[SAHTTPClient alloc] initWithBaseURL:url];
    return _HTTPClient;
}

@end

@implementation SAHTTPClient

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        AFCompoundSerializer *serializer = [AFCompoundSerializer compoundSerializerWithResponseSerializers:
                                            @[ [SAHTMLSerializer serializer] ]];
        serializer.stringEncoding = NSWindowsCP1252StringEncoding;
        self.requestSerializer = serializer;
        self.responseSerializer = serializer;
    }
    return self;
}

@end

NSString * const SAForumsClientErrorDomain = @"com.awfulapp.awful.SAForumsClientError";
