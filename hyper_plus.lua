hs.console.setConsole()
--------------------------
-- DEFINE YOUR APP + SHORTCUT KEY COMBINATIONS
--------------------------
-- Use Hyper+'key' to activate given application
shortcut_key_and_app = {
  { 'f', 'Firefox'    },
  { 'e', 'Code'       }, 
  { 'v', 'Finder'     }, 
--  { 't', 'Terminal'   }, 
  { 't', 'Alacritty'    }, 
  { 'g', 'Brave Browser'    }, 
}


--------------------------
-- GLOBAL VARIABLES
--------------------------
hyper_modifiers_keys = {'shift', 'ctrl', 'alt', 'cmd'}
hyper_pressed = false
idx_to_focus_hcl = 1  -- index of the window to focus from the hyper cycle window list
-- Window filter: will keep track of all visible windows across spaces
-- sources: https://github.com/Hammerspoon/hammerspoon/issues/1460
--          https://github.com/Hammerspoon/hammerspoon/issues/1260
-- When reloading hs config, we have to go through our workspaces 
-- manually for the wf to detect the windows there 
wf = hs.window.filter.new():setCurrentSpace(nil):keepActive()


--------------------------
-- SET UP
--------------------------
registered_apps = {}
for i, app in ipairs(shortcut_key_and_app) do 
  registered_apps[app[2]] = {shortcut_key=app[1], window_focus_list={}, window_hyper_cycle_list={}}
end


--------------------------
-- HELPER FUNCTIONS
--------------------------
function print_t(table)
  for k, v in pairs(table) do
    print(k,v)
  end
end

function deepcopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
      copy = {}
      for orig_key, orig_value in next, orig, nil do
          copy[deepcopy(orig_key)] = deepcopy(orig_value)
      end
      setmetatable(copy, deepcopy(getmetatable(orig)))
  else -- number, string, boolean, etc
      copy = orig
  end
  return copy
end

function window_list_remove(window_list, id)
  for i, winfo in ipairs(window_list) do
    if winfo.id == id then 
      -- Removes element at index i and re-orders/re-indexes the list
      table.remove(window_list, i)
      return i
    end
  end
end

function window_list_add(window_list, window_info)
  window_list_remove(window_list, window_info.id)
  -- Append window to window list:
  window_list[#window_list + 1] = window_info
end

function get_index_after_remove(next_index, index_to_remove, length_list)
  if length_list == 1 then return 1 end
  local current_index = next_index + 1
  if current_index > length_list then current_index = 1 end

  -- print("[old] current_index: " .. current_index)
  -- print("[old] next_index: " .. next_index)

  if current_index > index_to_remove then
    current_index = current_index - 1
  elseif current_index == index_to_remove and current_index == length_list then
    current_index = 1
  end 

  -- print("[new] current_index: " .. current_index)

  next_index = current_index - 1
  if next_index == 0 then next_index = (length_list - 1) end

  -- print("[new] next_index: " .. next_index)

  return next_index
end


--------------------------
-- WF WINDOW WATHCER
--------------------------
function wf_callback(window_object, app_name, event_name)
  if registered_apps[app_name] ~= nil then -- check if app to which window belongs is in registered apps
    if event_name == hs.window.filter.windowFocused then
      -- Just before closing a window with focus the focus will transfer onto the previous window
      -- that had focus before. The closed window won't exists anymore (i.e. is not standard anymore).
      -- In order to keep the window_hyper_cycle_list order we should skip any further code in this block
      for i, w in pairs(registered_apps[app_name].window_focus_list) do 
        if w.window:isStandard() ~= true then return end
      end

      --   print(w.window:title() == "")
      --   print(w.window:isStandard())
      --   print(w.window:frame())
      --   if w.window:title() == "" then
      --     return 
      --   end
      -- end

      window_list_add(registered_apps[app_name].window_focus_list, {id=window_object:id(), window=window_object})
      if hyper_pressed ~= true then
        registered_apps[app_name].window_hyper_cycle_list = deepcopy(registered_apps[app_name].window_focus_list)
        idx_to_focus_hcl = #registered_apps[app_name].window_hyper_cycle_list - 1
      end

      -- LOG TO SEE IF WINDOW FOCUS LIST ORDER IS CORRECT
      -- print("&&&&&&& Callback log: " .. event_name .. " - " .. app_name)
      -- print("Window focus list:")
      -- for key, val in pairs(registered_apps[app_name].window_focus_list) do
      --   print(key, val.id, val.window:title())
      -- end
      -- print("Hyper cycle list")
      -- for key, val in pairs(registered_apps[app_name].window_hyper_cycle_list) do
      --   print(key, val.id, val.window:title())
      -- end
      -- current_index = idx_to_focus_hcl + 1
      -- if current_index > #registered_apps[app_name].window_hyper_cycle_list then
      --   current_index = 1
      -- end
      -- print("current index is: " .. current_index)
      -- print("next index will be: " .. idx_to_focus_hcl)
      -- print("&&&&&&& END Callback log\n")
      -- END LOG


    elseif event_name == hs.window.filter.windowDestroyed
    or event_name == hs.window.filter.windowHidden
    or event_name == hs.window.filter.windowMinimized 
    then
      local length_list = #registered_apps[app_name].window_hyper_cycle_list
      -- print("^^^^^^^^ Event", event_name)  
      -- Remove window from both window lists:
      window_list_remove(registered_apps[app_name].window_focus_list, window_object:id())
      index_to_remove = window_list_remove(registered_apps[app_name].window_hyper_cycle_list, window_object:id())
      -- Calculate index of window to focus on next hyper cycle iteration:
      -- for key, val in pairs(registered_apps[app_name].window_hyper_cycle_list) do
      --   print(key, val.id, val.window:title())
      -- end
      -- print("index to remove: " .. index_to_remove)
      idx_to_focus_hcl = get_index_after_remove(idx_to_focus_hcl, index_to_remove, length_list)
      -- print("^^^^^^^^\n")
    end
  end
  hyper_pressed = false
end

-- Listen for following window events and execute callback when event observered
wf:subscribe(
  {hs.window.filter.windowDestroyed, hs.window.filter.windowHidden, 
  hs.window.filter.windowMinimized, hs.window.filter.windowFocused}, 
  wf_callback
)


--------------------------
-- BINDING HYPER SHORTCUTS
--------------------------
for app_name, app_info in pairs(registered_apps) do
  hs.hotkey.bind(hyper_modifiers_keys, app_info.shortcut_key, function()
    if hs.application.get(app_name):isFrontmost() and #app_info.window_focus_list > 1
    then
      hyper_pressed = true
      -- Focus window
      app_info.window_hyper_cycle_list[idx_to_focus_hcl].window:focus()
      -- Update next index
      idx_to_focus_hcl = idx_to_focus_hcl - 1
      if idx_to_focus_hcl == 0 then idx_to_focus_hcl = #app_info.window_hyper_cycle_list end
    else
      hs.application.get(app_name):activate(true)
      -- hs.application.open(app)  -- does not work with Finder
    end
  end)
end

------------------------------------------------
-- Focus windows north, east ,south, west:
------------------------------------------------
function moveFocusEast()
  focusedWindow = hs.window.focusedWindow()
  focusedWindow.focusWindowEast()
end
function moveFocusWest()
  focusedWindow = hs.window.focusedWindow()
  focusedWindow.focusWindowWest()
end
hs.hotkey.bind(
  hyper_modifiers_keys,'l', 
  moveFocusEast
)
hs.hotkey.bind(
  hyper_modifiers_keys,'h', 
  moveFocusWest
)
