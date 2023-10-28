//
//  SettingView.swift
//  ShoppingLog
//
//  Created by Ryuga on 2023/10/28.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        List {
            Section("App Settings") {
                Text("テーマカラー設定")
                Text("言語設定")
            }
            Section("Support") {
                Text("運営からのお知らせ")
                Text("ヘルプ")
                Text("お問い合わせ")
            }
            Section("About ShoppingLog App") {
                Text("利用規約")
                Text("プライバシーポリシー")
                Text("特定商取引法に基づく表示")
            }


            Section {
                //
            } footer: {
                VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, content: {
                    Image(systemName: "cart")
                        .font(.headline)
                    Text("©ShoppingLog")
                        .font(.caption)
                    Text("Ver. 1.00")
                        .font(.caption2)
                })
                .frame(maxWidth: .infinity)
            }

        }
    }
}

#Preview {
    SettingView()
}
