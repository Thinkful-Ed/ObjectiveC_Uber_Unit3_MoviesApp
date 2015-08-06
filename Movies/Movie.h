//
//  Movie.h
//  Movies
//
//  Created by Craig on 6/08/2015.
//  Copyright (c) 2015 Thinkful. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MovieDelegate
-(void)updated;
-(void)receivedPosterImage:(UIImage *)posterImage;
@end

@interface Movie : NSObject<NSURLSessionDelegate>

@property (weak, nonatomic) id<MovieDelegate> delegate;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *actors;
@property (strong, nonatomic) NSString *plot;

-(void)searchMovie:(NSString *)movie;

@end
