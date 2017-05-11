local tonumber = tonumber
local ipairs = ipairs
local pairs = pairs

local function ua_basic(ua)
    local cur, last = 0, nil
    while cur do
        cur = ua:find("/", cur+1)
        if cur then
            last = cur
        end
    end

    if last then
        return tonumber(ua:match("^(%d+)", last+1))
    end
end

-- find the version of the product identified by the keyword
local function ua_keyword(kw)
    return function(ua)
        local s = ua:find(kw) + kw:len()
        if s then
            return tonumber(ua:match("^(%d+)", s))
        end
    end
end

local ua_os_matchers = {
     ["iPod"]           = "iPod"
    ,["iPad"]           = "iPad"
    ,["iPhone"]         = "iPhone"
    ,["Android"]        = "Android"
    ,["BlackBerry"]     = "BlackBerry"
    ,["Linux"]          = "Linux"
    ,["Macintosh"]      = "Macintosh"
    ,["FirefoxOS"]      = "Mozilla/5.0 (Mobile; rv:"
    -- http://en.wikipedia.org/wiki/Microsoft_Windows#Timeline_of_releases
    ,["Windows 8.1"]    = "Windows NT 6.3"
    ,["Windows 8"]      = "Windows NT 6.2"
    ,["Windows 7"]      = "Windows NT 6.1"
    ,["Windows Vista"]  = "Windows NT 6.0"
    ,["Windows XP"]     = "Windows NT 5.1"
    ,["Windows 2000"]   = "Windows NT 5.0"
}

local ua_browser_matchers = {
     {"Chrome"        , ua_keyword("Chrome/")}
    ,{"Opera Mini"    , ua_basic}
    ,{"Opera Mobile"  , ua_basic}
    ,{"Opera"         , ua_basic}
    ,{"MSIE"          , ua_keyword("MSIE ")}
    ,{"Safari"        , ua_basic}
    ,{"Firefox"       , ua_basic}
}

function normalize_user_agent(ua)
    if not ua then return end

    local browser, version, os
    for k, v in pairs(ua_os_matchers) do
        if ua:find(v, 1, true) then
            os = k
            break
        end
    end

    for i, v in ipairs(ua_browser_matchers) do
        if ua:find(v[1], 1, true) then
            browser = v[1]
            version = v[2](ua)
            break
        end
    end

    return browser, version, os
end
