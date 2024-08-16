local MiiuiLayout = {}

local currentX = 0
local currentY = 0
local rowHeight = 0

function MiiuiLayout.beginLayout(x, y)
    currentX = x
    currentY = y
    rowHeight = 0
end

function MiiuiLayout.next(w, h, margin)
    margin = margin or 5
    if currentX + w > love.graphics.getWidth() then
        currentX = 0
        currentY = currentY + rowHeight + margin
        rowHeight = 0
    end
    
    local x, y = currentX, currentY
    currentX = currentX + w + margin
    rowHeight = math.max(rowHeight, h)
    
    return x, y
end

return MiiuiLayout