//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-17.
//

import Foundation

public enum ItemType: String, Codable, Hashable {
    case cover = "cover"
    case empty = ""
    case interiorStory = "interiorStory"
    case pinup1 = "pinup"
    case recap
    case ad
    case backcovers
    case profile
    case article
    case pinup2 = "pin-up"
    case letters
    case textArticle = "text article"
    case textFeature = "text feature"
    case promo
    case mysteryStory = "mystery story"
    case textStory = "text story"
    case tableOfContents = "table of contents"
    case credits
}
