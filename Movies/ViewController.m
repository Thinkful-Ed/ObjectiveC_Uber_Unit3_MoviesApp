//
//  ViewController.m
//  Movies
//
//  Created by Craig on 14/07/2015.
//  Copyright (c) 2015 Thinkful. All rights reserved.
//

#import "ViewController.h"
#import "Masonry.h"

@interface ViewController ()

@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) UITextView *movieTextView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Instantiate objects
    self.searchBar = [UISearchBar new];
    self.movieTextView = [UITextView new];
    
    //Add to view
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.movieTextView];
    
    //Customize search bar
    self.searchBar.placeholder = @"Search movie title";
    self.searchBar.delegate = self;
    
    //Customize movie text view
    self.movieTextView.editable = NO;
    
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
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];

    
}

#pragma mark UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    
    NSString *omdbSearchURL = [NSString stringWithFormat:@"http://www.omdbapi.com/?t=%@", searchBar.text];
    omdbSearchURL = [omdbSearchURL stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:[NSURL URLWithString:omdbSearchURL]
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self displayMovieData:json];
        });

    }];
    
    [dataTask resume];
}

-(void)displayMovieData:(NSDictionary *)json {
    NSLog(@"%@",json);
    
    /*
    //display movie data without formatting
    NSMutableString *dataString = [[NSMutableString alloc] init];
    [dataString appendString:[NSString stringWithFormat:@"%@ \n", json[@"Title"]]];
    [dataString appendString:[NSString stringWithFormat:@"%@ \n", json[@"Actors"]]];
    [dataString appendString:[NSString stringWithFormat:@"%@ \n", json[@"Plot"]]];
    self.movieTextView.text = dataString;
    */
    
    
    //display movie data with formatting
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n", json[@"Title"]]
                                                                             attributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:20]}]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n", json[@"Actors"]]
                                                                             attributes:@{NSFontAttributeName: [UIFont italicSystemFontOfSize:14]}]];
    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ \n", json[@"Plot"]]
                                                                             attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}]];
    self.movieTextView.attributedText = attributedString;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
