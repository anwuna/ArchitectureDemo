//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-18.
//

import UIKit

public extension UIFont {

    /// Returns a font object that is the same as the font, but has the specified weight.
    /// - Parameter weight: The desired weight of the new font object.
    /// - Returns: A font object of the specified weight. See [UIFont.Weight](https://developer.apple.com/documentation/uikit/uifont/textstyle) for recognized values.
    func withWeight(_ weight: UIFont.Weight) -> UIFont {
        let newDescriptor = fontDescriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: weight]])
        return UIFont(descriptor: newDescriptor, size: pointSize)
    }

    /// Returns a font object that is the same as the font, but has the specified traits.
    /// - Parameter traits: The desired traits of the new font object. These traits would override any matching traits on the font.
    /// - Returns: A font object of the specified SymbolicTraits. See [UIFontDescriptor.SymbolicTraits](https://developer.apple.com/documentation/uikit/uifontdescriptor/symbolictraitse) for recognized values.
    func with(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let newDescriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits).union(fontDescriptor.symbolicTraits)) else {
            return self
        }
        return UIFont(descriptor: newDescriptor, size: pointSize)
    }

    /// Returns a font object that is the same as the font, removing the secified traits.
    /// - Parameter traits: The traits to remove.
    /// - Returns: A font object with the specified SymbolicTraits removed. See [UIFontDescriptor.SymbolicTraits](https://developer.apple.com/documentation/uikit/uifontdescriptor/symbolictraitse) for recognized values.
    func without(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        guard let newDescriptor = fontDescriptor.withSymbolicTraits(fontDescriptor.symbolicTraits.subtracting(UIFontDescriptor.SymbolicTraits(traits))) else {
            return self
        }
        return UIFont(descriptor: newDescriptor, size: pointSize)
    }

    /// Returns a font object that is the same as the font but with italic trait.
    var italic: UIFont {
        return with(.traitItalic)
    }
}
