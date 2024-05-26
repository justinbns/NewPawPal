//
//  DogTypeModel.swift
//  NewPawPal
//
//  Created by Justin Jefferson on 26/05/24.
//


//
//  DogTypeModel.swift
//  NewPawPal
//
//  Created by Justin Jefferson on 26/05/24.
//

import SwiftUI
import CoreML
import Vision

class DogTypeModel: ObservableObject {
    @Published var detectedDogType: String?
    @Published var showAlert: Bool = false
    @Published var showImage: Bool = false // New state to show the image sheet
    @Published var scanningEnabled: Bool = true // Flag to control scanning
    @Published var showDogDetailsPage: Bool = false // Flag to control showing dog details page

    func updateDogType(dogType: String, confidence: Double) {
        detectedDogType = dogType
        if confidence > 0.8 {
            showImage = true
            scanningEnabled = false // Stop scanning
            showDogDetailsPage = true // Show dog details page
        } else {
            showAlert = true
        }
    }

    func detectDogType(from image: UIImage) {
        guard let ciImage = CIImage(image: image) else { return }

        let model = try! VNCoreMLModel(for: DogTrainSet().model)
        let request = VNCoreMLRequest(model: model) { [weak self] request, error in
            guard let results = request.results as? [VNClassificationObservation], let topResult = results.first else { return }

            DispatchQueue.main.async {
                self?.updateDogType(dogType: topResult.identifier, confidence: Double(topResult.confidence))
            }
        }

        let handler = VNImageRequestHandler(ciImage: ciImage, options: [:])
        try? handler.perform([request])
    }

    func resumeScanning() {
        scanningEnabled = true
        showDogDetailsPage = false // Hide dog details page
    }

    func getDogImage() -> Image {
        guard let dogType = detectedDogType else { return Image(systemName: "questionmark.circle") }
        return Image(dogType) // Use the detected dog type directly to fetch the image
    }

    func getDogDescription() -> String {
        switch detectedDogType {
        case "Hound":
            return "A hound dog is an independent individual, guided by its own instincts rather than following commands from its owner. This independence makes many hound dogs more tolerant of short-term owner absences compared to other types, provided they are gradually accustomed to being home alone for periods."
        case "Herding":
            return "Herding breeds are primarily focused on guarding livestock, but they are also great at protecting and serving humans in various ways. These breeds are intelligent and energetic, making them excellent family pets. Even the smaller breeds are strong and muscular, with a proud stance. These dogs understand subtle hand signals and whistle commands to guide a flock or find stray animals."
        case "Toy":
            return "Toy breeds are bundles of energy! These dogs are affectionate, sociable, and adaptable to various lifestyles. Don't be deceived by their size and charming looks! They are smart, energetic, and many possess strong protective instincts. Toy dogs are popular among city dwellers because they are perfect for apartment living and make excellent lap warmers on chilly nights."
        case "Terrier":
            return "Terriers are often associated with their feisty and energetic nature. Originally bred to hunt, eliminate vermin, and guard homes or barns, Terriers range in size from the smaller Norfolk, Cairn, and West Highland White Terriers to the larger and majestic Airedale Terrier. Prospective owners should be aware that while Terriers make excellent pets, they require a determined owner due to their stubbornness, high energy levels, and the need for special grooming, known as 'stripping,' to maintain their distinctive appearance."
        case "Working":
            return "These dogs are known for their quick learning ability, intelligence, strength, watchfulness, and alertness. Originally trained to aid humans, they excel in tasks like property guarding, sled pulling, and water rescues. While they make excellent companions, their size and protective nature require prospective owners to be knowledgeable in proper training and socialization. Some breeds in this group may not be suitable for first-time dog owners."
        case "Sporting":
            return "Naturally active and alert, Sporting dogs are friendly and versatile companions. Initially trained to work alongside hunters in locating and retrieving game, these dogs are divided into four main categories: spaniels, pointers, retrievers, and setters. Known for their excellent instincts in water and woodland settings, many Sporting dogs thrive in hunting and field activities. In particular, water-retrieving breeds possess well-insulated, water-repellent coats that are highly resilient to harsh weather."
        case "Non-Sporting":
            return "Non-Sporting dogs are known for their diverse range of breeds with various sizes, coats, personalities, and overall appearances. Due to their varied backgrounds, it is challenging to generalize about this group. From the robust Chow Chow to the compact French Bulldog and the foxlike Keeshond, the differences in their characteristics are significant. Many of these breeds make excellent watchdogs and house pets. Other members of this group include the well-known Dalmatian, Poodle, and Lhasa Apso, as well as the less common Schipperke and Tibetan Spaniel."
        default:
            return "Unknown dog type."
        }
    }
}

