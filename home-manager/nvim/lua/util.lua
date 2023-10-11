local M = {}

M.copy_table = function(obj)
    if type(obj) ~= "table" then
        return obj
    end
    local res = {}
    for k, v in pairs(obj) do
        res[M.copy_table(k)] = M.copy_table(v)
    end
    return res
end

M.with_description = function(opts, desc)
    if opts == nil then
        return { desc = desc }
    else
        local o = M.copy_table(opts)
        o["desc"] = desc
        return o
    end
end

return M
