# TabGame

`TabGame` is a simple SwiftUI-based game where the user must tap the correct image that matches the target image displayed. The game provides different difficulty levels (Easy, Medium, and Hard) and tracks the user's score.

## Features:
- **Game Difficulty Levels**: Choose between Easy, Medium, and Hard levels. The timer interval changes depending on the selected level.
- **Randomized Images**: The game randomly shows one of three images. The player must tap the correct image based on the target image displayed.
- **Timer**: The timer runs out after a fixed time (depends on the difficulty level), and the game ends, showing whether the player selected the correct image.
- **Score Tracking**: The player's score is updated based on the number of correct guesses.
- **Game Restart**: Players can restart the game after each round.

## Game Levels:
- **Easy**: Timer interval of 1 second.
- **Medium**: Timer interval of 0.75 seconds.
- **Hard**: Timer interval of 0.5 seconds.

## SwiftUI Components Used:
- `Timer.publish` for the countdown timer.
- `Image` for displaying random game images.
- `Text` for displaying score, target image name, and alerts.
- `Button` for restarting the game.
- `Alert` to show success or failure messages based on the user's selection.
- `Menu` for selecting the game difficulty.

## Preview:

```swift
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
    
    var randomIndex: Int {
        return Int.random(in: 0..<gameImages.count)
    }
    
    enum GameLevel: Double {
        case easy = 1, medium = 0.75, hard = 0.5
        
        var title: String {
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
                    timer.upstream.connect().cancel()
                    isGameRunnig = false
                    if currentImageIndex == targetIndex {
                        score = score + 1
                        alertTitle = "Success"
                        alertMessage = "You selected the correct image."
                    } else {
                        alertTitle = "Failure"
                        alertMessage = "You selected the wrong image."
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
            Button("Ok", action: {})
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
```
## How to Use:
1. Clone this repository or copy the code into your Xcode project.
2. Add the ContentView.swift file to your project.
3. Run the app in the Xcode simulator or on a physical device.
4. Select the difficulty level (Easy, Medium, or Hard).
5. Tap the image displayed to try and match it with the target image.
6. The game will show an alert indicating whether your selection was correct or incorrect.
7. You can restart the game at any time using the "Restart Game" button.

## Customization:
You can add more images to the gameImages array to make the game more varied.
You can also adjust the difficulty levels by changing the timer intervals or adding additional levels.
