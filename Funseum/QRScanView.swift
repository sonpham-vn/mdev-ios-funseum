//
//  QRScanView.swift
//  Funseum
//
//  Created by SonPT on 2021-12-04.
//

import SwiftUI

struct QRScanView: View {
    @ObservedObject var viewModel = ScannerViewModel()
    @State var songPlayable = false
    
    @StateObject private var soundManager = SoundManager()
        
        var body: some View {
            ZStack {
                Text("Scanner goes here...")
                
                
                VStack {
                    VStack {
                        Text("Keep scanning for QR-codes")
                            .font(.subheadline)
                        Text(self.viewModel.lastQrCode)
                            .bold()
                            .lineLimit(5)
                            .padding()
                        
                        QrCodeScannerView()
                        .found(r: self.viewModel.onFoundQrCode)
                        .torchLight(isOn: self.viewModel.torchIsOn)
                        .interval(delay: self.viewModel.scanInterval)
                    }
                    .padding(.vertical, 20)
                    
                    Spacer()
                    if (self.viewModel.songLink != "") {
                    Image(systemName: songPlayable ? "pause.circle.fill": "play.circle.fill")
                                .font(.system(size: 50))
                                .padding(.trailing)
                                .onTapGesture {
                                    soundManager.playSound(sound: self.viewModel.songLink)
                                    songPlayable.toggle()
                                    
                                    if songPlayable{
                                        soundManager.audioPlayer?.play()
                                    } else {
                                        soundManager.audioPlayer?.pause()
                                    }
                                    
                            }
                    }
                    HStack {
                        Button(action: {
                            self.viewModel.torchIsOn.toggle()
                        }, label: {
                            Image(systemName: self.viewModel.torchIsOn ? "bolt.fill" : "bolt.slash.fill")
                                .imageScale(.large)
                                .foregroundColor(self.viewModel.torchIsOn ? Color.yellow : Color.blue)
                                .padding()
                        })
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    
                }.padding()
            }
        }
    
}

struct QRScanView_Previews: PreviewProvider {
    static var previews: some View {
        QRScanView()
    }
}
