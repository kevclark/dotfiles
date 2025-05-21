-- Colourise RGB text literals in buffers
return   {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPost",
    opts = { "*" }
}
