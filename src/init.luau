-- Simple library for running sequences, like meltdowns in core games
--!strict

local Sequencer = {}
local macros: {Macro} = {}
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

type Macro = {
    name: string,
    code: ({any}) -> (),
}

function Sequencer.NewMacro(name: string, code: ({any}) -> ())
    local NewMacro: Macro = {
        name = name,
        code = code
    }
    return NewMacro
end

local function RegisterMacro(macro: Macro)
    print(HttpService:JSONEncode(macro))
    table.insert(macros, macro)
end

local function RegisterMacrosFromTable(table: {Macro})
    for _, v in ipairs(table) do
        RegisterMacro(v)
    end
end

local function RegisterMarcrosFromModuleScript(modulescript: Instance)
    RegisterMacrosFromTable(require(modulescript))
end

-- Takes in the sequence and runs said sequence.
function Sequencer.RunSequence(sequence: Instance, MacroScript: Instance & nil)
    if MacroScript ~= nil then
        RegisterMarcrosFromModuleScript(MacroScript)
    elseif game:GetService("ReplicatedStorage"):WaitForChild("Data", 0.1):WaitForChild("Macros", 0.1) ~= nil then
        RegisterMarcrosFromModuleScript(game:GetService("ReplicatedStorage").Data.Macros)
    end
    print(HttpService:JSONEncode(macros))
    local counter = 0
    local lasteventtime = 0
    local lasteventname
    local newseq = require(sequence)
    local length
    if newseq.Length ~= nil then
        length = newseq.Length
    else
        length = 100
    end
    while math.round(counter * 10) / 10 ~= length do
        local roundedcounter = math.round(counter * 10) / 10
        for _, v in ipairs(newseq) do
            task.spawn(function()
                if v.Time == nil and v.AddTime == nil then
                    warn("Sequence Section missing time")
                    return
                end
                if v.Time ~= nil then
                    if v.Time == roundedcounter then
                        for _, macrolist in ipairs(macros) do
                            if v[macrolist.name] ~= nil then
                                macrolist.code(v[macrolist.name])
                                print("Running marco "..macrolist.name)
                            end
                        end
                        if v.EventCode ~= nil then
                            v.EventCode()
                        end 
                        lasteventtime = v.Time
                        if v.EventName ~= nil then
                            lasteventname = v.EventName
                            print(v.EventName)
                        end
                    end
                end
                if v.AddTime ~= nil then
                    if v.PreEvent == nil then
                        error("Sequence that occur after an event must specifiy what event should occur before to properly chain them!")
                    end
                    print(v.PreEvent.." is the preEvent!")
                    if v.AddTime + lasteventtime == roundedcounter and lasteventname == v.PreEvent then
                        for _, macrolist in ipairs(macros) do
                            if v[macrolist.name] ~= nil then
                                macrolist.code(v[macrolist.name])
                                print("Running marco "..macrolist.name)
                            end
                        end
                        if v.EventCode ~= nil then
                            v.EventCode()
                        end
                        if v.EventName ~= nil then
                            lasteventname = v.EventName
                            print(v.EventName)
                        end
                        lasteventtime = v.AddTime + lasteventtime
                    end
                end
                return
            end)
        end
        counter += 0.1
        task.wait(0.1)
        print(counter.." rounded to "..roundedcounter)
    end
end

return Sequencer