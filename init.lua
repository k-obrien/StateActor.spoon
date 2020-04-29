--- === StateActor ===
---
--- Assign functions to be called when the system enters a new state.
---
--- Download: [https://github.com/k-obrien/state-actor/raw/master/StateActor.spoon.zip](https://github.com/k-obrien/state-actor/raw/master/StateActor.spoon.zip)

local obj={}
obj.__index = obj

-- Metadata
obj.name = "StateActor"
obj.version = "0.1"
obj.author = "Kieran O'Brien"
obj.homepage = "https://github.com/k-obrien/state-actor"
obj.license = "GPLv3 - https://opensource.org/licenses/GPL-3.0"

obj.states = {}

--- StateActor:bindActions(mapping)
--- Method
--- Binds actions for StateActor
---
--- Parameters:
---  * mapping - A table containing tables of functions to call when entering one of the below states:
---   * screensaverDidStart - The screensaver started
---   * screensaverDidStop - The screensaver stopped
---   * screensaverWillStop - The screensaver is about to stop
---   * screensDidLock - The screen was locked
---   * screensDidSleep - The displays have gone to sleep
---   * screensDidUnlock - The screen was unlocked
---   * screensDidWake - The displays have woken from sleep
---   * sessionDidBecomeActive - The session became active, due to fast user switching
---   * sessionDidResignActive - The session is no longer active, due to fast user switching
---   * systemDidWake - The system woke from sleep
---   * systemWillPowerOff - The user requested a logout or shutdown
---   * systemWillSleep - The system is preparing to sleep
function obj:bindActions(mapping)
   local state = hs.caffeinate.watcher
   self.states[state.screensaverDidStart] = mapping.screensaverDidStart
   self.states[state.screensaverDidStop] = mapping.screensaverDidStop
   self.states[state.screensaverWillStop] = mapping.screensaverWillStop
   self.states[state.screensDidLock] = mapping.screensDidLock
   self.states[state.screensDidSleep] = mapping.screensDidSleep
   self.states[state.screensDidUnlock] = mapping.screensDidUnlock
   self.states[state.screensDidWake] = mapping.screensDidWake
   self.states[state.sessionDidBecomeActive] = mapping.sessionDidBecomeActive
   self.states[state.sessionDidResignActive] = mapping.sessionDidResignActive
   self.states[state.systemDidWake] = mapping.systemDidWake
   self.states[state.systemWillPowerOff] = mapping.systemWillPowerOff
   self.states[state.systemWillSleep] = mapping.systemWillSleep
end

--- StateActor:start()
--- Method
--- Start StateActor
---
--- Parameters:
---  * None
function obj:start()
   self.watcher = hs.caffeinate.watcher.new(self.onSystemState):start()
   return self
end

function obj.onSystemState(state)
   local state = obj.states[state]

   if state then
      for _, action in pairs(state) do action() end
   end
end

return obj