extension DogTypeModel {
    func getBestEnvironment() -> String {
        switch detectedDogType {
        case "Hound":
            return "Hounds are hunting dogs that have strong instinct. Hounds need environment where they can explore and exercise their legs. This type of dogs benefit from regular walks and activities that cater to their hunting instincts."
        case "Herding":
            return "Herding dogs thrive in environments with lots of space to run and plenty of stimulation. They do well in rural or suburban settings with large yards or access to parks where they can exercise. They also benefit from tasks or activities like agility training, herding trials, and obedience training to keep them mentally engaged."
        case "Toy":
            return "Toy dogs are well-suited for apartment or city living due to their small size. They require less space but they still need regular exercise. Short walks and indoor play can help. They also enjoy socializing and being close to their owners."
        case "Terrier":
            return "Terriers are energetic and often have a strong prey drive. They do well in both urban and suburban environments but need secure yards where they can dig and play. Regular walks and playtime are crucial, they need activities with their owner to channel their energy."
        case "Working":
            return "Working dogs are typically strong, intelligent, and energetic. They are best suited for homes with large yards or rural areas. These dogs often excel in environments where they have a job to do, such as guarding, pulling sleds, or other physical activities. They need regular exercise and mental challenges to stay in a good shape."
        case "Sporting":
            return "Sporting dogs are active and enjoy environments with various opportunities for exercise, such as homes with large yards, rural areas, or homes with water activities. They excel in activities like fetching, swimming, and hunting. Regular physical activity and mental stimulation are mandatory to keep them in a good shape."
        case "Non-Sporting":
            return "The non-sporting group is diverse, the best environment can vary widely. Generally, these dogs can adapt to various living situations, from apartments to homes with yards. But, they need regular exercise. For example, Bulldogs might be content with moderate exercise, while Dalmatians require more vigorous activity."
        default:
            return "Unknown dog type."
        }
    }

    func getGroomingTips() -> String {
        switch detectedDogType {
        case "Hound":
            return "hound dog usually have low maintenance groom, brush their short, dense coat weekly with a bristle brush or grooming mitt to remove loose hair and distribute natural oils. Bathe them every 4-6 weeks and don't forget to clean their long, floppy ears weekly with a vet-recommended ear cleaner to prevent infections. Trim their nails every 3-4 weeks with a dog nail clipper or grinder, and brush their teeth several times a week with a dog-specific toothbrush and toothpaste. Regularly check their skin for irritation or parasites and consult a vet for persistent issues. Make sure they have a balanced diet and plenty of exercise to contribute to their overall well-being and a healthy coat."
        case "Herding":
            return "Brushing your dogs coat is the single most important key in maintaining their coat and keeping their skin healthy and the body comfortable. Shedding coat removed not only stimulates the skin to keep it healthy but also allows the coat to properly protect the dog from the weather. A properly brushed coat insulates from both heat and cold by holding a layer of temperate air close to the body while keeping high heat or cold on the outer surface of the coat.  Leaving the undercoat in prevents this process as it eliminates room for temperate air to be held."
        case "Toy":
            return "Playing with them for 15 to 20 minutes before grooming or scheduling grooming after a day at doggy day care can help tire them out. Start brushing from the head towards the tail and down the legs, always following the direction of where the hair growth, except when fluffing the fur for specific breeds, where you should comb in the opposite direction. De-shedding improves your dog’s appearance and comfort while keeping fur off furniture, using a comb like the Li’l Pals Shedding Comb from the head to the tail, behind the ears, base of the tail, under the legs, nape of the neck, and abdomen until loose hair is removed. Maintain a smooth coat with a bristle brush, starting from the head and working towards the tail and legs with long strokes to distribute natural oils."
        case "Terrier":
            return "Terrier breeds are natural hunters. Thick, wiry coats were designed protect them while they hunt, dig, or chase through bush and forested areas. Wiry coats that require regular brushing and professional grooming known as 'stripping' to maintain their appearance. When hand stripping a dog, remember to pull in the direction of hair growth while supporting the skin with gentle pressure. Focus on plucking the longer hairs, usually about 2-5 cm in length, and use finger cots or chalk powder for better grip. Maintain a steady rhythm, removing only a few hairs at a time. Avoid using a stripping knife too forcefully."
        case "Working":
            return "Working dogs may have dense coats that need regular brushing to keep them clean and healthy. Generally, this breed doen't need to be shaved. Weekly brushing to remove loose fur and distribute natural oils. Bathing every 6-8 weeks and regular ear checks and nail trimming every 3-4 weeks."
        case "Sporting":
            return "Sporting dogs need regular brushing 2-3 times a week to manage shedding and prevent mats. Bathing every 6-8 weeks or more often if they swim frequently. Weekly ear cleaning and nail trimming every 3-4 weeks."
        case "Non-Sporting":
            return "The diversity of this group extends to their coat types as well. Non-sporting dogs can have short, long, curly, or straight coats, each requiring different levels of grooming. Dogs with curly coats require regular grooming to avoid matting, while those with short coats are low maintenance."
        default:
            return "Unknown dog type."
        }
    }
}


