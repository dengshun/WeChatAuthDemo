//
//  MessageBoardContentView.m
//  wechatauthdemo
//
//  Created by Jeason on 19/10/2015.
//  Copyright © 2015 Tencent. All rights reserved.
//

#import "MessageBoardContentView.h"
#import "ImageCache.h"
#import "ADCommentList.h"
#import "ADReplyList.h"
#import "ADUser.h"
#import "ADNetworkEngine.h"

/* Font */
static const CGFloat kNickNameFontSize = 16.0f;
static const CGFloat kTimeStampFontSize = 14.0f;
static const CGFloat kContentFontSize = 15.0f;

/* Size */
static const CGFloat kNickNameWidth = 176.0f;
static const CGFloat kTimeStampWidth = 88.0f;

@interface MessageBoardContentView ()

@property (nonatomic, strong) NSDateFormatter *formatter;
@property (nonatomic, strong) ADCommentList *comment;
@property (nonatomic, strong) ADReplyList *reply;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;

@end

@implementation MessageBoardContentView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.headImage];
        [self addSubview:self.nickName];
        [self addSubview:self.timeStamp];
        [self addSubview:self.content];
        [self addSubview:self.line];
        [self addGestureRecognizer:self.tapGesture];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.headImage.frame = CGRectMake(inset, inset, 33, 33);
    self.nickName.frame = CGRectMake(CGRectGetMaxX(self.headImage.frame)+inset,
                                     inset*0.5,
                                     kNickNameWidth, 33);
    self.timeStamp.frame = CGRectMake(CGRectGetWidth(self.frame)-inset-kTimeStampWidth,
                                      inset*0.5,
                                      kTimeStampWidth, 33);
    if (self.comment) {
        self.content.frame = CGRectMake(CGRectGetMinX(self.nickName.frame),
                                        CGRectGetMaxY(self.nickName.frame),
                                        CGRectGetWidth(self.frame)-normalHeight-inset, self.comment.height);
        self.line.frame = CGRectMake(inset, 0, ScreenWidth-2*inset, 1);
    } else if (self.reply) {
        self.content.frame = CGRectMake(CGRectGetMinX(self.nickName.frame),
                                        CGRectGetMinY(self.nickName.frame),
                                        CGRectGetWidth(self.frame)-normalHeight-inset, self.reply.height);
        self.line.frame = CGRectMake(inset*4, 0, ScreenWidth-5*inset, 1);
    }
}

#pragma mark - User Actions
- (void)onClickContent: (UITapGestureRecognizer *)sender {
    if (sender != self.tapGesture)
        return;
    self.clickCallBack != nil ? self.clickCallBack() : nil;
}

#pragma mark - Public Interface
- (void)configureViewWithComment:(ADCommentList *)comment {
    self.comment = comment;
    [self configureViewWithUser:comment.user
                           Date:comment.date
                        Content:comment.content];
}

- (void)configureViewWithReply:(ADReplyList *)reply {
    self.reply = reply;
    [self configureViewWithUser:reply.user
                           Date:reply.date
                        Content:reply.content];
}

+ (CGFloat)calcHeightForComment:(ADCommentList *)comment {
    if (comment.height == 0) {
        comment.height = [self calcHeightForContent:comment.content WithWidth:ScreenWidth-normalHeight-inset];
    }
    return comment.height + normalHeight;

}

+ (CGFloat)calcHeightForReply:(ADReplyList *)reply {
    if (reply.height == 0) {
        return reply.height = [self calcHeightForContent:reply.content
                                               WithWidth: ScreenWidth-4*inset-normalHeight-inset]+normalHeight+inset;
    } else {
        return reply.height;
    }
}

#pragma mark - Private Methods
- (void)configureViewWithUser:(ADUser *)user
                         Date:(NSTimeInterval)date
                      Content:(NSString *)contentString {
    self.headImage.image = [UIImage getCachedImageForUrl:user.headimgurl];
    if (self.headImage.image == nil) {
        [[ADNetworkEngine sharedEngine] downloadImageForUrl:user.headimgurl
                                             WithCompletion:^(UIImage *image) {
                                                 self.headImage.image = image;
                                                 [self setNeedsDisplay];
                                             }];
    }
    self.nickName.text = user.nickname;
    self.timeStamp.text = [self.formatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:date]];
    self.content.text = contentString;
}

+ (CGFloat)calcHeightForContent:(NSString *)contentString
                      WithWidth:(CGFloat)width {
    return CGRectGetHeight([contentString boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{
                                                                 NSFontAttributeName: [UIFont fontWithName:kChineseFont
                                                                                                      size:kContentFontSize],
                                                                 }
                                                       context:nil]);
}

#pragma mark - Lazy Initializers
- (UIImageView *)headImage {
    if (_headImage == nil) {
        _headImage = [[UIImageView alloc] init];
        _headImage.layer.cornerRadius = 33/2;
        _headImage.layer.masksToBounds = YES;
    }
    return _headImage;
}

- (UILabel *)nickName {
    if (_nickName == nil) {
        _nickName = [[UILabel alloc] init];
        _nickName.font = [UIFont fontWithName:kChineseFont
                                         size:kNickNameFontSize];
    }
    return _nickName;
}

- (UILabel *)timeStamp {
    if (_timeStamp == nil) {
        _timeStamp = [[UILabel alloc] init];
        _timeStamp.font = [UIFont fontWithName:kChineseFont
                                          size:kTimeStampFontSize];
        _timeStamp.textColor = [UIColor lightGrayColor];
        _timeStamp.textAlignment = NSTextAlignmentRight;
    }
    return _timeStamp;
}

- (UILabel *)content {
    if (_content == nil) {
        _content = [[UILabel alloc] init];
        _content.font = [UIFont fontWithName:kChineseFont
                                        size:kContentFontSize];
        _content.lineBreakMode = NSLineBreakByWordWrapping;
        _content.numberOfLines = 0;
    }
    return _content;
}

- (NSDateFormatter *)formatter {
    if (_formatter == nil) {
        _formatter = [[NSDateFormatter alloc] init];
        _formatter.dateFormat = @"yyyy-MM-dd";
    }
    return _formatter;
}

- (UIView *)line {
    if (_line == nil) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor groupTableViewBackgroundColor];// you can also put image here
    }
    return _line;
}

- (UITapGestureRecognizer *)tapGesture {
    if (_tapGesture == nil) {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                              action:@selector(onClickContent:)];
    }
    return _tapGesture;
}

@end
