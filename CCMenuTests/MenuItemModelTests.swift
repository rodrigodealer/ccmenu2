/*
 *  Copyright (c) Erik Doernenburg and contributors
 *  Licensed under the Apache License, Version 2.0 (the "License"); you may
 *  not use these files except in compliance with the License.
 */

import XCTest
@testable import CCMenu

final class MenuItemModelTests: XCTestCase {

    private func makePipeline(name: String, activity: Pipeline.Activity = .other, lastBuildResult: BuildResult? = nil) -> Pipeline {
        var p = Pipeline(name: name, feed: Pipeline.Feed(type: .cctray, url: "", name: ""))
        p.status.activity = activity
        if activity == .building {
            p.status.currentBuild = Build(result: .unknown)
        }
        if let lastBuildResult = lastBuildResult {
            p.status.lastBuild = Build(result: lastBuildResult)
        }
        return p
    }

    func testUsesPipelineNameInMenuAsDefault() throws {
        let pipeline = makePipeline(name: "connectfour")
        let pvm = MenuItemViewModel(pipeline: pipeline, settings: UserSettings())
        XCTAssertEqual("connectfour", pvm.title)
    }

    func testAppendsBuildLabelToPipelineNameInMenuBasedOnSetting() throws {
        var pipeline = makePipeline(name: "connectfour")
        pipeline.status.lastBuild = Build(result: .success, label: "build.1")
        let settings = UserSettings()
        settings.showBuildLabelsInMenu = true
        let pvm = MenuItemViewModel(pipeline: pipeline, settings: settings)

        XCTAssertEqual("connectfour \u{2014} build.1", pvm.title)
    }

    func testAppendsBuildTimeToPipelineNameInMenuBasedOnSetting() throws {
        var pipeline = makePipeline(name: "connectfour")
        pipeline.status.lastBuild = Build(result: .success, label: "build.1", timestamp: Date.now)
        let settings = UserSettings()
        settings.showBuildTimesInMenu = true
        let pvm = MenuItemViewModel(pipeline: pipeline, settings: settings)

        XCTAssertEqual("connectfour \u{2014} now", pvm.title) // TODO: can this become flaky?
    }

    func testDoesNotAppendsBuildTimeToPipelineNameInMenuWhenNoBuildAvailable() throws {
        var pipeline = makePipeline(name: "connectfour")
        pipeline.status.lastBuild = Build(result: .success, label: "build.1")
        let settings = UserSettings()
        settings.showBuildTimesInMenu = true
        let pvm = MenuItemViewModel(pipeline: pipeline, settings: settings)

        XCTAssertEqual("connectfour", pvm.title)
    }

    func testAppendsBuildLabelAndTimeToPipelineNameInMenuBasedOnSetting() throws {
        var pipeline = makePipeline(name: "connectfour")
        pipeline.status.lastBuild = Build(result: .success, label: "build.1", timestamp: Date.now)
        let settings = UserSettings()
        settings.showBuildLabelsInMenu = true
        settings.showBuildTimesInMenu = true
        let pvm = MenuItemViewModel(pipeline: pipeline, settings: settings)

        XCTAssertEqual("connectfour \u{2014} now, build.1", pvm.title)
    }

}
