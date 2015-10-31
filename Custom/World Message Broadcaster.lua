local Broadcast = {
	Register = {
		-- {"String", day, time}
		--    Day is from 1 to 7, where Monday is 1 and Sunday is 7
		--    Time is either seconds if day is 0 or format hour.minutes if day is specified
		{"Announce message here", 0, 1800},
	}
}

local function SeparateTime(t)
	local h = math.floor(t)
	local m = ((t*1000)-(h*1000))/10
	return h, m;
end

local function GetTimeDiff(weekday, h, m, s)
	local d = os.date("*t")

	d.sec = s or 0
	d.min = m
	d.hour = h

	local ddiff = weekday-d.wday+1
	d.day = d.day+ddiff
	local now = os.date("*t")
	if (ddiff < 0) then
		-- Take into consideration that it is tuesday and we want monday
		d.day = d.day+7
	elseif (ddiff == 0 and d.hour*60*60+d.min*60+d.sec < now.hour*60*60+now.min*60+now.sec) then
		-- Take into consideration that it is the same date, but its already past the wanted time
		d.day = d.day+7
	end

	-- get final times
	local e = os.time(d)
	local diff = e-os.time() -- this is the time in seconds until the wanted date is achieved

	return diff;
end

function Broadcast.SendAndReset(msg, d, t)
	SendWorldMessage(msg)
	if(d > 0) then
		local regtime = GetTimeDiff(d, SeparateTime(t))
		CreateLuaEvent(function() Broadcast.SendAndReset(msg, d, t) end, regtime*1000, 1)
	end
end

function Broadcast.OnLoad()
	for i, v in ipairs(Broadcast.Register) do
		local msg, d, t = table.unpack(Broadcast.Register[i])
		if d == 0 then
			CreateLuaEvent(function() Broadcast.SendAndReset(msg, d, t) end, t*1000, 0)
		else
			local regtime = GetTimeDiff(d, SeparateTime(t))
			CreateLuaEvent(function() Broadcast.SendAndReset(msg, d, t) end, regtime*1000, 1)
		end
	end
end

Broadcast.OnLoad()