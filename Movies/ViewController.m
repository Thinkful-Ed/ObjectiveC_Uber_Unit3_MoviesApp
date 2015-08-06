//
//  ViewController.m
//  Movies
//
//  Created by Craig on 14/07/2015.
//  Copyright (c) 2015 Thinkful. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"
#import "Movie.h"

@interface ViewController ()

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UITextView *movieTextView;
@property (strong, nonatomic) UIImageView *moviePosterImageView;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) Movie *movie;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Instantiate objects
    self.searchBar = [[UISearchBar alloc] init];
    self.movieTextView = [[UITextView alloc] init];
    self.moviePosterImageView = [[UIImageView alloc] init];
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] init];
    self.movie = [[Movie alloc] init];
    self.movie.delegate = self;
    
    //Add to view
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.movieTextView];
    [self.view addSubview:self.moviePosterImageView];
    [self.view addSubview:self.activityIndicatorView];
    
    //Customize search bar
    self.searchBar.placeholder = @"Search movie title";
    self.searchBar.delegate = self;
    
    //Customize movie text view
    self.movieTextView.editable = NO;
    
    //Customize activity indicator view
    self.activityIndicatorView.color = [UIColor grayColor];
    
    //Set up Masonry constraints
    //type topLayoutGuide as UIView to use in Masonry
    UIView *topLayoutGuide = (id)self.topLayoutGuide;
    
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(topLayoutGuide.mas_bottom);
    }];
    [self.movieTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.height.mas_equalTo(150);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    [self.moviePosterImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.movieTextView.mas_bottom).priorityHigh();
        make.right.equalTo(self.view.mas_right);
    }];
    [self.activityIndicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
}

#pragma mark UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self.movie searchMovie:searchBar.text];
    [self.activityIndicatorView startAnimating];
}
#pragma mark MovieDelegate
-(void)updated {
    /*
     //display movie data without formatting
     NSMutableString *dataString = [[NSMutableString alloc] init];
     [dataString appendString:[NSString stringWithFormat:@"%@ \n", self.movie.title]];
     [dataString appendString:[NSString stringWithFormat:@"%@ \n", self.movie.actors]];
     [dataString appendString:[NSString stringWithFormat:@"%@ \n", self.movie.plot]];
     self.movieTextView.text = dataString;
     */
    //display movie data with formatting
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n", self.movie.title]
                                                                             attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:20]}]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n", self.movie.actors]
                                                                             attributes:@{NSFontAttributeName: [UIFont italicSystemFontOfSize:14]}]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n", self.movie.plot]
                                                                             attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}]];
    self.movieTextView.attributedText = attributedString;
    
    [self.movieTextView sizeToFit];
    
    [self.movieTextView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.movieTextView.frame.size.height);
    }];
}
-(void)receivedPosterImage:(UIImage *)posterImage {
    [self.moviePosterImageView setImage:posterImage];
    [self.activityIndicatorView stopAnimating];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
