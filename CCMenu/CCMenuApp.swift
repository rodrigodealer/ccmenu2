/*
 *  Copyright (c) 2007-2020 ThoughtWorks Inc.
 *  Licensed under the Apache License, Version 2.0 (the "License"); you may
 *  not use these files except in compliance with the License.
 */

import SwiftUI

@main
struct CCMenuApp: App {

    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject public var viewModel = ViewModel()

    init() {
        appDelegate.viewModel = viewModel
    }

    var body: some Scene {
        WindowGroup(Text("Pipelines")) {
            PipelineListView(viewModel: viewModel)
        }
        .commands {
            AppCommands()
        }

        Settings {
            AppearanceSettings()
        }

    }

}