-- ModuleScript containing macros for Sequencer
local Seq = require(game:GetService("ReplicatedStorage").Sequencer)
return {
    Seq.NewMacro("PlayLocalAudio", function(args)
        local LocalAudio = require(game:GetService("ReplicatedStorage").LocalAudio)
        LocalAudio:PlayAudio(args[1], args[2])
        print("Running Macro!")
    end),
    Seq.NewMacro("Warning", function(args)
        warn(args[1]) 
    end)
}