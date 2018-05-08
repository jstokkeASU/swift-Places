//
//  StringEditor.swift
//  Assign8
//
//  ViewController.swift
//  Assign8
//
// Copyright 2018 James Stokke
// Licensed under the Apache License, Version 2.0 (the "License");
// You may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
// @author James Stokke mailto:James.Stokke@asu.edu
// @version April 24, 2018
//
// This is just a function to remove specified characters from a string
//ß


import Foundation

// removes substring or characters in given regex
// taken from https://stackoverflow.com/questions/28503449/swift-replace-substring-regex
extension String {
    mutating func removingRegexMatches(pattern: String, replaceWith: String = "") {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            let range = NSMakeRange(0, self.count)
            self = regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
        } catch {
            return
        }
    }
}
