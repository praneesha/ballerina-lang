// Copyright (c) 2019 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/io;

io:ReadableCharacterChannel? rch = ();
io:WritableCharacterChannel? wch = ();
io:WritableCharacterChannel? wca = ();

function initReadableChannel(string filePath, string encoding) returns @tainted io:IOError? {
    var byteChannel = io:openReadableFile(filePath);
    if (byteChannel is io:ReadableByteChannel) {
        rch = <@untainted> new io:ReadableCharacterChannel(byteChannel, encoding);
    } else {
        return byteChannel;
    }
}

function initWritableChannel(string filePath, string encoding) returns io:IOError? {
    io:WritableByteChannel byteChannel = check io:openWritableFile(filePath);
    wch = <@untainted> new io:WritableCharacterChannel(byteChannel, encoding);
}

function initWritableChannelToAppend(string filePath, string encoding) returns io:IOError? {
    io:WritableByteChannel byteChannel = check io:openWritableFile(filePath, append = true);
    wca = <@untainted> new io:WritableCharacterChannel(byteChannel, encoding);
}

function readCharacters(int numberOfCharacters) returns @tainted string|error {
    var result = rch.read(numberOfCharacters);
    if (result is string) {
        return result;
    } else if (result is error) {
        return result;
    } else {
        error e = error("Character channel not initialized properly");
        return e;
    }
}

function readAllCharacters() returns @tainted string|io:IOError? {
    int fixedSize = 500;
    boolean isDone = false;
    string result = "";
    while (!isDone) {
        var readResult = readCharacters(fixedSize);
        if (readResult is string) {
            result = result + readResult;
        } else {
            error e = readResult;
            if (<string>e.detail().message == "io.EOF") {
                isDone = true;
            } else {
                io:IOError readError = error(io:IO_ERROR, message = "Error while reading the content", cause = readResult);
                return readError;
            }
        }
    }
    return result;
}

function writeCharacters(string content, int startOffset) returns int|io:IOError? {
    var result = wch.write(content, startOffset);
    if (result is int) {
        return result;
    } else if (result is error) {
        return result;
    } else {
        // error e = error("Character channel not initialized properly");
        io:IOError e = error(io:IO_ERROR, message = "Character channel not initialized properly");
        return e;
    }
}

function appendCharacters(string content, int startOffset) returns int|io:IOError? {
    var result = wca.write(content, startOffset);
    if (result is int) {
        return result;
    } else if (result is error) {
        return result;
    } else {
        io:IOError e = error(io:IO_ERROR, message = "Character channel not initialized properly");
        return e;
    }
}

function readJson() returns @tainted json|error {
    var result = rch.readJson();
    if (result is json) {
        return result;
    } else {
        return result;
    }
}

function readXml() returns @tainted xml|error {
    var result = rch.readXml();
    if (result is xml) {
        return result;
    } else if (result is error) {
        return result;
    } else {
        io:IOError e = error(io:IO_ERROR, message = "Character channel not initialized properly");
        return e;
    }
}

function writeJson(json content) {
    var result = wch.writeJson(content);
}

function writeJsonWithHigherUnicodeRange() {
    json content = {
        "loop": "É"
    };
    var result = wch.writeJson(content);
    if (result is error) {
        panic result;
    }
}

function writeXml(xml content) {
    var result = wch.writeXml(content);
}

function closeReadableChannel() {
    var err = rch.close();
}

function closeWritableChannel() {
    var err = wch.close();
}

function closeWritableChannelToAppend() {
    var err = wca.close();
}
