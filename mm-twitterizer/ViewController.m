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

- (IBAction)onTwitterizePressed:(UIButton *)sender {
    
    NSString *oldText = self.textView1.text;
    NSString *newText = [self deleteVowels:oldText];
    self.textView1.text = newText;
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
#pragma mark UITextView protocol methods


- (void)textViewDidChange:(UITextView *)textView
{
    // this method fires with every keystroke
    //NSLog(@"textViewDidChange()");

    // set character count
    self.countLabel.text = [NSString stringWithFormat:@"(%lu)", self.textView1.text.length];
}


-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)insertedText
{
    // this method fires with every insertion + every deletion

    // debug
    //NSString *replaced = [self.textView1.text substringWithRange:range];
    //NSLog(@"replacing >%@< with >%@<",replaced, insertedText);
    
    if ([insertedText isEqualToString:@""]) {
        // deletion
    } else {
        // insertion
        if (self.textView1.text.length + insertedText.length > 140) {
            return NO;
        }
    }
    return YES;
}


// addHashtag
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
        // version 2
        //newText2 = [NSString stringWithFormat:@"%@%@ ", newText2, word];
        //NSLog(@"newText = >%@<", newText);
    }
    // strip out trailing space
    newText = [newText substringToIndex:(newText.length - 1)];
    self.textView1.text = newText;

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
- (NSString *)addHashtagToWord:(NSString *)word
{
    if ([word containsString:@"#"]) {
        return word;
    } else {
        return [NSString stringWithFormat:@"#%@", word];
    }
}

// reverseWord


@end
