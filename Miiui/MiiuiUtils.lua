local MiiuiUtils = {}

function MiiuiUtils.pointInRect(x, y, rx, ry, rw, rh)
    return x >= rx and x <= rx + rw and y >= ry and y <= ry + rh
end

function MiiuiUtils.lerp(a, b, t)
    return a + (b - a) * t
end

return MiiuiUtils   