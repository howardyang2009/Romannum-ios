//
//  RomannumCalculator.swift
//  Romannum-IOS
//
//  Created by 杨晗 on 29.08.23.
//

import Foundation

enum MyError: Error {
    case runtimeError(String)
}

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

struct RomannumCalculator {
    var arrayNum:[Int] = [1, 5, 10, 50, 100, 500, 1000]
    var arrayLetter:[Character] = ["I", "V", "X", "L", "C", "D", "M"]
    var numMin:Int = -1
    var numMax:Int = -1
    
    mutating func initialize() {
        self.numMin = 1
        self.numMax = arrayNum[arrayNum.count-1]*4-1; //3999
    }
    
    func _isOdd(num:Int) -> Bool {
        return num % 2 == 1
    }
    
    func _charIndex(c:Character) throws -> Int {
        if let foo = arrayLetter.enumerated().first(where:{$0.element == c}) {
            return foo.offset
        } else {
            var errorInfo:String = "valid letter just could be "
            for elem in arrayLetter {
                errorInfo += String(elem)
            }
            throw MyError.runtimeError(errorInfo)
        }
    }
    
    func _char2num(c:Character) throws -> Int {
        let index:Int = try _charIndex(c:c)
        return arrayNum[index]
    }
    
    func num2str(number:Int) throws -> String {
        var str:String = "", times:Int, num:Int = number
        
        if (num<numMin || num>numMax) {
            throw MyError.runtimeError("number exceed scope ["+String(numMin)+","+String(numMax)+"]")
        }
        
        var i: Int = arrayNum.count-1;
        while (i >= 0) {
            times = Int(num/arrayNum[i]);
            if (times == 4) {
                // for IV XL CD 4 40 400
                str += String(arrayLetter[i]) + String(arrayLetter[i+1])
            } else {
                var j:Int = 0
                while (j < times) {
                    str += String(arrayLetter[i])
                    j += 1
                }
            }
            num -= times * arrayNum[i];
            //for IX VL CM 9 90 900
            if (!_isOdd(num:i) && i != 0) {
                let temp1 : Int = Int((CGFloat(arrayNum[i])*0.9).rounded(.down))
                
                if (num >= temp1) {
                    str += String(arrayLetter[i-2]) + String(arrayLetter[i])
                    num -= temp1;
                }
            }
            
            i -= 1
        }
        return str;
    }
    
    func str2num(inputStr: String) throws -> Int {
        var num:Int, i:Int, currentChar:Character, nextChar:Character, currentCharIndex:Int, nextCharIndex:Int, str:String, temp:String
        
        str = inputStr.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if (str.count <= 0) {
            throw MyError.runtimeError("empty is invalid")
        }
        
        num=0
        i=0
        nextCharIndex = -1
        while (i < str.count) {
            currentChar = str[i]
            currentCharIndex = try _charIndex(c:currentChar);
            if (i < str.count-1) {
                nextChar = str[i+1];
                nextCharIndex = try _charIndex(c:nextChar);
            }
            
            if (currentCharIndex < nextCharIndex) {
                num -= try _char2num(c:currentChar);
            } else {
                num += try _char2num(c:currentChar);
            }
            
            i += 1;
            nextCharIndex = -1;
        }
        
        temp = try num2str(number:num);
        if !(temp == str) {
            throw MyError.runtimeError("non-standard Roman Number")
        }
        
        return num;
    }
}
