//
//  ContentView.swift
//  NewPawPal
//
//  Created by Justin Jefferson on 26/05/24.
//


import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = DogTypeModel()
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?

    var body: some View {
        NavigationView {
            VStack {
                Text("PawPal")
                    .font(.custom("Chalkduster", size: 48))
                    .fontWeight(.bold)
                    .padding()

                Image("newdoglogo") // Ensure "newdoglogo" is correctly named in Assets
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)

                HStack {
                    NavigationLink(destination: CameraView(viewModel: viewModel)) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "FEB941"))
                                .frame(width: 80, height: 80)

                            Image(systemName: "camera")
                                .foregroundColor(.white)
                                .font(.system(size: 40))
                        }
                    }

                    Spacer().frame(width: 100) // Add space between the buttons

                    Button(action: {
                        showImagePicker = true
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color(hex: "FEB941"))
                                .frame(width: 80, height: 80)

                            Image(systemName: "photo")
                                .foregroundColor(.white)
                                .font(.system(size: 40))
                        }
                    }
                }
                .padding()
            }
            .fullScreenCover(isPresented: $viewModel.showDogDetailsPage) {
                if let detectedDogType = viewModel.detectedDogType {
                    DetailView(viewModel: viewModel, detectedDogType: detectedDogType)
                }
            }
            .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Force single column navigation
    }

    func loadImage() {
        guard let inputImage = inputImage else { return }
        // Call a method in your viewModel to detect the dog type from the selected image
        viewModel.detectDogType(from: inputImage)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

