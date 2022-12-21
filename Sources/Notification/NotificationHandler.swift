//
//  File.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-19.
//

import Foundation
import Ably
import SharedModels
import UIKit
import SwiftUI

public final class NotificationHandler {
    enum NotificationError: Error {
        case dateDecodingError
    }

    let key = "alX-8Q.2FH0rQ:JbdjA7lmrGv0kepNzCLvKRIfA0hYiO1X8Pua8pPq3z8"
    let client: ARTRealtime

    public static let shared = NotificationHandler()
    private init() {
        client = ARTRealtime(key: key)
    }

    public func startListening() {
        client.connection.on { stateChange in
            switch stateChange.current {
            case .connected:
                print("connected")
            case .failed:
                print("failed! \(stateChange.reason?.localizedDescription ?? "")")
            default:
                print("Other: \(stateChange.current)")
            }
        }

        let channel = client.channels.get("Marvelous")
        channel.subscribe {[weak self] message in
            self?.onMessageReceived(data: message.data)
        }
    }

    func onMessageReceived(data: Any?) {
        guard let marvelCharacter = decodeData(data: data) else { return }
        guard let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else {
            return
        }
        guard let rootViewController = scene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return
        }
        let incomingCharacterView = IncomingMessageView(character: marvelCharacter)
        let viewController = UIHostingController(rootView: incomingCharacterView)
        viewController.view.backgroundColor = UIColor.clear
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        rootViewController.present(viewController, animated: true)
    }

    func decodeData(data: Any?) -> MarvelCharacter? {
        guard let data = data, let messageDict = data as? NSDictionary else {
            print("bad data") // handle error properly
            return nil
        }

        do {
            let data = try JSONSerialization.data(withJSONObject: messageDict, options: .prettyPrinted)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .custom(customDateDecodingStartegy)
            let result = try decoder.decode(CharacterDataContainer.self, from: data)
            return result.results[0]
        } catch {
            print(error)
        }
        return nil
    }

    //TODO: Move to module. 
    var customDateDecodingStartegy: @Sendable (Decoder) throws -> Date {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        return { (decoder) throws -> Date in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)

            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
            if let date = formatter.date(from: dateStr) {
                return date
            }
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
            if let date = formatter.date(from: dateStr) {
                return date
            }

            throw NotificationError.dateDecodingError
        }
    }
}
