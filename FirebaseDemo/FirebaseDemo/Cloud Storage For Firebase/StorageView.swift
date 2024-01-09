//
//  StorageView.swift
//  FirebaseDemo
//
//  Created by lkh on 1/9/24.
//

import SwiftUI

struct StorageView: View {

    @ObservedObject var storageManager = StorageManager.shared
    @State var image = UIImage()
    @State var showSheet = false

    var body: some View {
        VStack {
            HStack {
                Image(uiImage: self.image)
                    .resizable()
                    .frame(width: 100, height: 100)
                    .aspectRatio(contentMode: .fill)
                    .background(.black.opacity(0.2))
                    .clipShape(Circle())

                Text("Change photo")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .onTapGesture {
                        showSheet = true
                    }
            }
            .padding(.horizontal, 20)
            .sheet(isPresented: $showSheet) {

                ImagePicker(sourceType: .photoLibrary, selectedImage: $image)

                // 카메라에서 사진을 선택하려면
                // Info.plist에 카메라 액세스 권한 요청 필요
                //  Privacy - Camera Usage Description
                //ImagePicker(sourceType: .camera, selectedImage: $image)
            }
            .onChange(of: image) {
                storageManager.upload(image: image)
            }

            Button("Load") {
                storageManager.listAllFiles()
            }

            Spacer()
            List {
                ForEach(storageManager.images, id: \.self) { simage in
                    HStack {
                        Image(uiImage: simage.image)
                            .resizable()
                            .frame(width: 60, height: 60)
                            .aspectRatio(contentMode: .fill)
                            .background(.black.opacity(0.2))
                            .clipShape(Circle())
                        Text(simage.name)
                        Text(simage.fullPath)
                    }
                }
            }
        }
    }
}

#Preview {
    StorageView()
}
