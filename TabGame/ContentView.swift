//
//  ContentView.swift
//  TabGame
//
//  Created by Maraj Hussain on 03/03/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var timer = Timer.publish(every: GameLevel.easy.rawValue, on: .main, in: .common).autoconnect()
    @State private var currentImageIndex = 0
    @State private var score = 0
    @State private var targetIndex = 1
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showAlert = false
    @State private var selectedGameLavel: GameLevel = .easy
    @State private var isGameRunnig = true
    var gameImages = ["apple", "egg", "dog"]
    // generate randome image
    var randomIndex:Int {
        return Int.random(in: 0..<gameImages.count)
    }
    
    enum GameLevel: Double {
        case easy = 1, medium = 0.75, hard = 0.5
        
        var title : String {
            switch self {
            case .easy:
                return "Easy"
            case .medium:
                return "Medium"
            case .hard:
                return "Hard"
            }
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                if !isGameRunnig {
                    Menu("Game Difficulty: \(selectedGameLavel.title)", content: {
                        Button(GameLevel.easy.title) {
                            selectedGameLavel = .easy
                        }
                        Button(GameLevel.medium.title) {
                            selectedGameLavel = .medium
                        }
                        Button(GameLevel.hard.title) {
                            selectedGameLavel = .hard
                        }
                    }).font(.system(size: 20, weight: .semibold))
                }
                Spacer()
                Text("Score: \(score)")
                    .font(.system(size: 20, weight: .semibold))
            }.padding(.horizontal)
            Image(gameImages[currentImageIndex])
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 300)
                .onTapGesture {
                    // Stop the timer
                    timer.upstream.connect().cancel()
                    isGameRunnig = false
                    if currentImageIndex == targetIndex {
                        score = score + 1
                        alertTitle = "Success"
                        alertMessage = "you slected the correct image"
                    } else {
                        alertTitle = "Failure"
                        alertMessage = "You slect the wrong image"
                    }
                    showAlert = true
                }
            Text(gameImages[targetIndex])
                .font(.title)
                .padding(.top)
            
                Button("Restart Game", action: {
                    if !isGameRunnig {
                        isGameRunnig = true
                        targetIndex = randomIndex
                        timer = Timer.publish(every: selectedGameLavel.rawValue, on: .main, in: .common).autoconnect()
                    }
                })
                .foregroundColor(.red)
                .font(.system(size: 24))
                .opacity(isGameRunnig ? 0.5 : 1)
                .padding(.top)

        }
        .onReceive(timer) { _ in
            manageImageIndex()
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("Ok", action: {
                
            })
        } message: {
            Text(alertMessage)
        }

    }
    
    func manageImageIndex() {
        currentImageIndex = currentImageIndex + 1
        if currentImageIndex > 2 {
            currentImageIndex = 0
        }
    }
}

#Preview {
    ContentView()
}
