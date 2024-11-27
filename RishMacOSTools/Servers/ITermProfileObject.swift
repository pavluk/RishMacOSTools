//
//  ITermProfile.swift
//  RishMacOSTools
//
//  Created by Артем Павлюк on 26.11.2024.
//

import Foundation
import Cocoa


struct ITermProfileObject: Codable {
    let ansi7ColorLight: ANSI0_Color
    let brightenBoldTextLight: Bool
    let ansi15ColorLight, ansi2ColorLight, boldColor, ansi1ColorDark: ANSI0_Color
    let useBrightBold: Bool
    let ansi9ColorLight, ansi8ColorDark: ANSI0_Color
    let useBrightBoldDark: Bool
    let backgroundColor, ansi8Color: ANSI0_Color
    let columns, rightOptionKeySends: Int
    let ansi4ColorLight: ANSI0_Color
    let blinkingCursor: Bool
    let selectedTextColorLight, selectedTextColorDark, ansi3ColorDark: ANSI0_Color
    let keyboardMap: [String: String]
    let visualBell: Bool
    let cursorTextColor: ANSI0_Color
    let scrollbackLines: Int
    let selectionColorLight, ansi0Color: ANSI0_Color
    let matchBackgroundColorDark: BadgeColorDark
    let ansi11ColorLight, ansi5ColorDark, cursorTextColorLight: ANSI0_Color
    let silenceBell: Bool
    let rows: Int
    let guid: String
    let ansi14ColorDark: ANSI0_Color
    let useCursorGuideDark: Bool
    let ansi15ColorDark, ansi0ColorDark: ANSI0_Color
    let ambiguousDoubleWidth: Bool
    let optionKeySends: Int
    let ansi3Color: ANSI0_Color
    let windowType: Int
    let smartCursorColorDark, bmGrowl, promptBeforeClosing2: Bool
    let command: String
    let smartCursorColorLight, useBrightBoldLight, useSelectedTextColorLight: Bool
    let selectedTextColor, ansi14ColorLight: ANSI0_Color
    let cursorGuideColorDark: BadgeColorDark
    let sendCodeWhenIdle: Bool
    let ansi6Color: ANSI0_Color
    let jobsToIgnore: [String]
    let badgeColorDark: BadgeColorDark
    let useUnderlineColorLight: Bool
    let cursorColor: ANSI0_Color
    let verticalSpacing, minimumContrastLight: Int
    let disableWindowResizing, useSelectedTextColorDark, closeSessionsOnEnd: Bool
    let selectionColorDark: ANSI0_Color
    let defaultBookmark: String
    let boundHosts: [String]
    let minimumContrastDark: Int
    let customCommand: String
    let foregroundColorLight, ansi9Color, backgroundColorDark, ansi14Color: ANSI0_Color
    let flashingBell, useItalicFont: Bool
    let ansi13ColorDark: ANSI0_Color
    let cursorGuideColorLight: BadgeColorDark
    let ansi12Color, ansi10ColorLight: ANSI0_Color
    let nonASCIIAntiAliased: Bool
    let ansi10Color, foregroundColor: ANSI0_Color
    let linkColorLight: BadgeColorDark
    let description: String
    let ansi7ColorDark: ANSI0_Color
    let syncTitle: Bool
    let ansi1Color: ANSI0_Color
    let name: String
    let useTabColorDark: Bool
    let transparency, horizontalSpacing: Int
    let cursorColorDark, ansi2ColorDark, ansi9ColorDark, ansi13ColorLight: ANSI0_Color
    let idleCode: Int
    let ansi4Color: ANSI0_Color
    let cursorBoostDark: Int
    let boldColorDark: ANSI0_Color
    let screen: Int
    let ansi4ColorDark, cursorTextColorDark, selectionColor: ANSI0_Color
    let useNonASCIIFont: Bool
    let badgeColorLight: BadgeColorDark
    let characterEncoding: Int
    let ansi11ColorDark: ANSI0_Color
    let brightenBoldTextDark: Bool
    let icon: Int
    let useUnderlineColorDark: Bool
    let boldColorLight, ansi12ColorDark: ANSI0_Color
    let faintTextAlphaDark: Double
    let ansi7Color, ansi6ColorDark: ANSI0_Color
    let nonASCIIFont: String
    let useCursorGuideLight: Bool
    let titleComponents: Int
    let customDirectory, workingDirectory: String
    let asciiAntiAliased: Bool
    let shortcut: String
    let mouseReporting: Bool
    let tags:[String]
    let cursorBoostLight: Int
    let useTabColorLight: Bool
    let matchBackgroundColorLight: BadgeColorDark
    let ansi6ColorLight: ANSI0_Color
    let backgroundImageLocation: String
    let ansi1ColorLight: ANSI0_Color
    let useBoldFont: Bool
    let ansi2Color: ANSI0_Color
    let normalFont: String
    let ansi12ColorLight: ANSI0_Color
    let unlimitedScrollback: Bool
    let ansi8ColorLight, ansi10ColorDark, ansi3ColorLight, cursorColorLight: ANSI0_Color
    let ansi15Color: ANSI0_Color
    let blur: Bool
    let faintTextAlphaLight: Double
    let useSeparateColorsForLightAndDarkMode: Bool
    let backgroundColorLight: ANSI0_Color
    let terminalType: String
    let ansi13Color, ansi5ColorLight, foregroundColorDark: ANSI0_Color
    let linkColorDark: BadgeColorDark
    let ansi11Color, ansi5Color: ANSI0_Color
    let initialText: String
    let ansi0ColorLight: ANSI0_Color
    
