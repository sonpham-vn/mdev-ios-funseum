//
//  GalleryView.swift
//  Funseum
//
//  Created by SonPT on 2021-12-04.
//

import SwiftUI

struct GalleryView: View {
    @State private var isShowPhotoLibrary = false
    @State private var image = UIImage(named:"placeholder")!
    @State private var originalImage = UIImage()
    @State private var showingAlert = false
    @State private var clickedItem = frameStatus()
    @ObservedObject var frameInfo = FrameInfo ()
    
    var body: some View {
        
       
        VStack {
            
            Image(uiImage: self.image)
                .resizable()
                .scaledToFill()
                .frame(minWidth: 0, maxWidth: .infinity, maxHeight:300)
                .edgesIgnoringSafeArea(.all)
                .clipped()
            
            Button(action: {
                self.isShowPhotoLibrary = true
            }) {
                HStack {
                    Image(systemName: "photo")
                        .font(.system(size: 20))
                    
                    Text("Select Picture")
                        .font(.headline)
                }
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(20)
                .padding(.horizontal)
            }
            
            Text("Current Point: "+String(frameInfo.currentFrameInfo.point!)).padding()
            
            ScrollView (.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(frameInfo.currentFrameInfo.currentStatus!) {
                        frame in
                        //contents
                        Button(action: {
                            if (frame.active!)
                            {self.image = ImageMixer.mix(topImageName:frame.frameFile!,bottomImage: self.originalImage)}
                            else {
                                self.clickedItem = frame
                                self.showingAlert = true
                                
                            }
                        }) {
                            VStack {
                                Image(frame.frameFile!)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    
                                    
                            HStack {
                                Image(systemName: frame.icon!)
                                    .font(.system(size: 20))
                                Text(frame.frameName!)
                                    .font(.headline)
                            }
                            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 50)
                            .background(Color.clear)
                            .foregroundColor(.black)
                            .cornerRadius(20)
                            .padding(.horizontal)
                            }
                            
                        } .alert(isPresented: $showingAlert) { // 4
                            
                            Alert(
                                title: Text("This frame" + clickedItem.frameName! + "is locked"),
                                message: Text("Do you want to exchange 50 points for this frame?"),
                                primaryButton: .cancel(Text("Cancel"), action: {
                                    
                                }),
                                secondaryButton: .destructive(Text("OK"), action: {
                                   
                                    
                                    for i in 0..<frameInfo.currentFrameInfo.currentStatus!.count{
                                        print(frameInfo.currentFrameInfo.currentStatus![i].id)
                                        if (frameInfo.currentFrameInfo.currentStatus![i].id == clickedItem.id){
                                            frameInfo.originalFrameInfo[i].Active = true
                                        }
                                    }
                                    FrameUnlock.unlock(newFrameInfo:frameInfo.originalFrameInfo) {
                                        response in
                                        frameInfo.fetchFrame()
                                    }
                                })
                            )
                        }.padding()
                        
                    }
                    
                }
            }.frame(height: 100)
            
            
            
        }
        .onAppear (perform: {
            self.frameInfo.fetchFrame()
        })
        .background(
            Image("ticket_background")
                .resizable()
                .edgesIgnoringSafeArea(.all))
        
        .sheet(isPresented: $isShowPhotoLibrary) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image, selectedOriginalImage: self.$originalImage)
        }
    }
}

struct GalleryView_Previews: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}
