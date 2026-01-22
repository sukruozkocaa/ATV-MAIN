//
//  MiniPlayerContent.swift
//  Animations
//
//  Created by Şükrü on 8.12.2025.
//

import Foundation
import SwiftUI
import AVKit
import Combine

// MARK: - Mini Player Content
struct MiniPlayerContent: View {
    var onClose: (() -> Void)?
    @Binding var isClosed: Bool
    @StateObject private var playerViewModel = VideoPlayerViewModel()
    
    var body: some View {
        HStack(spacing: 6.0) {
            // Video Player - Sol taraf
            ZStack(alignment: .topLeading) {
                
                ZStack(alignment: .bottomLeading) {
                    ZStack(alignment: .topTrailing) {
                        CustomVideoPlayer(player: playerViewModel.player)
                            .frame(width: 165.0, height: 92)
                            .cornerRadius(6.0)
                            .clipped()
                            .onAppear {
                                playerViewModel.setupPlayer(videoName: "video_1", fileExtension: "mov")
                            }
                            .onDisappear {
                                playerViewModel.cleanup()
                            }
                        
                        // Tam ekran butonu - Player'ın sağ üst köşesi
                        Button(action: {
                            // Tam ekran aksiyonu
                        }) {
                            Image(systemName: "arrow.down.left.and.arrow.up.right")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white)
                                .padding(6)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                        }
                        .padding(6)
                    }
                    
                    // Progress Bar - Player'ın altında
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            // Arka plan (gri)
                            Rectangle()
                                .fill(Color.white.opacity(0.3))
                                .frame(height: 4.0)
                                .cornerRadius(6.0)
                            
                            // İlerleme (kırmızı)
                            Rectangle()
                                .fill(Color.red)
                                .frame(width: geometry.size.width * 0.3, height: 4.0) // 0.3 = %30 ilerleme
                                .cornerRadius(6.0)
                        }
                    }
                    .frame(height: 4.0)
                    .padding(.bottom, 4.0)
                    .padding(.leading, 3.0)
                    .padding(.trailing, 10.0)
                    .cornerRadius(6.0)
                }
                                
                // CANLI badge
                HStack(spacing: 4) {
                    Image(systemName: "waveform")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.white)
                    Text("CANLI")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.red)
                .clipShape(RoundedCorner(radius: 6.0, corners: [.topLeft, .bottomRight]))
            }
            .padding(.leading, 14.0)
            
            // Metin İçeriği - Orta
            VStack(alignment: .leading, spacing: 4.0) {
                Text("Gözleri KaraDeniz 3. Bölüm")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("Güneş kalbinin sesini mi dinleyecek?")
                    .font(.system(size: 11))
                    .foregroundColor(.gray)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: 100.0, alignment: .leading)
            .padding(.horizontal, 8)
            
            // Kapat Butonu - Sağ taraf
            Spacer()
            
            VStack {
                Spacer().frame(height: 14.0)
                
                Button(action: {
                    onClose?()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 10.0, weight: .medium))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                }
                .frame(width: 28.0, height: 28.0)
                .background(.black)
                .cornerRadius(14.0)
                
                Spacer()
            }
            
            Spacer().frame(width: 8.0)
        }
        .frame(height: 120.0)
        .background(
            RoundedRectangle(cornerRadius: 8.0)
                .fill(Color(hex: "1C1C1E"))
                .shadow(color: .black.opacity(0.3), radius: 20, y: 10)
        )
        .padding(.horizontal, 16)
    }
}

// MARK: - Custom Video Player
struct CustomVideoPlayer: UIViewRepresentable {
    let player: AVPlayer?
    
    func makeUIView(context: Context) -> UIView {
        let view = VideoPlayerUIView()
        view.player = player
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let videoView = uiView as? VideoPlayerUIView {
            videoView.player = player
        }
    }
}

class VideoPlayerUIView: UIView {
    private var playerLayer: AVPlayerLayer?
    
    var player: AVPlayer? {
        didSet {
            setupPlayerLayer()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupPlayerLayer() {
        playerLayer?.removeFromSuperlayer()
        
        guard let player = player else { return }
        
        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill // Video'yu tam olarak doldur
        layer.frame = bounds
        self.layer.addSublayer(layer)
        playerLayer = layer
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = bounds
    }
}

// MARK: - Video Player ViewModel
class VideoPlayerViewModel: ObservableObject {
    @Published var player: AVPlayer?
    private var playerLooper: AVPlayerLooper?
    private var timeObserver: Any?
    
    func setupPlayer(videoName: String, fileExtension: String) {
        guard let videoURL = Bundle.main.url(forResource: videoName, withExtension: fileExtension) else {
            print("Video bulunamadı: \(videoName).\(fileExtension)")
            return
        }
        
        let playerItem = AVPlayerItem(url: videoURL)
        let queuePlayer = AVQueuePlayer(playerItem: playerItem)
        
        // Video'yu loop yap
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        
        player = queuePlayer
        player?.isMuted = true
        player?.play()
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: playerItem,
            queue: .main
        ) { [weak self] _ in
            self?.player?.seek(to: .zero)
            self?.player?.play()
        }
    }
    
    func cleanup() {
        player?.pause()
        player = nil
        playerLooper = nil
        timeObserver = nil
        NotificationCenter.default.removeObserver(self)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
