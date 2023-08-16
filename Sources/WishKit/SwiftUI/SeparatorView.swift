//
//  SwiftUIView.swift
//  
//
//  Created by Martin Lasek on 8/12/23.
//  Copyright © 2023 Martin Lasek. All rights reserved.
//

import SwiftUI

struct SeparatorView: View {
    var body: some View {
        HStack(alignment: .center) {
            VStack { Divider() }
            Text("COMMENTS").font(.caption2)
            VStack { Divider() }
        }
    }
}

struct SeparatorView_Previews: PreviewProvider {
    static var previews: some View {
        SeparatorView()
    }
}
