//
//  ContentView.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 06.05.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject var keysViewModel = KeysViewModel()

    var body: some View {
        VStack {
            TabView {
                ServersView()
                    .tabItem {
                        Text(String(localized: "view.servers_name"))
                    }
                KeysView()
                    .tabItem {
                        Text(String(localized: "view.keys_name"))
                    }
            }
            .tabViewStyle(.automatic)
            .frame(maxHeight: .infinity)
            .environmentObject(keysViewModel)

            FooterView()
        }
    }
}

struct FooterView: View {
    var body: some View {
        HStack {
            Image("rish")
                .resizable()
                .frame(width: 80, height: 80)
            VStack(alignment: .leading, spacing: 4) {
                Text("RishMacOSTools")
                    .fontWeight(.bold)
                Text(String(localized: "author_name"))
                VStack(alignment: .leading, spacing: 4) {
                    Link(String(localized: "rish_link_text"), destination: URL(string: "https://rish.su/?utm_source=application")!)
                    Link(String(localized: "github_link_text"), destination: URL(string: "https://github.com/pavluk/RishMacOSTools")!)
                }
            }
            Spacer()
        }
        .padding(.vertical, 0)
        .padding(.bottom, 5)
        .padding(.horizontal, 20)
    }
}


