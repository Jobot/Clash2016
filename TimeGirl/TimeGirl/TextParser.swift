//
//  TextParser.swift
//  TimeGirl
//
//  Created by Joseph Dixon on 3/30/16.
//  Copyright © 2016 Joseph W. Dixon. All rights reserved.
//

import Foundation

struct TextParser {
    func parseCommandFromText(text: String) -> Command? {
        let tokens = text.tokenize()
        
        guard tokens.count > 0 else {
            return nil
        }
        
        return Command.commandFromTokens(tokens)
    }
}

extension String {
    func tokenize(separator: String = " ") -> [String] {
        let whitespace = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        let punctuation = NSCharacterSet.punctuationCharacterSet()
        let trimmed = stringByTrimmingCharactersInSet(whitespace).stringByTrimmingCharactersInSet(punctuation)
        
        return trimmed.componentsSeparatedByString(separator).filter { (text) -> Bool in
            let trimmed = text.stringByTrimmingCharactersInSet(whitespace).stringByTrimmingCharactersInSet(punctuation)
            return trimmed.characters.count > 0
        }
    }
}
