--!nonstrict
-- =============================================================================
-- Noctalia Custom Clock - Desktop Widget
-- =============================================================================
-- Draws the seven-segment clock face natively with ui.* elements, so there is
-- no PNG to render, poll, or reload: big red hour, white ":MM", a red divider,
-- and day / month / year stacked on the right.

local FONT = "7-Segment" -- fontconfig family of ~/.local/share/fonts/7segment.ttf
local ACCENT = "#FF2400"
local TEXT = "#FFFFFF"

local use24Hour = noctalia.getConfig("use_24_hour")

local lastMinute = nil

local function label(text, size, color)
	return ui.label({ text = text, fontFamily = FONT, fontSize = size, color = color })
end

local function render()
	local now = os.date("*t")
	local hour = now.hour
	if not use24Hour then
		hour = hour % 12
		if hour == 0 then
			hour = 12
		end
	end

	desktopWidget.render(ui.row({ gap = 10, align = "center" }, {
		ui.row({ align = "end" }, {
			label(string.format("%02d", hour), 128, ACCENT),
			label(string.format(":%02d", now.min), 84, TEXT),
		}),
		ui.box({ width = 5, height = 110, fill = ACCENT }),
		ui.column({ gap = 2 }, {
			label(string.format("%02d", now.day), 32, TEXT),
			label(string.upper(os.date("%b")), 32, TEXT),
			label(tostring(now.year), 32, TEXT),
		}),
	}))
end

-- Ticks every second but only redraws when the minute changes.
function update()
	noctalia.setUpdateInterval(1000)
	local minute = os.date("%Y%m%d%H%M")
	if minute ~= lastMinute then
		lastMinute = minute
		render()
	end
end

function onConfigChanged()
	use24Hour = noctalia.getConfig("use_24_hour")
	lastMinute = nil
	update()
end

update()
