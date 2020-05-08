//
//  TermSheet.swift
//  ric-calculator
//
//  Created by Bryan Potts on 5/8/20.
//  Copyright © 2020 Bryan Potts. All rights reserved.
//

import SwiftUI

// MARK: - TERMS OF USE
struct TermsSheet: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            Text("Terms of Use")
                .font(.title)
                .padding(.bottom,20)
            Text("By continuing to use the RIC Flooring Calculator (this application) you understand that prices and quotes shown are guaranteed to be within 10% accuracy and must be verified by an RIC salesperson. Prices shown do not include shipping or other flooring accessories that your particular project may require, and are not included in this quote. You agree to use this application for personal use only and that it is not licensed to third parties without written permission.")
                .padding(.bottom,20)
                .font(.footnote)
            Button(action:{
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Close")
            }
            Spacer()
        }
        .padding(20)
    }
}
