//
//  main.swift
//  TestingAbly
//
//  Created by Chibundu Anwuna on 2022-12-19.
//

import Foundation
import Ably

let key = "alX-8Q.2FH0rQ:JbdjA7lmrGv0kepNzCLvKRIfA0hYiO1X8Pua8pPq3z8"

let client = ARTRealtime(key: key)
client.connection.on { stateChange in
    switch stateChange.current {
    case .connected:
        print("connected")
    case .failed:
        print("failed! \(stateChange.reason)")
    default:
        print("Other: \(stateChange.current)")
    }
}

let channel = client.channels.get("Marvelous")
channel.subscribe { message in
    print(message.name)
    print(message.data)
}

RunLoop.main.run()
