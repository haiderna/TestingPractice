//
//  DetailView.swift
//  TestingPractice
//
//  Created by NH on 9/14/23.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var vm = DetailViewModel()
    let userId: Int
    
    var body: some View {
        ZStack {
            background
            if vm.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    VStack(alignment: .leading,
                           spacing: 18) {
                        avatar
                        Group {
                            general
                            link
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 18)
                        .background(Theme.detailBackground,
                                        in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                        
                        
                    }
                           .padding()
                }
            }
            
        }
        .navigationTitle("Details")
        .onAppear {
//            do {
//                vm.fetchDetails(for: userId)
//            } catch {
//                print(error)
//            }
        }
        .task {
            await vm.fetchDetails(for: userId)
        }
        .alert(isPresented: $vm.hasError,
               error: vm.error) {
//            Button("Retry") {
//                vm.fetchDetails(for: userId)
//            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    private static var previewUserId: Int {
        let users = try! StaticJSONMapper.decode(file: "UsersStaticData", type: UsersResponse.self)
        return users.data.first!.id
    }
    
    static var previews: some View {
        NavigationView {
            DetailView(userId: previewUserId)
        }

    }
}

private extension DetailView {
    var background: some View {
        Theme.background
            .ignoresSafeArea(edges: .top)
    }
    
    @ViewBuilder
    var avatar: some View {
        if let avatarString = vm.userInfo?.data.avatar,
            let avatarUrl = URL(string: avatarString) {
            AsyncImage(url: avatarUrl) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 225)
                    .clipped()
                
            } placeholder: {
                 ProgressView()
            }
            .clipShape(RoundedRectangle(cornerRadius: 16,
                                        style: .continuous))
        }
    }
    
    @ViewBuilder
    var link: some View {
        if let url = vm.userInfo?.support.url, let supportUrl = URL(string: url), let supportText = vm.userInfo?.support.text {
            Link(destination: supportUrl) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(supportText)
                        .foregroundColor(Theme.text)
                        .font(.system(.body, design: .rounded)
                            .weight(.semibold)
                        )
                        .multilineTextAlignment(.leading)
                    Text(url)
                }
                Spacer()
                Symbols
                    .link
                    .font(.system(.title3, design: .rounded))
            }
        }
        
    }
}

private extension DetailView {
    
    var general: some View {
        VStack(alignment: .leading, spacing: 8) {
            PillView(id: vm.userInfo?.data.id ?? 0)
            Group {
                firstName
                lastName
                email
            }
            .foregroundColor(Theme.text)
        }
        
    }
    
    // allows you to return one or more kind of view
    @ViewBuilder
    var firstName: some View {
        Text("First Name")
            .font(.system(.body, design: .rounded).weight(.semibold)
            )
        Text(vm.userInfo?.data.firstName ?? "---")
            .font(.system(.subheadline, design: .rounded)
            )
        
        Divider()
    }
    
    @ViewBuilder
    var lastName: some View {
        Text("Last Name")
            .font(.system(.body, design: .rounded).weight(.semibold)
            )
        Text(vm.userInfo?.data.lastName ?? "---")
            .font(.system(.subheadline, design: .rounded)
            )
        
        Divider()
    }
    
    @ViewBuilder
    var email: some View {
        Text("Email")
            .font(.system(.body, design: .rounded).weight(.semibold)
            )
        Text(vm.userInfo?.data.email ?? "---")
            .font(.system(.subheadline, design: .rounded)
            )
    }
}
