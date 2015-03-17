//
//  main.m
//  justextutil
//
//  Created by Nikola Sobadjiev on 2/1/15.
//  Copyright (c) 2015 Nikola Sobadjiev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TextExractor.h"
#import "pcre.h"
#import "pcrecpp.h"
#import "justext.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        if (argc != 3)
        {
            NSLog(@"Usage: justtextutil <stop_words_file> <file>");
            return 0;
        }
        NSString* stopWordsFile = [NSString stringWithCString:argv[1]
                                                     encoding:NSUTF8StringEncoding];
        const char* stopWordsCString = [stopWordsFile cStringUsingEncoding:NSUTF8StringEncoding];
        std::string stopWords = std::string(stopWordsCString);
        NSString* urlString = [NSString stringWithCString:argv[2]
                                                encoding:NSUTF8StringEncoding];
        NSURL* url = [NSURL URLWithString:urlString];
        NSError* downloadError = nil;
        NSString* fileContents = [NSString stringWithContentsOfURL:url
                                                          encoding:NSUTF8StringEncoding
                                                             error:&downloadError];
//        if (fileContents != nil && downloadError == nil)
//        {
//            TextExractor* extractor = [[TextExractor alloc] initWithHtml:fileContents
//                                                           stopWordsFile:stopWordsFile];
//            NSLog(@"Extracted article:\n%@", [extractor extractedText]);
//        }
//        else
//        {
//            NSLog(@"Failed to load contents: %@", downloadError.localizedDescription);
//        }
        
        Justext *justText = new Justext(stopWords);
        justText->setDebug(false);
        
        const char* htmlCString = [fileContents cStringUsingEncoding:NSUTF8StringEncoding];
        std::string htmlStdString = std::string(htmlCString);
        std::string htmlEncoding = std::string("UTF-8");
        std::string htmlUrl = std::string("");
        std::string resultText = justText->getContent(htmlStdString, htmlEncoding, htmlUrl);
        NSString *extractedText = [NSString stringWithCString:resultText.c_str() 
                                                     encoding:NSUTF8StringEncoding];
        NSLog(@"%@", extractedText);
    }
    return 0;
}
