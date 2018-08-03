//  MIT License
//
//  Copyright (c) 2018 Pablo Pallocchi
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the “Software”), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import Foundation

final class OkapiBM25 {
    
    /**
     Calculate the score based on the matchinfo data returned by SQLite.
     
     - Parameters:
        - matchinfo: The matchinfo values
        - column: The column to calculate the score
        - b: The b parameter of Okapi BM25
        - k1: The k1 parameter of Okapi BM25
     
     - Returns: The Okapi BM25 score
     */
    static func score(matchinfo: [UInt32], column: Int, b: Double = 0.75, k1: Double = 1.2) -> Double {
        
        let pOffset = 0
        let cOffset = 1
        let nOffset = 2
        let aOffset = 3
        
        let termCount = Int(matchinfo[pOffset])
        let colCount = Int(matchinfo[cOffset])
        
        let lOffset = aOffset + colCount
        let xOffset = lOffset + colCount
        
        let totalDocs = Double(matchinfo[nOffset])
        let avgLength = Double(matchinfo[aOffset + column])
        let docLength = Double(matchinfo[lOffset + column])
        
        var score = 0.0
        
        for i in 0..<termCount {
            
            let currentX = xOffset + (3 * (column + i * colCount))
            let termFrequency = Double(matchinfo[currentX])
            let docsWithTerm = Double(matchinfo[currentX + 2])
            
            let p = totalDocs - docsWithTerm + 0.5
            let q = docsWithTerm + 0.5
            let idf = log(p/q)
            
            let r = termFrequency * (k1 + 1)
            let s = b * (docLength / avgLength)
            let t = termFrequency + (k1 * (1 - b + s))
            let rightSide = r/t
            
            score += (idf * rightSide);
        }
        
        return score
        
    }
    
}
