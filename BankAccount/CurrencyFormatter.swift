//
//  CurrencyFormatter.swift
//  BankAccount
//
//  Created by Beltrami Dias Batista, Thiago on 18/11/22.
//

import Foundation

class CurrencyFormatter {
    
    func formatDollar(dollarsPart: Double) -> String {
        let dollarsInt = Int(dollarsPart)
        var dollarsString = String(dollarsInt)
        
        var dollarsReversedString = String(dollarsString.reversed())
        var dollarsReversedWithCommasString = dollarsReversedString
        
        var commasQuantity = 0
        for n in 0...dollarsReversedString.count - 1 {
            if n%3 == 0, n != 0, dollarsReversedString[dollarsReversedString.index(dollarsReversedString.startIndex, offsetBy: n + commasQuantity)] != "-" {
                let i = dollarsReversedString.index(dollarsReversedString.startIndex, offsetBy: n + commasQuantity)
                dollarsReversedString.insert(",", at: i)
                commasQuantity += 1
            }
        }
        
        dollarsString = String(dollarsReversedString.reversed())
        
        return dollarsString
    }
}
