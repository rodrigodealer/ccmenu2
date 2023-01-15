/*
 *  Copyright (c) 2007-2023 ThoughtWorks Inc.
 *  Licensed under the Apache License, Version 2.0 (the "License"); you may
 *  not use these files except in compliance with the License.
 */

import Cocoa
import Combine

final class UserSettings: ObservableObject  {

    private static let pipelineShowStatus = "pipelineShowStatus"
    private static let pipelineShowComments = "pipelineShowComments"
    private static let pipelineShowAvatars = "pipelineShowAvatars"

    private static let statusItemUseColor = "statusItemUseColor"

    private var userDefaults: UserDefaults?

    @Published var showStatusInPipelineWindow: Bool {
        didSet {
            userDefaults?.setValue(showStatusInPipelineWindow, forKey: Self.pipelineShowStatus)
        }
    }

    @Published var showCommentsInPipelineWindow: Bool {
        didSet {
            userDefaults?.setValue(showCommentsInPipelineWindow, forKey: Self.pipelineShowComments)
        }
    }

    @Published var showAvatarsInPipelineWindow: Bool {
        didSet {
            userDefaults?.setValue(showAvatarsInPipelineWindow, forKey: Self.pipelineShowAvatars)
        }
    }

    @Published var useColorInStatusItem: Bool {
        didSet {
            userDefaults?.setValue(useColorInStatusItem, forKey: Self.statusItemUseColor)
        }
    }


    init() {
        showStatusInPipelineWindow = false
        showCommentsInPipelineWindow = true
        showAvatarsInPipelineWindow = true
        useColorInStatusItem = false
    }

    convenience init(userDefaults: UserDefaults?) {
        self.init()
        if let userDefaults = userDefaults {
            showStatusInPipelineWindow = userDefaults.bool(forKey: Self.pipelineShowStatus)
            showCommentsInPipelineWindow = userDefaults.bool(forKey: Self.pipelineShowComments)
            showAvatarsInPipelineWindow = userDefaults.bool(forKey: Self.pipelineShowAvatars)
            useColorInStatusItem = userDefaults.bool(forKey: Self.statusItemUseColor)
            self.userDefaults = userDefaults
        }
    }
    
}