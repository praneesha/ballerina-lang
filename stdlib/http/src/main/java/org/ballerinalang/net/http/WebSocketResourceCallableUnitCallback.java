/*
*  Copyright (c) 2017, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
*
*  WSO2 Inc. licenses this file to you under the Apache License,
*  Version 2.0 (the "License"); you may not use this file except
*  in compliance with the License.
*  You may obtain a copy of the License at
*
*    http://www.apache.org/licenses/LICENSE-2.0
*
*  Unless required by applicable law or agreed to in writing,
*  software distributed under the License is distributed on an
*  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
*  KIND, either express or implied.  See the License for the
*  specific language governing permissions and limitations
*  under the License.
*/
package org.ballerinalang.net.http;

import org.ballerinalang.jvm.values.ErrorValue;
import org.ballerinalang.jvm.values.connector.CallableUnitCallback;
import org.ballerinalang.services.ErrorHandlerUtils;
import org.wso2.transport.http.netty.contract.websocket.WebSocketConnection;

/**
 * Empty callback impl for web socket.
 */
public class WebSocketResourceCallableUnitCallback implements CallableUnitCallback {

    private final WebSocketConnection webSocketConnection;

    WebSocketResourceCallableUnitCallback(WebSocketConnection webSocketConnection) {
        this.webSocketConnection = webSocketConnection;
    }

    @Override
    public void notifySuccess() {
        webSocketConnection.readNextFrame();
    }

    @Override
    public void notifyFailure(ErrorValue error) {
        ErrorHandlerUtils.printError("error: " + error.getPrintableStackTrace());
        WebSocketUtil.closeDuringUnexpectedCondition(webSocketConnection);
    }

}
