//
//  Movie.m
//  Movies
//
//  Created by Craig on 6/08/2015.
//  Copyright (c) 2015 Thinkful. All rights reserved.
//

#import "Movie.h"

@implementation Movie

//init Note - coordinate defaults to 0,0 initially
-(void)searchMovie:(NSString *)movie {
    NSString *omdbSearchURL = [NSString stringWithFormat:@"http://www.omdbapi.com/?t=%@", movie];
    omdbSearchURL = [omdbSearchURL stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:omdbSearchURL]
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                
                                                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                                                self.title = json[@"Title"];
                                                self.actors = json[@"Actors"];
                                                self.plot = json[@"Plot"];
                                                
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    [self.delegate updated];
                                                });
                                                
                                            }];
    
    [dataTask resume];
}

@end