    init(server: ServerObject) {
        self.name = server.host.capitalized
        self.command = "ssh \(server.host)"
        self.workingDirectory = "/Users/\(NSUserName())"
        self.guid = server.id.uuidString
        
        // Use default values for all other properties
        self.ansi7ColorLight = ANSI0_Color(
            greenComponent: 0.73333334922790527,
            redComponent: 0.73333334922790527,
            blueComponent: 0.73333334922790527
        )
        self.brightenBoldTextLight = false
        self.ansi15ColorLight = ANSI0_Color(
            greenComponent: 1,
            redComponent: 1,
            blueComponent: 1
        )
        self.ansi2ColorLight = ANSI0_Color(
            greenComponent: 0.73333334922790527,
            redComponent: 0,
            blueComponent: 0
        )
        self.boldColor = ANSI0_Color(
            greenComponent: 1,
            redComponent: 1,
            blueComponent: 1
        )
        self.ansi1ColorDark = ANSI0_Color(
            greenComponent: 0,
            redComponent: 0.73333334922790527,
            blueComponent: 0
        )
        self.useBrightBold = true
        self.ansi9ColorLight = ANSI0_Color(
            greenComponent: 0.3333333432674408,
            redComponent: 1,
            blueComponent: 0.3333333432674408
        )
        self.ansi8ColorDark =  ANSI0_Color(
            greenComponent: 0.3333333432674408,
            redComponent: 0.3333333432674408,
            blueComponent: 0.3333333432674408
        )
        self.useBrightBoldDark = true
        self.backgroundColor = ANSI0_Color(
            greenComponent: 0,
            redComponent: 0,
            blueComponent: 0
        )
        self.ansi8Color = ANSI0_Color(
            greenComponent: 0.3333333432674408,
            redComponent: 0.3333333432674408,
            blueComponent: 0.3333333432674408
        )
        self.columns = 80
        self.rightOptionKeySends = 0
        self.ansi4ColorLight = ANSI0_Color(
            greenComponent: 0,
            redComponent: 0,
            blueComponent: 0.73333334922790527
        )
        self.blinkingCursor = false
        self.selectedTextColorLight = ANSI0_Color(
            greenComponent: 0,
            redComponent: 0,
            blueComponent: 0
        )
        self.selectedTextColorDark = ANSI0_Color(
            greenComponent: 0,
            redComponent: 0,
            blueComponent: 0
        )
        self.ansi3ColorDark = ANSI0_Color(
            greenComponent: 0.73333334922790527,
            redComponent: 0.73333334922790527,
            blueComponent: 0
        )
        self.keyboardMap = [:]
        self.visualBell = true
        self.cursorTextColor = ANSI0_Color(
            greenComponent: 1,
            redComponent: 1,
            blueComponent: 1
        )
        self.scrollbackLines = 1000
        self.selectionColorLight = ANSI0_Color(
            greenComponent: 0.8353000283241272,
            redComponent: 0.70980000495910645,
            blueComponent: 1
        )
        self.ansi0Color = ANSI0_Color(
            greenComponent: 0,
            redComponent: 0,
            blueComponent: 0
        )
        self.matchBackgroundColorDark = BadgeColorDark()
        self.ansi11ColorLight = ANSI0_Color(
            greenComponent: 1,
            redComponent: 1,
            blueComponent: 0.3333333432674408
        )
        self.ansi5ColorDark = ANSI0_Color(
            greenComponent: 0,
            redComponent: 0.73333334922790527,
            blueComponent: 0.73333334922790527
        )
        self.cursorTextColorLight = ANSI0_Color(
            greenComponent: 1,
            redComponent: 1,
            blueComponent: 1
        )
        self.silenceBell = false
        self.rows = 24
        self.ansi14ColorDark = ANSI0_Color(
            greenComponent: 1,
            redComponent: 0.3333333432674408,
            blueComponent: 1
        )
        self.useCursorGuideDark = false
        self.ansi15ColorDark = ANSI0_Color(
            greenComponent: 1,
            redComponent: 1,
            blueComponent: 1
        )
        self.ansi0ColorDark = ANSI0_Color(
            greenComponent: 0,
            redComponent: 0,
            blueComponent: 0
        )
        self.ambiguousDoubleWidth = false
        self.optionKeySends = 0
        self.ansi3Color = ANSI0_Color(
            greenComponent: 0.73333334922790527,
            redComponent: 0.73333334922790527,
            blueComponent: 0
        )
        self.windowType = 0
        self.smartCursorColorDark = false
        self.bmGrowl = true
        self.promptBeforeClosing2 = false
        self.smartCursorColorLight = false
        self.useBrightBoldLight = true
        self.useSelectedTextColorLight = true
        self.selectedTextColor = ANSI0_Color(
            greenComponent: 0,
            redComponent: 0,
            blueComponent: 0
        )
        self.ansi14ColorLight = ANSI0_Color(
            greenComponent: 1,
            redComponent: 0.3333333432674408,
            blueComponent: 1
        )
        self.cursorGuideColorDark = BadgeColorDark(
            redComponent: 0.74862593412399292,
            greenComponent:0.92047786712646484,
            blueComponent: 0.99125725030899048,
            alphaComponent: 0.25,
            colorSpace: "P3"
            
        )
        self.sendCodeWhenIdle = false
        self.ansi6Color = ANSI0_Color(
            greenComponent: 0.73333334922790527,
            redComponent: 0,
            blueComponent: 0.73333334922790527
        )
        self.jobsToIgnore = ["rlogin","ssh","slogin","telnet"]
        self.badgeColorDark = BadgeColorDark(
            redComponent: 0.92929404973983765,
            greenComponent:0.25479039549827576,
            blueComponent: 0.13960540294647217,
            alphaComponent: 0.5,
            colorSpace: "P3"
            
        )
        self.useUnderlineColorLight = false
        self.cursorColor = ANSI0_Color(
            greenComponent: 0.73333334922790527,
            redComponent: 0.73333334922790527,
            blueComponent: 0.73333334922790527
        )
        self.verticalSpacing = 1
        self.minimumContrastLight = 0
        self.disableWindowResizing = true
        self.useSelectedTextColorDark = true
        self.closeSessionsOnEnd = true
        self.selectionColorDark = ANSI0_Color(
            greenComponent: 0.8353000283241272,
            redComponent: 0.70980000495910645,
            blueComponent: 1
        )
        self.defaultBookmark = "No"
        self.boundHosts = []
        self.minimumContrastDark = 0
        self.customCommand = "Yes"
        self.foregroundColorLight = ANSI0_Color(
            greenComponent: 0.73333334922790527,
            redComponent: 0.73333334922790527,
            blueComponent: 0.73333334922790527
        )
        self.ansi9Color = ANSI0_Color(
            greenComponent: 0.3333333432674408,
            redComponent: 1,
            blueComponent: 0.3333333432674408
        )
        self.backgroundColorDark = ANSI0_Color(
            greenComponent: 0,
            redComponent: 0,
            blueComponent: 0
        )
        self.ansi14Color = ANSI0_Color(
            greenComponent: 1,
            redComponent: 0.3333333432674408,
            blueComponent: 1
        )
        self.flashingBell = false
        self.useItalicFont = true
        self.ansi13ColorDark = ANSI0_Color(
            greenComponent: 0.3333333432674408,
            redComponent: 1,
            blueComponent: 1
        )
        self.cursorGuideColorLight = BadgeColorDark(
            redComponent: 0.74862593412399292,
            greenComponent:0.92047786712646484,
            blueComponent: 0.99125725030899048,
            alphaComponent: 0.25,
            colorSpace: "P3"
        )
        self.ansi12Color = ANSI0_Color(
            greenComponent: 0.3333333432674408,
            redComponent: 0.3333333432674408,
            blueComponent: 1
        )
        self.ansi10ColorLight = ANSI0_Color(
            greenComponent: 1,
            redComponent: 0.3333333432674408,
            blueComponent: 0.3333333432674408
        )
        self.nonASCIIAntiAliased = true
        self.ansi10Color = ANSI0_Color(
            greenComponent: 1,
            redComponent: 0.3333333432674408,
            blueComponent: 0.3333333432674408
        )
        self.foregroundColor = ANSI0_Color(
            greenComponent: 0.73333334922790527,
            redComponent: 0.73333334922790527,
            blueComponent: 0.73333334922790527
        )
        self.linkColorLight = BadgeColorDark(
            redComponent: 0.14513972401618958,
            greenComponent:0.35333043336868286,
            blueComponent: 0.7093239426612854,
            alphaComponent: 1,
            colorSpace: "P3"
        )
        self.description = self.name
        self.ansi7ColorDark = ANSI0_Color(
            greenComponent: 0.73333334922790527,
            redComponent: 0.73333334922790527,
            blueComponent: 0.73333334922790527
        )
        self.syncTitle = false
        self.ansi1Color = ANSI0_Color(
            greenComponent: 0,
            redComponent: 0.73333334922790527,
            blueComponent: 0
        )
        self.useTabColorDark = false
        self.transparency = 0
        self.horizontalSpacing = 1
        self.cursorColorDark = ANSI0_Color(
            greenComponent: 0.73333334922790527,
            redComponent: 0.73333334922790527,
            blueComponent: 0.73333334922790527
        )
        self.ansi2ColorDark = ANSI0_Color(
            greenComponent: 0.73333334922790527,
            redComponent: 0,
            blueComponent: 0
        )
        self.ansi9ColorDark = ANSI0_Color(
            greenComponent: 0.3333333432674408,
            redComponent: 1,
            blueComponent: 0.3333333432674408
        )
        self.ansi13ColorLight = ANSI0_Color(
            greenComponent: 0.3333333432674408,
            redComponent: 1,
            blueComponent: 1
        )
        self.idleCode = 0
        self.ansi4Color = ANSI0_Color(
            greenComponent: 0,
            redComponent: 0,
            blueComponent: 0.73333334922790527
        )
        self.cursorBoostDark = 0
        self.boldColorDark = ANSI0_Color(
            greenComponent: 1,
            redComponent: 1,
            blueComponent: 1
        )
        self.screen = -1
        self.ansi4ColorDark = ANSI0_Color(
            greenComponent: 0,
            redComponent: 0,
            blueComponent: 0.73333334922790527
        )
        self.cursorTextColorDark = ANSI0_Color(
            greenComponent: 1,
            redComponent: 1,
            blueComponent: 1
        )
        self.selectionColor = ANSI0_Color(
            greenComponent: 0.8353000283241272,
            redComponent: 0.70980000495910645,
            blueComponent: 1
        )
        self.useNonASCIIFont = false
        self.badgeColorLight = BadgeColorDark(
            redComponent: 0.92929404973983765,
            greenComponent:0.25479039549827576,
            blueComponent: 0.13960540294647217,
            alphaComponent: 0.5,
            colorSpace: "P3"
            
        )
        self.characterEncoding = 4
        self.ansi11ColorDark = ANSI0_Color(
            greenComponent: 1,
            redComponent: 1,
            blueComponent: 0.3333333432674408
        )
        self.brightenBoldTextDark = true
        self.icon = 0
        self.useUnderlineColorDark = false
        self.boldColorLight = ANSI0_Color(
            greenComponent: 1,
            redComponent: 1,
            blueComponent: 1
        )
        self.ansi12ColorDark = ANSI0_Color(
            greenComponent: 0.3333333432674408,
            redComponent: 0.3333333432674408,
            blueComponent: 1
        )
        self.faintTextAlphaDark = 0.5
        self.ansi7Color = ANSI0_Color(
            greenComponent: 0.73333334922790527,
            redComponent: 0.73333334922790527,
            blueComponent: 0.73333334922790527
        )
        self.ansi6ColorDark = ANSI0_Color(
            greenComponent: 0.73333334922790527,
            redComponent: 0,
            blueComponent: 0.73333334922790527
        )
        self.nonASCIIFont = "Monaco 12"
        self.useCursorGuideLight = false
        self.titleComponents = 2
        self.customDirectory = "No"
        self.asciiAntiAliased = true
        self.shortcut = ""
        self.mouseReporting = true
        self.tags = []
        self.cursorBoostLight = 0
        self.useTabColorLight = false
        self.matchBackgroundColorLight = BadgeColorDark(
            redComponent: 1,
            greenComponent:1,
            blueComponent: 0,
            alphaComponent: 1,
            colorSpace: "P3"
        )
        self.ansi6ColorLight = ANSI0_Color(
            greenComponent: 0.73333334922790527,
            redComponent: 0,
            blueComponent: 0.73333334922790527
        )
        self.backgroundImageLocation = ""
        self.ansi1ColorLight = ANSI0_Color(
            greenComponent: 0,
            redComponent: 0.73333334922790527,
            blueComponent: 0
        )
        self.useBoldFont = true
        self.ansi2Color = ANSI0_Color(
            greenComponent: 0.73333334922790527,
            redComponent: 0,
            blueComponent: 0
        )
        self.normalFont = "Monaco 12"
        self.ansi12ColorLight = ANSI0_Color(
            greenComponent: 0.3333333432674408,
            redComponent: 0.3333333432674408,
            blueComponent: 1
        )
        self.unlimitedScrollback = false
        self.ansi8ColorLight = ANSI0_Color(
            greenComponent: 0.3333333432674408,
            redComponent: 0.3333333432674408,
            blueComponent: 0.3333333432674408
        )
        self.ansi10ColorDark = ANSI0_Color(
            greenComponent: 1,
            redComponent: 0.3333333432674408,
            blueComponent: 0.3333333432674408
        )
        self.ansi3ColorLight = ANSI0_Color(
            greenComponent: 0.73333334922790527,
            redComponent: 0.73333334922790527,
            blueComponent: 0
        )
        self.cursorColorLight = ANSI0_Color(
            greenComponent: 0.73333334922790527,
            redComponent: 0.73333334922790527,
            blueComponent: 0.73333334922790527
        )
        self.ansi15Color = ANSI0_Color(
            greenComponent: 1,
            redComponent: 1,
            blueComponent: 1
        )
        self.blur = false
        self.faintTextAlphaLight = 0.5
        self.useSeparateColorsForLightAndDarkMode = false
        self.backgroundColorLight = ANSI0_Color(
            greenComponent: 0,
            redComponent: 0,
            blueComponent: 0
        )
        self.terminalType = "xterm-256color"
        self.ansi13Color = ANSI0_Color(
            greenComponent: 0.3333333432674408,
            redComponent: 1,
            blueComponent: 1
        )
        self.ansi5ColorLight = ANSI0_Color(
            greenComponent: 0,
            redComponent: 0.73333334922790527,
            blueComponent: 0.73333334922790527
        )
        self.foregroundColorDark = ANSI0_Color(
            greenComponent: 0.73333334922790527,
            redComponent: 0.73333334922790527,
            blueComponent: 0.73333334922790527
        )
        self.linkColorDark = BadgeColorDark(
            redComponent: 0.14513972401618958,
            greenComponent:0.35333043336868286,
            blueComponent: 0.7093239426612854,
            alphaComponent: 1,
            colorSpace: "P3"
        )
        self.ansi11Color = ANSI0_Color(
            greenComponent: 1,
            redComponent: 1,
            blueComponent: 0.3333333432674408
        )
        self.ansi5Color = ANSI0_Color(
            greenComponent: 0,
            redComponent: 0.73333334922790527,
            blueComponent: 0.73333334922790527
        )
        self.initialText = ""
        self.ansi0ColorLight = ANSI0_Color(
            greenComponent: 0,
            redComponent: 0,
            blueComponent: 0
        )
    }
    
