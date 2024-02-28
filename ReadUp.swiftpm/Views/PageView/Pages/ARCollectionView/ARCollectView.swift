//
//  ARCollectView.swift
//  ReadTracker
//
//  Created by Philipp Ollmann on 25.02.24.
//

import SwiftUI
import RealityKit

struct ARCollectView : View {
    
    let page: CollectionPage
    @EnvironmentObject private var pageViewModel: PageViewModel
    @State private var count = 0
    @State private var showInfo = false
    
    var body: some View {
        
        VStack {
            ARViewContainer(page: page){count += 1 }
        }
        .overlay(alignment: .bottom) {
            HStack {
                
                Spacer()
                
                Text("Collected: \(page.amount)/10 stones")
                    .font(.subtitle2)
                    .foregroundStyle(Color.flixoText)
                    .padding(.vertical, Spacing.spacingL)
                
                Spacer()
            }
            .background(.thinMaterial)
            .sensoryFeedback(.impact, trigger: count)
            .onChange(of: count) {
                if count == 10 {
                    AudioPlayerManager.shared.playSound(soundFileName: "success", soundFileType: "mp3")
                    pageViewModel.nextPage()
                } else {
                    AudioPlayerManager.shared.playSound(soundFileName: "shot", soundFileType: "mp3")
                }
            }
            .onAppear {
                showInfo = true
            }
            .sheet(isPresented: $showInfo) {
                VStack(spacing: Spacing.spacingXL) {
                    Spacer()
                    Image("stone")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 180)
                    
                    Text("AR Challenge")
                        .style(.title_1)
                    Text(page.title)
                        .style(.headline2, color: .flixoDarkGray)
                        .multilineTextAlignment(.center)
                    
                    CustomButton(text: "Start") {
                        showInfo = false
                    }
                    Spacer()
                    
                }
                .padding(Spacing.spacingXL)
                .background(Image("background")
                    .resizable().scaledToFill()
                )
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    
    let page: CollectionPage
    var callBack: ()->Void
    
    func makeUIView(context: Context) -> ARView {
        
        let arView = ARView(frame: .zero)
        
        addRectangles(to: arView)
        
        arView.addGestureRecognizer(UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:))))
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: ARViewContainer
        
        init(_ parent: ARViewContainer) {
            self.parent = parent
        }
        
        // Gesture handler for object tap
        @objc func handleTap(_ gesture: UITapGestureRecognizer) {
            if let arView = gesture.view as? ARView {
                let location = gesture.location(in: arView)
                
                if let entity = arView.entity(at: location) {
                    if let anchorEntity = entity.anchor, anchorEntity.name == "CubeAnchor" {
                        anchorEntity.removeFromParent()
                        
                        AudioPlayerManager.shared.playSound(soundFileName: "shot", soundFileType: "mp3")
                        self.parent.callBack()
                        
                        print("Removed anchor with name: \(anchorEntity.name)")
                    }
                }
            }
        }
    }
    
    private func addRectangles(to arView: ARView) {
        for _ in 1...page.amount {
            guard let rectangleEntity = generateRectangleEntity(arView: arView) else { return }
            arView.scene.addAnchor(rectangleEntity)
        }
    }
    
    private func generateRectangleEntity(arView: ARView) -> AnchorEntity? {
        guard let texture = try? TextureResource.load(named: page.textureName), let modelEntity = try? Entity.loadModel(named: page.objectName) else {
            print("Failed to load texture image: \(page.textureName)")
            return nil
        }
        
        modelEntity.orientation = Transform(pitch: .pi/Float.random(in: 0...5),
                                            yaw: .pi/Float.random(in: 0...5),
                                            roll: Float.random(in: 0...5)).rotation
        
        var material = SimpleMaterial()
        material.baseColor = .texture(texture)
        modelEntity.model?.materials = [material]
        
        let anchorEntity = AnchorEntity(world: [.random(in: -5...5), .random(in: 0...5), .random(in: -2...0)])
        anchorEntity.addChild(modelEntity)
        
        anchorEntity.generateCollisionShapes(recursive: true)
        anchorEntity.name = "CubeAnchor"
        
        
        //TODO: make them rotate
        //modelEntity.playAnimation(AnimationResource., transitionDuration: <#T##TimeInterval#>, startsPaused: <#T##Bool#>)
        
        //var modelEntityRotation = ModelComponent.AnimatableData(rotation: .init(angle: 0, axis: [0, 1, 0]))
        
        return anchorEntity
        
    }
}

#Preview {
    ARCollectView(page: CollectionPage.fixture)
        .environmentObject(PageViewModel())
}
