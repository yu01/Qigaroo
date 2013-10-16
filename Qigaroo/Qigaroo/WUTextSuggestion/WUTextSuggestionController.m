//
//  WUTextSuggestionControl.m
//  WeicoUI
//
//  Created by YuAo on 5/8/13.
//  Copyright (c) 2013 微酷奥(北京)科技有限公司. All rights reserved.
//

#import "WUTextSuggestionController.h"
#import <objc/runtime.h>

NSString * const WUTextSuggestionControllerTextInputSelectedTextRangePropertyKey = @"selectedTextRange";
NSString * const WUTextSuggestionControllerTextInputTextPropertyKey = @"text";

@interface WUTextSuggestionController ()

@property (nonatomic,weak,readwrite)          UITextView *textView;

@property (nonatomic,strong)                  NSRegularExpression *textCheckingRegularExpression;

@property (nonatomic,readwrite,getter = isSuggesting) BOOL      suggesting;
@property (nonatomic,readwrite)                       NSRange   suggestionRange;

@property (nonatomic) BOOL observingSelectedTextRange;
@property (nonatomic) BOOL observingTextInputText;

@end

@implementation WUTextSuggestionController

- (id)initWithTextView:(UITextView *)textView {
    if (self = [super init]) {
        NSParameterAssert(textView);
        self.textView = textView;

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged) name:UITextViewTextDidChangeNotification object:self.textView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidBeginEditing:) name:UITextViewTextDidBeginEditingNotification object:self.textView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidEndEditing:) name:UITextViewTextDidEndEditingNotification object:self.textView];
        
        self.textView.textSuggestionController = self;
    }
    return self;
}

- (void)dealloc {
    self.observingSelectedTextRange = NO;
    self.observingTextInputText = NO;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setSuggesting:(BOOL)suggesting {
    if (_suggesting != suggesting) {
        _suggesting = suggesting;
        if (suggesting) {
            if (self.shouldBeginSuggestingBlock) {
                self.shouldBeginSuggestingBlock();
            }
        } else {
            if (self.shouldEndSuggestingBlock) {
                self.shouldEndSuggestingBlock();
            }
        }
    }
}

- (void)setObservingSelectedTextRange:(BOOL)observingSelectedTextRange {
    if (_observingSelectedTextRange != observingSelectedTextRange) {
        _observingSelectedTextRange = observingSelectedTextRange;
        if (observingSelectedTextRange) {
            [self.textView addObserver:self forKeyPath:WUTextSuggestionControllerTextInputSelectedTextRangePropertyKey options:NSKeyValueObservingOptionNew context:NULL];
        } else {
            [self.textView removeObserver:self forKeyPath:WUTextSuggestionControllerTextInputSelectedTextRangePropertyKey];
        }
    }
}

- (void)setObservingTextInputText:(BOOL)observingTextInputText {
    if (_observingTextInputText != observingTextInputText) {
        _observingTextInputText = observingTextInputText;
        if (observingTextInputText) {
            [self.textView addObserver:self forKeyPath:WUTextSuggestionControllerTextInputTextPropertyKey options:NSKeyValueObservingOptionNew context:NULL];
        } else {
            [self.textView removeObserver:self forKeyPath:WUTextSuggestionControllerTextInputTextPropertyKey];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.textView && ([keyPath isEqualToString:WUTextSuggestionControllerTextInputSelectedTextRangePropertyKey] || [keyPath isEqualToString:WUTextSuggestionControllerTextInputTextPropertyKey])) {
        [self textChanged];
    }
}

- (void)textViewDidBeginEditing:(NSNotification *)notification {
    self.observingSelectedTextRange = YES;
    self.observingTextInputText = YES;
    [self textChanged];
}

- (void)textViewDidEndEditing:(NSNotification *)notification {
    self.observingSelectedTextRange = NO;
    self.observingTextInputText = NO;
    self.suggesting = NO;
}

- (void)textChanged {
    __block NSString *word = self.textView.text;
    __block NSRange range = NSMakeRange(0, word.length);
    
    
    if (word.length >= 1 && range.location != NSNotFound) {
        NSString *rest = [word substringFromIndex:1];
            self.suggesting = YES;
            self.suggestionRange = NSMakeRange(range.location , range.length - 1);
            if (self.shouldReloadSuggestionsBlock) {
                self.shouldReloadSuggestionsBlock(WUTextSuggestionTypeAt,rest,self.suggestionRange);
            }
        } else {
            self.suggestionRange = NSMakeRange(NSNotFound, 0);
            self.suggesting = NO;
        }
}

@end

NSString * const WUTextSuggestionControllerAssociationKey = @"WUTextSuggestionControllerAssociationKey";

@implementation UITextView (WUTextSuggestionController)

- (void)setTextSuggestionController:(WUTextSuggestionController *)textSuggestionController {
    objc_setAssociatedObject(self, &WUTextSuggestionControllerAssociationKey, textSuggestionController, OBJC_ASSOCIATION_RETAIN);
}

- (WUTextSuggestionController *)textSuggestionController {
    return objc_getAssociatedObject(self, &WUTextSuggestionControllerAssociationKey);
}

@end