    enum CodingKeys: String, CodingKey {
        case ansi7ColorLight = "Ansi 7 Color (Light)"
        case brightenBoldTextLight = "Brighten Bold Text (Light)"
        case ansi15ColorLight = "Ansi 15 Color (Light)"
        case ansi2ColorLight = "Ansi 2 Color (Light)"
        case boldColor = "Bold Color"
        case ansi1ColorDark = "Ansi 1 Color (Dark)"
        case useBrightBold = "Use Bright Bold"
        case ansi9ColorLight = "Ansi 9 Color (Light)"
        case ansi8ColorDark = "Ansi 8 Color (Dark)"
        case useBrightBoldDark = "Use Bright Bold (Dark)"
        case backgroundColor = "Background Color"
        case ansi8Color = "Ansi 8 Color"
        case columns = "Columns"
        case rightOptionKeySends = "Right Option Key Sends"
        case ansi4ColorLight = "Ansi 4 Color (Light)"
        case blinkingCursor = "Blinking Cursor"
        case selectedTextColorLight = "Selected Text Color (Light)"
        case selectedTextColorDark = "Selected Text Color (Dark)"
        case ansi3ColorDark = "Ansi 3 Color (Dark)"
        case keyboardMap = "Keyboard Map"
        case visualBell = "Visual Bell"
        case cursorTextColor = "Cursor Text Color"
        case scrollbackLines = "Scrollback Lines"
        case selectionColorLight = "Selection Color (Light)"
        case ansi0Color = "Ansi 0 Color"
        case matchBackgroundColorDark = "Match Background Color (Dark)"
        case ansi11ColorLight = "Ansi 11 Color (Light)"
        case ansi5ColorDark = "Ansi 5 Color (Dark)"
        case cursorTextColorLight = "Cursor Text Color (Light)"
        case silenceBell = "Silence Bell"
        case rows = "Rows"
        case guid = "Guid"
        case ansi14ColorDark = "Ansi 14 Color (Dark)"
        case useCursorGuideDark = "Use Cursor Guide (Dark)"
        case ansi15ColorDark = "Ansi 15 Color (Dark)"
        case ansi0ColorDark = "Ansi 0 Color (Dark)"
        case ambiguousDoubleWidth = "Ambiguous Double Width"
        case optionKeySends = "Option Key Sends"
        case ansi3Color = "Ansi 3 Color"
        case windowType = "Window Type"
        case smartCursorColorDark = "Smart Cursor Color (Dark)"
        case bmGrowl = "BM Growl"
        case promptBeforeClosing2 = "Prompt Before Closing 2"
        case command = "Command"
        case smartCursorColorLight = "Smart Cursor Color (Light)"
        case useBrightBoldLight = "Use Bright Bold (Light)"
        case useSelectedTextColorLight = "Use Selected Text Color (Light)"
        case selectedTextColor = "Selected Text Color"
        case ansi14ColorLight = "Ansi 14 Color (Light)"
        case cursorGuideColorDark = "Cursor Guide Color (Dark)"
        case sendCodeWhenIdle = "Send Code When Idle"
        case ansi6Color = "Ansi 6 Color"
        case jobsToIgnore = "Jobs to Ignore"
        case badgeColorDark = "Badge Color (Dark)"
        case useUnderlineColorLight = "Use Underline Color (Light)"
        case cursorColor = "Cursor Color"
        case verticalSpacing = "Vertical Spacing"
        case minimumContrastLight = "Minimum Contrast (Light)"
        case disableWindowResizing = "Disable Window Resizing"
        case useSelectedTextColorDark = "Use Selected Text Color (Dark)"
        case closeSessionsOnEnd = "Close Sessions On End"
        case selectionColorDark = "Selection Color (Dark)"
        case defaultBookmark = "Default Bookmark"
        case boundHosts = "Bound Hosts"
        case minimumContrastDark = "Minimum Contrast (Dark)"
        case customCommand = "Custom Command"
        case foregroundColorLight = "Foreground Color (Light)"
        case ansi9Color = "Ansi 9 Color"
        case backgroundColorDark = "Background Color (Dark)"
        case ansi14Color = "Ansi 14 Color"
        case flashingBell = "Flashing Bell"
        case useItalicFont = "Use Italic Font"
        case ansi13ColorDark = "Ansi 13 Color (Dark)"
        case cursorGuideColorLight = "Cursor Guide Color (Light)"
        case ansi12Color = "Ansi 12 Color"
        case ansi10ColorLight = "Ansi 10 Color (Light)"
        case nonASCIIAntiAliased = "Non-ASCII Anti Aliased"
        case ansi10Color = "Ansi 10 Color"
        case foregroundColor = "Foreground Color"
        case linkColorLight = "Link Color (Light)"
        case description = "Description"
        case ansi7ColorDark = "Ansi 7 Color (Dark)"
        case syncTitle = "Sync Title"
        case ansi1Color = "Ansi 1 Color"
        case name = "Name"
        case useTabColorDark = "Use Tab Color (Dark)"
        case transparency = "Transparency"
        case horizontalSpacing = "Horizontal Spacing"
        case cursorColorDark = "Cursor Color (Dark)"
        case ansi2ColorDark = "Ansi 2 Color (Dark)"
        case ansi9ColorDark = "Ansi 9 Color (Dark)"
        case ansi13ColorLight = "Ansi 13 Color (Light)"
        case idleCode = "Idle Code"
        case ansi4Color = "Ansi 4 Color"
        case cursorBoostDark = "Cursor Boost (Dark)"
        case boldColorDark = "Bold Color (Dark)"
        case screen = "Screen"
        case ansi4ColorDark = "Ansi 4 Color (Dark)"
        case cursorTextColorDark = "Cursor Text Color (Dark)"
        case selectionColor = "Selection Color"
        case useNonASCIIFont = "Use Non-ASCII Font"
        case badgeColorLight = "Badge Color (Light)"
        case characterEncoding = "Character Encoding"
        case ansi11ColorDark = "Ansi 11 Color (Dark)"
        case brightenBoldTextDark = "Brighten Bold Text (Dark)"
        case icon = "Icon"
        case useUnderlineColorDark = "Use Underline Color (Dark)"
        case boldColorLight = "Bold Color (Light)"
        case ansi12ColorDark = "Ansi 12 Color (Dark)"
        case faintTextAlphaDark = "Faint Text Alpha (Dark)"
        case ansi7Color = "Ansi 7 Color"
        case ansi6ColorDark = "Ansi 6 Color (Dark)"
        case nonASCIIFont = "Non Ascii Font"
        case useCursorGuideLight = "Use Cursor Guide (Light)"
        case titleComponents = "Title Components"
        case customDirectory = "Custom Directory"
        case workingDirectory = "Working Directory"
        case asciiAntiAliased = "ASCII Anti Aliased"
        case shortcut = "Shortcut"
        case mouseReporting = "Mouse Reporting"
        case tags = "Tags"
        case cursorBoostLight = "Cursor Boost (Light)"
        case useTabColorLight = "Use Tab Color (Light)"
        case matchBackgroundColorLight = "Match Background Color (Light)"
        case ansi6ColorLight = "Ansi 6 Color (Light)"
        case backgroundImageLocation = "Background Image Location"
        case ansi1ColorLight = "Ansi 1 Color (Light)"
        case useBoldFont = "Use Bold Font"
        case ansi2Color = "Ansi 2 Color"
        case normalFont = "Normal Font"
        case ansi12ColorLight = "Ansi 12 Color (Light)"
        case unlimitedScrollback = "Unlimited Scrollback"
        case ansi8ColorLight = "Ansi 8 Color (Light)"
        case ansi10ColorDark = "Ansi 10 Color (Dark)"
        case ansi3ColorLight = "Ansi 3 Color (Light)"
        case cursorColorLight = "Cursor Color (Light)"
        case ansi15Color = "Ansi 15 Color"
        case blur = "Blur"
        case faintTextAlphaLight = "Faint Text Alpha (Light)"
        case useSeparateColorsForLightAndDarkMode = "Use Separate Colors for Light and Dark Mode"
        case backgroundColorLight = "Background Color (Light)"
        case terminalType = "Terminal Type"
        case ansi13Color = "Ansi 13 Color"
        case ansi5ColorLight = "Ansi 5 Color (Light)"
        case foregroundColorDark = "Foreground Color (Dark)"
        case linkColorDark = "Link Color (Dark)"
        case ansi11Color = "Ansi 11 Color"
        case ansi5Color = "Ansi 5 Color"
        case initialText = "Initial Text"
        case ansi0ColorLight = "Ansi 0 Color (Light)"
    }
}

// MARK: - ANSI0_Color
struct ANSI0_Color: Codable {
    let greenComponent, redComponent, blueComponent: Double
    
    enum CodingKeys: String, CodingKey {
        case greenComponent = "Green Component"
        case redComponent = "Red Component"
        case blueComponent = "Blue Component"
    }
}

// MARK: - BadgeColorDark
struct BadgeColorDark: Codable {
    let redComponent: Double
    let colorSpace: String
    let blueComponent, alphaComponent, greenComponent: Double
    
    init(
        redComponent: Double = 1,
        greenComponent: Double = 1,
        blueComponent: Double = 0,
        alphaComponent: Double = 1,
        colorSpace: String = "P3"
    ) {
        self.redComponent = redComponent
        self.greenComponent = greenComponent
        self.blueComponent = blueComponent
        self.alphaComponent = alphaComponent
        self.colorSpace = colorSpace
    }
    enum CodingKeys: String, CodingKey {
        case redComponent = "Red Component"
        case colorSpace = "Color Space"
        case blueComponent = "Blue Component"
        case alphaComponent = "Alpha Component"
        case greenComponent = "Green Component"
    }
}
