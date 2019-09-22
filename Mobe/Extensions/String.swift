//
//  String.swift
//  Ebooks
//
//  Created by Renan Kosicki on 13/02/19.
//  Copyright © 2019 Gold360. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
	/// Replaces the base font (typically Times) with the given font, while preserving traits like bold and italic
	func setBaseFont(baseFont: UIFont, preserveFontSizes: Bool = true) {
		let baseDescriptor = baseFont.fontDescriptor
		let wholeRange = NSRange(location: 0, length: length)
		beginEditing()
		enumerateAttribute(.font, in: wholeRange, options: []) { object, range, _ in
			guard let font = object as? UIFont else { return }
			// Instantiate a font with our base font's family, but with the current range's traits
			let traits = font.fontDescriptor.symbolicTraits
			guard let descriptor = baseDescriptor.withSymbolicTraits(traits) else { return }
			let newSize = preserveFontSizes ? descriptor.pointSize : baseDescriptor.pointSize
			let newFont = UIFont(descriptor: descriptor, size: newSize)
			self.removeAttribute(.font, range: range)
			self.addAttribute(.font, value: newFont, range: range)
		}
		endEditing()
	}
}

extension String {
	subscript (i: Int) -> Character {
		return self[self.index(self.startIndex, offsetBy: i)]
	}
	
	subscript (i: Int) -> String {
		return String(self[i] as Character)
	}
	
	subscript (r: Range<Int>) -> String {
		let start = index(startIndex, offsetBy: r.lowerBound)
		let end = index(start, offsetBy: r.upperBound - r.lowerBound)
		return String(self[(start ..< end)])
	}
    
  var localized: String {
    return NSLocalizedString(self, comment:"")
  }
  
  func capitalizeFirstLetter() -> String {
    return prefix(1).capitalized + dropFirst()
  }
  
	func withBoldText(boldPartsOfString: [String], font: UIFont!, boldFont: UIFont!) -> NSAttributedString {
		let nonBoldFontAttribute = [NSAttributedString.Key.font:font!]
		let boldFontAttribute = [NSAttributedString.Key.font:boldFont!]
		let boldString = NSMutableAttributedString(string: self as String, attributes:nonBoldFontAttribute)
		for i in 0 ..< boldPartsOfString.count {
			boldString.addAttributes(boldFontAttribute, range: (self as NSString).range(of: boldPartsOfString[i] as String))
		}
		return boldString
	}
	
	func height(withConstrainedWidth width: CGFloat, font: UIFont, insets: UIEdgeInsets) -> CGFloat {
		let constraintRect = CGSize(width: width - insets.left - insets.right, height: .greatestFiniteMagnitude)
		let boundingBox = self.boundingRect(with: constraintRect, options: [.usesFontLeading, .usesLineFragmentOrigin], attributes: [.font: font], context: nil)
		
		return ceil(boundingBox.height) + insets.top + insets.bottom
	}
	
	func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
		let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
		let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
		
		return ceil(boundingBox.width)
	}
	
	var htmlToAttributedString: NSMutableAttributedString? {
		guard let data = data(using: .utf8) else { return NSMutableAttributedString() }
		do {
			return try NSMutableAttributedString(data: data, options: [
				.documentType: NSAttributedString.DocumentType.html,
				.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
		} catch {
			return NSMutableAttributedString()
		}
	}
	
	var htmlToString: String {
		return htmlToAttributedString?.string ?? ""
	}
	
	func isValidEmail() -> Bool {
		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		
		let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailTest.evaluate(with: self)
	}
	
	func isValidPhone() -> Bool {
//    let regularExpressionForPhone = "^\\d{11}$"
    let regularExpressionForPhone = "^[1-9]{2}9[0-9]{8}$"
		let testPhone = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPhone)
		return testPhone.evaluate(with: self)
	}
	
	func isValidCPF() -> Bool {
		let numbers = compactMap({ Int(String($0)) })
		guard numbers.count == 11 && Set(numbers).count != 1 else { return false }
		func digitCalculator(_ slice: ArraySlice<Int>) -> Int {
			var number = slice.count + 2
			let digit = 11 - slice.reduce(into: 0) {
				number -= 1
				$0 += $1 * number
				} % 11
			return digit > 9 ? 0 : digit
		}
		let dv1 = digitCalculator(numbers.prefix(9))
		let dv2 = digitCalculator(numbers.prefix(10))
		return dv1 == numbers[9] && dv2 == numbers[10]
	}
	
	func isValidName() -> Bool {
		let components = self.components(separatedBy: " ")
		if components.count > 1 {
			if components[1] == "" {
				return false
			}
			return true
		}
		return false
	}

}
