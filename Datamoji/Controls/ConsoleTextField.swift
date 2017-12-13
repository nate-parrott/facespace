//
//  ConsoleTextField.swift
//  Datamoji
//
//  Created by Nate Parrott on 12/10/17.
//  Copyright © 2017 Nate Parrott. All rights reserved.
//

import UIKit

class ConsoleTextField : UITextView {
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        text = ""
        loop()
    }
    let nLines = 7
    func addLine(_ line: String) {
        letterQueue += line + "\n"
    }
    func addLinesToClearScreen() {
        var i = 0
        while i < nLines {
            i += 1
            addLine("")
        }
    }
    
    var currentString = ""
    var letterQueue = ""
    let letterDelay: TimeInterval = 0.015
    let newLineDelay: TimeInterval = 0.1
    var emptyCallback: (() -> ())?
    
    func loop() {
        var delay: TimeInterval = letterDelay
        if let c = letterQueue.first {
            updateCurrentString(currentString + String(c))
            if c == "\n".first! {
                delay = newLineDelay
            }
            letterQueue.removeFirst()
        } else if let cb = emptyCallback {
            cb()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            [weak self] in
            self?.loop()
        }
    }
    
    func updateCurrentString(_ string: String) {
        var lines = string.components(separatedBy: "\n")
        while lines.count > nLines {
            lines.remove(at: 0)
        }
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.green
        shadow.shadowBlurRadius = 7
        currentString = lines.joined(separator: "\n")
        
        attributedText = NSAttributedString(string: currentString, attributes: [NSAttributedStringKey.foregroundColor: UIColor(red: 0.8, green: 1, blue: 0.9, alpha: 1), NSAttributedStringKey.font: UIFont(name: "VT323", size: 40)!, NSAttributedStringKey.shadow: shadow])
    }
}
