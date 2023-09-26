//
//  VideoContentView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 9/23/23.
//

import SwiftUI

struct VideoContentView: View {
    @StateObject var viewModel = VideoContentViewModel()
    var body: some View {
        viewModel.preview?
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
    }
}

struct VideoContentView_Previews: PreviewProvider {
    static var previews: some View {
        VideoContentView()
    }
}
