//
//  SAForumsClient.m
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-10.
//

#import "SAForumsClient.h"
#import <AFNetworking/AFNetworking.h>
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
                                   completionHandler:(void (^)(NSError *error, HTMLDocument *document))completionHandler
{
    return [self.HTTPClient GET:@"showthread.php"
                     parameters:@{ @"threadid": threadID,
                                   @"pagenumber": @(page),
                                   @"perpage": @40 }
                        success:^(NSHTTPURLResponse *response, HTMLDocument *document)
    {
        if (completionHandler) {
            completionHandler(nil, document);
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
