//
//  DetailView.swift
//  NewPawPal
//
//  Created by Justin Jefferson on 26/05/24.
//

import SwiftUI

struct DetailView: View {
    @ObservedObject var viewModel: DogTypeModel
    let detectedDogType: String
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        VStack {
            ZStack(alignment: .top) {
                Image(detectedDogType)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: UIScreen.main.bounds.width * 1152 / 1668)
                    .clipped()
                
                Text("PawPal")
                    .font(.custom("Chalkduster", size: 34))
                    .foregroundColor(Color(hex: "FEB941"))
                    .padding(.top, 16)
                
                HStack {
                    Button(action: {
                        viewModel.resumeScanning()
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .foregroundColor(Color(hex: "FEB941"))
                            Text("Back")
                                .foregroundColor(Color(hex: "FEB941"))
                        }
                        .padding()
                    }
                    Spacer()
                }
            }
            
            ScrollView {  //Scrollview agar bisa discroll (tidak menampilkan informasi hanya setengah)
                VStack(alignment: .leading) {
                    Text(detectedDogType)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "6DC5D1"))
                    
                    HStack {
                        Text(getSubTitle(for: detectedDogType))
                        Spacer()
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    
                    Divider()
                    
                    Text("About \(detectedDogType)")
                        .font(.title2)
                        .foregroundColor(Color(hex: "6DC5D1"))
                    Text(viewModel.getDogDescription())
                    
                    Text("Best Environment")
                        .font(.title2)
                        .foregroundColor(Color(hex: "6DC5D1"))
                        .padding(.top, 16)
                    Text(viewModel.getBestEnvironment())
                    
                    Text("Grooming Tips")
                        .font(.title2)
                        .foregroundColor(Color(hex: "6DC5D1"))
                        .padding(.top, 16)
                    Text(viewModel.getGroomingTips())
                }
                .padding()
            }
            
            Spacer()
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }

    func getSubTitle(for dogType: String) -> String {
        switch dogType {
        case "Hound":
            return "Hunting Pal"
        case "Herding":
            return "Livestock Guardian"
        case "Sporting":
            return "Active Companion"
        case "Non-Sporting":
            return "Chill Furball"
        case "Toy":
            return "Energetic Buddies"
        case "Working":
            return "Incredible Wingman"
        case "Terrier":
            return "Feisty Friend"
        default:
            return "Unknown Category"
        }
    }
}

struct DetailViewPreviews: PreviewProvider {
    static var previews: some View {
        DetailView(viewModel: DogTypeModel(), detectedDogType: "Hound")
    }
}
