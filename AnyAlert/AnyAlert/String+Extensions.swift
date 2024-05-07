//
//  String+Extensions.swift
//  AnyAlert
//
//  Created by Chris Allinson on 2024-05-03.
//

import UIKit

extension String {
    
    func heightWithConstrainedWidth(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
}
