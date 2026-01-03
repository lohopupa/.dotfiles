local function flatten(tbl)
  local result = {}
  for _, item in ipairs(tbl) do
    if item[1] then -- it's a list of plugins
      for _, plugin in ipairs(item) do
        table.insert(result, plugin)
      end
    else -- single plugin
      table.insert(result, item)
    end
  end
  return result
end

return flatten({
  require("plugins.telescope"),
  require("plugins.lsp"),
  require("plugins.editor"),
  require("plugins.ui"),
  require("plugins.git"),
})
