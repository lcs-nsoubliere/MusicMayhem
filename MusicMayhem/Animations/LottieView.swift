//
//  CorrectAnimation.swift
//  MusicMayhem
//
//  Created by Noah Alexandre Soubliere on 2022-05-12.
//
//


import UIKit
import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {

    @State var animationNamed: String

    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        
        let view = UIView(frame: .zero)
        
        // Lottie View
        let animationView = AnimationView()
        let animation = Animation.named(animationNamed)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        
        // Constraints
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor),
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        return view
        
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        
    }
    
    typealias UIViewType = UIView
    
    struct LottieView_Previews: PreviewProvider {
        static var previews: some View {
            LottieView(animationNamed: "Guitar")
        }
    }
}

































