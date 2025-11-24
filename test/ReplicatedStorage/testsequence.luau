return {
    Length = 20,
    {
        Time = 1,
        PlayLocalAudio = {"Test.Keycard"},
        Warning = {"Hiiii"},
        EventCode = function() print(" Starting new Sequence") end
    },
    {
        EventName = "MakePart",
        Time = 4,
        EventCode = function()
            local newInst = Instance.new("Part")
            newInst.Name = "SequencerThingy!"
            newInst.Position = Vector3.new(10, 5, 10)
            newInst.Parent = workspace
        end
    },
    {
        PreEvent = "MakePart",
        AddTime = 10,
        Warning = {"This is a warning from sequencer occuring at 14 seconds!"},
        EventCode = function() warn("Running Thingy") end
    }
}