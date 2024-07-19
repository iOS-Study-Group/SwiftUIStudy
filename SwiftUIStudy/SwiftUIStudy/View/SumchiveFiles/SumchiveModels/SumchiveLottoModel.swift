//
//  SumchiveLottoModel.swift
//  SwiftUIStudy
//
//  Created by 김수민 on 7/16/24.
//

import Foundation

struct LottoModel {
    static func makeUserLotto() -> [Int] {
        var randomLotto = Set<Int>()
        
        repeat {
            randomLotto.insert(Int.random(in: 1...45))
        } while randomLotto.count < 6
        
        return randomLotto.sorted()
    }
    
    static func makeAnswerLotto() -> [Int] {
        var randomLotto = Set<Int>()
        
        repeat {
            randomLotto.insert(Int.random(in: 1...45))
        } while randomLotto.count < 7
        
        return randomLotto.sorted()
    }
    
    static func checkRank(_ userNumbers: [Int], with answerNumbers: [Int]) -> String? {
        var count: Int = 0
        
        for number in userNumbers {
            if answerNumbers.dropLast().contains(number) {
                count += 1
            }
        }
        if count == 6 {
            return "1등"
        } else if count == 5 {
            if userNumbers.contains(answerNumbers[6]) {
                return "2등"
            } else {
                return "3등"
            }
        } else if count == 4 {
            return "4등"
        } else if count == 3 {
            return "5등"
        } else {
            return "꽝"
        }
    }
}
