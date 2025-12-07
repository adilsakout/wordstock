//
//  HomeWidgetBundle.swift
//  HomeWidget
//
//  Created by adil sakout on 7/12/2025.
//

import WidgetKit
import SwiftUI

/// The main widget bundle that groups all widgets
/// Currently includes the HomeWidget (Word of the Day widget)
@main
struct HomeWidgetBundle: WidgetBundle {
    var body: some Widget {
        HomeWidget()
    }
}
