//
//  SAThreadViewController.m
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-14.
//

#import "SAThreadViewController.h"
#import "SAForumsClient.h"

@interface SAPostColletionViewCell : UICollectionViewCell

@property (readonly, strong, nonatomic) UITextView *textView;

@end

@interface SAThreadViewController () <UICollectionViewDelegateFlowLayout>

@property (copy, nonatomic) NSArray *posts;

@end

@implementation SAThreadViewController

- (id)initWithThread:(SAThread *)thread
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 0;
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _thread = thread;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[SAPostColletionViewCell class] forCellWithReuseIdentifier:@"Post"];
    __weak __typeof__(self) weakSelf = self;
    [self.thread postsOnPage:1 completionHandler:^(NSError *error, NSArray *posts) {
        __typeof__(self) strongSelf = weakSelf;
        strongSelf.posts = posts;
        if ([strongSelf isViewLoaded]) {
            [strongSelf.collectionView reloadData];
        }
    }];
}

#pragma mark UICollectionViewDataSource and UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.posts.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SAPostColletionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Post"
                                                                              forIndexPath:indexPath];
    SAPost *post = self.posts[indexPath.item];
    cell.textView.attributedText = [[NSAttributedString alloc] initWithString:post.HTMLContents];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SAPost *post = self.posts[indexPath.item];
    NSAttributedString *string = [[NSAttributedString alloc] initWithString:post.HTMLContents];
    CGRect textBounds = [string boundingRectWithSize:CGSizeMake(CGRectGetWidth(collectionView.frame), 0)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                             context:nil];
    return CGSizeMake(CGRectGetWidth(collectionView.frame), CGRectGetHeight(textBounds));
}

@end

@implementation SAPostColletionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _textView = [[UITextView alloc] initWithFrame:(CGRect){ .size = frame.size }];
        _textView.translatesAutoresizingMaskIntoConstraints = NO;
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
        [self.contentView addSubview:_textView];
        NSDictionary *views = @{ @"textView": _textView };
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textView]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textView]|"
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:views]];
    }
    return self;
}

@end
