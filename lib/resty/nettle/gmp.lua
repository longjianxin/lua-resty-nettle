local ffi      = require "ffi"
local ffi_load = ffi.load
local ipairs   = ipairs
local pcall    = pcall

local function L()
    local ok, lib = pcall(ffi_load, "gmp")
    if ok and lib then return lib end

    for _, t in ipairs{ "so", "dylib", "dll" } do
        ok, lib = pcall(ffi_load, "gmp." .. t)
        if ok and lib then return lib end
        local lib_path = (_GMP_LIB_PATH or "") .. "libgmp." .. t
        ok, lib = pcall(ffi_load, lib_path)
        if ok and lib then return lib end
        for i = 10, 3, -1 do
            ok, lib = pcall(ffi_load, "gmp." .. i)
            if ok and lib then return lib end
            ok, lib = pcall(ffi_load, "gmp." .. t .. "." .. i)
            if ok and lib then return lib end
            ok, lib = pcall(ffi_load, "libgmp." .. t .. "." .. i)
            if ok and lib then return lib end
            ok, lib = pcall(ffi_load, lib_path .. "." .. i)
            if ok and lib then return lib end
        end
    end
    return nil, "unable to load gmp"
end

return L()
