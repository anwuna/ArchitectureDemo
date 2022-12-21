//
//  SwiftUIView.swift
//  
//
//  Created by Chibundu Anwuna on 2022-12-19.
//

import SwiftUI
import SharedModels

struct IncomingMessageView: View {
    let character: MarvelCharacter
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            Color
                .black
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)

            VStack {
                VStack(spacing: 50) {
                    HStack {
                        Spacer()
                        Text("🚨 Incoming 🚨")
                            .font(.body)
                        Spacer()
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "xmark")
                                .tint(.black)
                        }
                    }
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            AsyncImage(url: URL(string: character.thumbnail.url)!) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .cornerRadius(25)
                                    .frame(maxWidth: 50, maxHeight: 50)
                            } placeholder: {
                                ProgressView()
                            }
                            Text(character.name)
                                .font(.title)
                        }
                        HStack {
                            Text(character.description)
                        }
                    }
                }
                .padding(25)
                .background(.white)
                .cornerRadius(15)
            }
            .padding(35)
        }

    }
}

#if DEBUG
import Mocks

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        let character = MockProvider.sampleCharacters().randomElement()!
        IncomingMessageView(character: character)
    }
}

#endif
