SCRIPTNAME_CLIENT = "client.lua"

function LoadX()
    s = {ssid="", pwd="", host="", domain="", path="", err="",boot="",update=0}
    if (file.open("s.txt","r")) then
        local sF = file.read()
        --print("setting: "..sF)
        file.close()
        for k, v in string.gmatch(sF, "([%w.]+)=([%S ]+)") do
            s[k] = v
            --print(k .. ": " .. v)
        end
    end
end

function SaveXY(sErr)
    if (sErr) then
        s.err = sErr
    end
    file.remove("s.txt")
    file.open("s.txt","w+")
    for k, v in pairs(s) do
        file.writeline(k .. "=" .. v)
    end
    file.close()
    collectgarbage()
end



function update()
conn=net.createConnection(net.TCP, 0)
    conn:on("connection",function(conn, payload)
    conn:send("GET /"..s.path.."/node.php?id="..id.."&update"..
                " HTTP/1.1\r\n".. 
                "Host: "..s.domain.."\r\n"..
                "Accept: */*\r\n"..
                "User-Agent: Mozilla/4.0 (compatible; esp8266 Lua;)"..
                "\r\n\r\n") 
            end)

    conn:on("receive", function(conn, payload)
        if string.find(payload, "UPDATE")~=nil then
            s.boot=nil
            SaveXY()
            node.restart()
        end
        
        payload = nil
        conn:close()
        conn = nil

    end)
    conn:connect(80,s.host)
end

id = node.chipid()
print ("nodeID is: "..id)

print(collectgarbage("count").." kB used")
LoadX()

-- run the correct application
-- if the settings are correct, either load the default client
-- or run the set boot file that was uploaded
-- if settings are insufficient, run the server to connect to wifi
if (s.host~="") then
    if (tonumber(s.update)>0) then
        tmr.alarm (0, tonumber(s.update)*60000, 1, function()
                print("checking for update")
                update()
            end)
    end
    local fileFound
    local filenameBoot
    -- check if the boot setting is present and try to load the file
    if (s.boot~="") then
      fileFound=file.exists(s.boot)
      if (fileFound) then
        filenameBoot = s.boot
      else
        -- file is set but was wrong, load default
        filenameBoot = SCRIPTNAME_CLIENT
      end
    else
        filenameBoot = SCRIPTNAME_CLIENT
    end
    dofile(filenameBoot)
else
    dofile("server.lua")
end 
