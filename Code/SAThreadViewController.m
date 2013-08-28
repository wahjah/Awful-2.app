//
//  SAThreadViewController.m
//  Awful 2
//
//  Created by Nolan Waite on 2013-08-14.
//

#import "SAThreadViewController.h"
#import "SAForumsClient.h"

@interface SAPostHeaderView : UICollectionReusableView

@property (readonly, strong, nonatomic) UILabel *authorUsernameLabel;

@end

@interface SAPostColletionViewCell : UICollectionViewCell

@property (readonly, strong, nonatomic) UITextView *textView;

@end

@interface SAPostDividerView : UICollectionReusableView

@end

@interface SAThreadViewController () <UICollectionViewDelegateFlowLayout>

@property (copy, nonatomic) NSArray *posts;

@end

@implementation SAThreadViewController

- (id)initWithThread:(SAThread *)thread
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.headerReferenceSize = CGSizeMake(0, 54);
    self = [super initWithCollectionViewLayout:layout];
    if (self) {
        _thread = thread;
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerClass:[SAPostHeaderView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"Header"];
    [self.collectionView registerClass:[SAPostColletionViewCell class] forCellWithReuseIdentifier:@"Post"];
    [self.collectionView registerClass:[SAPostDividerView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:@"Divider"];
    __weak __typeof__(self) weakSelf = self;
    [self.thread postsOnPage:1 completionHandler:^(NSError *error, NSArray *posts) {
        __typeof__(self) strongSelf = weakSelf;
        strongSelf.posts = posts;
        if ([strongSelf isViewLoaded]) {
            [strongSelf.collectionView reloadData];
        }
    }];
}

#pragma mark UICollectionViewDataSource and UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.posts.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SAPostColletionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Post"
                                                                              forIndexPath:indexPath];
    SAPost *post = self.posts[indexPath.section];
    cell.textView.attributedText = post.stringContents;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SAPostHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                                      withReuseIdentifier:@"Header"
                                                                             forIndexPath:indexPath];
        SAPost *post = self.posts[indexPath.section];
        header.authorUsernameLabel.text = post.author.username;
        return header;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        return [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                  withReuseIdentifier:@"Divider"
                                                         forIndexPath:indexPath];
        
    }
    else {
        return nil;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SAPost *post = self.posts[indexPath.section];
    UIEdgeInsets sectionInset = ((UICollectionViewFlowLayout *)collectionViewLayout).sectionInset;
    CGFloat itemWidth = CGRectGetWidth(UIEdgeInsetsInsetRect(collectionView.frame, sectionInset));
    CGRect textBounds = [post.stringContents boundingRectWithSize:CGSizeMake(itemWidth, 0)
                                                          options:(NSStringDrawingUsesLineFragmentOrigin |
                                                                   NSStringDrawingUsesFontLeading)
                                                          context:nil];
    
    // Without the `+ 1` the last line is typically cut off when the UITextView renders. Worth further investigation, but this works for now.
    return CGSizeMake(itemWidth, ceilf(CGRectGetHeight(textBounds)) + 1);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section
{
    if (section + 1 == collectionView.numberOfSections) {
        return CGSizeZero;
    }
    return CGSizeMake(0, 1);
}

@end

@implementation SAPostHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _authorUsernameLabel = [UILabel new];
        _authorUsernameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _authorUsernameLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        [self addSubview:_authorUsernameLabel];
        NSDictionary *views = @{ @"username": _authorUsernameLabel };
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[username]|"
                                                                     options:0
                                                                     metrics:nil
                                                                       views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[username]|" options:0 metrics:nil views:views]];
    }
    return self;
}

@end

@implementation SAPostColletionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _textView = [[UITextView alloc] initWithFrame:(CGRect){ .size = frame.size }];
        _textView.translatesAutoresizingMaskIntoConstraints = NO;
        _textView.editable = NO;
        _textView.scrollEnabled = NO;
        
        // We'll do our own padding.
        _textView.textContainerInset = UIEdgeInsetsZero;
        _textView.textContainer.lineFragmentPadding = 0;
        
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

@implementation SAPostDividerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}

@end
