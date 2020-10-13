#!/usr/bin/lua

md5 = require "md5"
json = require "json"
nixio = require "nixio"

-- ============= config start ==================
-- wan ip(Not required)
clientip = ''

-- server ip
nasip = '0.0.0.0'

-- mac
mac = ''

-- secret code
secret = 'Eshore!@#'

-- username
username = ''

-- password
password = ''
-- ============= config end ==================

function getVerifyCodeString()
    local timestamp = os.time() * 1000
    local temp = clientip .. nasip .. mac .. timestamp .. secret
    local md5String = string.upper(md5.sumhexa(temp))
    local body_data = {}
    body_data["iswifi"] = "4060"
    body_data["clientip"] = clientip
    body_data["nasip"] = nasip
    body_data["mac"] = mac
    body_data["timestamp"] = timestamp
    body_data["authenticator"] = md5String
    body_data["username"] = username

    body_data = json.encode(body_data)

    local http = require("socket.http");
    local request_body = body_data
    local response_body = {}

    local res, code, response_headers = http.request {
        url = "http://61.140.12.23:10001/client/challenge",
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
            ["Content-Length"] = #request_body
        },
        source = ltn12.source.string(request_body),
        sink = ltn12.sink.table(response_body)
    }

    if type(response_body) == "table" then
        local task_json = json.decode(table.concat(response_body))
        return task_json.challenge
    else
        print("getVerifyCodeString fail")
    end
end

function doLogin(vertifyCode)
    local timestamp = os.time() * 1000
    local temp = clientip .. nasip .. mac .. timestamp .. vertifyCode .. secret
    local md5String = string.upper(md5.sumhexa(temp))

    local body_data = {}
    body_data["password"] = password
    body_data["verificationcode"] = ""
    body_data["iswifi"] = "4060"
    body_data["clientip"] = clientip
    body_data["nasip"] = nasip
    body_data["mac"] = mac
    body_data["timestamp"] = timestamp
    body_data["authenticator"] = md5String
    body_data["username"] = username

    body_data = json.encode(body_data)

    local http = require("socket.http");
    local request_body = body_data
    local response_body = {}

    local res, code, response_headers = http.request {
        url = "http://61.140.12.23:10001/client/login",
        method = "POST",
        headers = {
            ["Content-Type"] = "application/json",
            ["Content-Length"] = #request_body
        },
        source = ltn12.source.string(request_body),
        sink = ltn12.sink.table(response_body)
    }

    if type(response_body) == "table" then
        print(table.concat(response_body))
    else
        print("getVerifyCodeString fail")
    end
end

function init()
    udp = nixio.socket("inet", "dgram")
    udp:setopt("socket", "reuseaddr", 1)
    udp:setopt("socket", "rcvtimeo", 10)
    udp:connect("1.1.1.8", 3850)
    clientip = udp:getsockname()
end

function main()
    print(os.date("%Y-%m-%d %H:%M"));
    init()
    local vertifyCode = getVerifyCodeString()
    doLogin(vertifyCode)
end

main()
