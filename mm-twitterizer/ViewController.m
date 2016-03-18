//
//  ViewController.m
//  mm-twitterizer
//
//  Created by Christopher Serra on 3/16/16.
//  Copyright © 2016 plugh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView1;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.textView1.delegate = self;
}


#pragma mark -
#pragma mark TwitterizeButton


- (IBAction)onTwitterizePressed:(UIButton *)sender {
    
    NSString *oldText = self.textView1.text;
    NSString *newText = [self deleteVowels:oldText];
    self.textView1.text = newText;
    [self updateCount];
}

- (BOOL)isVowel:(char)c {
    NSString *charAsStr = [[NSString stringWithFormat:@"%c", c] lowercaseString];
    NSString *vowels = @"aeiouy";
    return [vowels containsString:charAsStr];
}

- (NSString *)deleteVowels:(NSString *)str {
    NSMutableString *ret = [NSMutableString new];
    for (int i = 0; i < str.length; i++) {
        char c = [str characterAtIndex:i];
        if (! [self isVowel:c]) {
            [ret appendFormat:@"%c", c];
        }
    }
    return [NSString stringWithString:ret];
}


#pragma mark -
#pragma mark 140 character max

- (void)updateCount {
    // set character count
    self.countLabel.text = [NSString stringWithFormat:@"(%lu)", self.textView1.text.length];
}

// this method fires on every keystroke
- (void)textViewDidChange:(UITextView *)textView
{
    [self updateCount];
}


// this method fires on every insertion + every deletion
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)insertedText
{
    if ([insertedText isEqualToString:@""]) {
        // deletion
    } else {
        // insertion
        if (self.textView1.text.length + insertedText.length > 140) {
            return NO;
        }
    }
    return YES;
    
    // debug
    //NSString *replaced = [self.textView1.text substringWithRange:range];
    //NSLog(@"replacing >%@< with >%@<",replaced, insertedText);
}


#pragma mark -
#pragma mark HashtagButton


int numHashtagButtonPresses = 0;
- (IBAction)onHashtagButtonPressed:(UIButton *)sender
{
    numHashtagButtonPresses++;
    
    NSString *allText = self.textView1.text;
    NSArray *wordsArray = [allText componentsSeparatedByString: @" "];
    NSMutableString *newText = [NSMutableString new];

    for (int i = 0; i < wordsArray.count; i++) {
        NSString *word = wordsArray[i];
        if (i % 2 == numHashtagButtonPresses % 2) {
            word = [self addHashtagToWord:word];
        }
        [newText appendString:word];
        [newText appendString:@" "];
    }
    // strip trailing space
    newText = [newText substringToIndex:(newText.length - 1)];
    self.textView1.text = newText;
    
    [self updateCount];


// block version
//    [wordsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop)
//    {
//        NSString *word = (NSString *)obj;
//        if (index % 2 == 0) {
//            // even
//            NSLog(@"even: %@", word);
//        } else {
//            // odd
//            NSLog(@"odd: %@", word);
//        }
//    }];
}

- (NSString *)addHashtagToWord:(NSString *)word
{
    if ([word containsString:@"#"]) {
        return word;
    } else {
        return [NSString stringWithFormat:@"#%@", word];
    }
}


- (NSString *)eachWord:(NSString *)sentence applyFilter:(NSString * (^)(NSString *))filterBlock
{
    NSMutableString *ret = [NSMutableString new];
    
    NSArray *wordsArray = [sentence componentsSeparatedByString: @" "];
    for (int i = 0; i < wordsArray.count; i++) {
        NSString *word = wordsArray[i];
        // apply filter
        word = filterBlock(word);
        // reconstitute sentence
        [ret appendString:word];
        [ret appendString:@" "];
    }
    // strip trailing space
    ret = [ret substringToIndex:(ret.length - 1)];
    return ret;
}


#pragma mark -
#pragma mark ReverseButton


- (IBAction)onReverseButtonPressed:(UIButton *)sender {
    NSString *oldText = self.textView1.text;
    NSMutableString *newText = [NSMutableString new];
    
    NSArray *wordsArray = [oldText componentsSeparatedByString: @" "];
    for (int i = 0; i < wordsArray.count; i++) {
        NSString *word = wordsArray[i];
        // if contains hashtag, do not change
        // if no hashtag, reverse letters
        if (![word containsString:@"#"]) {
            word = [self reverseWord:word];
        }
        [newText appendString:word];
        [newText appendString:@" "];
    }
    
    // strip out trailing space
    newText = [newText substringToIndex:(newText.length - 1)];
    self.textView1.text = newText;
}

- (NSString *)reverseWord:(NSString *)oldWord
{
    NSMutableString *newWord = [NSMutableString new];
    for (int i = 0; i < oldWord.length; i++) {
        char c = [oldWord characterAtIndex:oldWord.length-1-i];
        [newWord appendFormat:@"%c", c];
    }
    return newWord;
}



@end
