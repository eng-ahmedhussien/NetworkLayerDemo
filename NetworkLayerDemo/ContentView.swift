//
//  ContentView.swift
//  NetworkLayerDemo
//
//  Created by ahmed hussien on 30/05/2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var vm =  HomeViewModel()
    @StateObject var vm1 =  GHomeViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                List(vm1.users ?? [], id: \.id) { user in
                    HStack {
                        AsyncImage(url: URL(string: user.avatarURL ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                        } placeholder: {
                            Circle()
                                .foregroundColor(.teal)
                        }
                        .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading) {
                            Text(user.login?.capitalized ?? "")
                                .font(.headline)
                            Text(user.url ?? "")
                                .font(.subheadline)
                        }
                    }
                }
                .listStyle(.plain)
                .listRowInsets(EdgeInsets())
                .background(Color.white)
                .navigationTitle("Users")
                
            }
        }
        .onAppear{
//            vm.fetchDataByCompletion()
//            vm1.fetchDataByCompletion()
        }
        .task {
          // await vm.fetchDataByAsync()
            await vm1.fetchDataByAsync()
        }
    }
    
}
#Preview {
    ContentView()
}
