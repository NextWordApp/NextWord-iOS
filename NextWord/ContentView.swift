import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel = WordViewModel()
    
    var body: some View {
        ZStack {
            if let imageUrl = viewModel.videoURL {
                AsyncImage(url: imageUrl) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                } placeholder: {
                    Color.gray
                        .edgesIgnoringSafeArea(.all)
                }
            }
            
            VStack {
                if let word = viewModel.currentWord {
                    Text(word.word)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(word.pos)
                        .font(.title2)
                        .padding(.top, 2)
                    
                    Text(word.meaning)
                        .font(.title3)
                        .padding(.top, 2)
                }
                
                if viewModel.isLoading {
                    ProgressView()
                        .padding(.top, 10)
                } else {
                    Text(viewModel.sentence)
                        .font(.title3)
                        .padding(.top, 10)
                    
                    Text(viewModel.translation)
                        .font(.title3)
                        .padding(.top, 2)
                }
                
                Spacer()
                
                Button(action: {
                    viewModel.loadNextWord()
                }) {
                    Text("Next Word")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
        .onAppear {
            viewModel.loadNextWord()
        }
    }
}
