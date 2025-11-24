# Sequencer
A library for running events in a sequence
# Setup
## Project
This project uses [Rojo](https://github.com/rojo-rbx/rojo), some Rojo project files are included, 3 to be exact
* ``default.project.json`` is the project file that you should probably be using, this one packs it to be compatible with Wally
* ``test.project.json`` is used to demo the tester(and to test it)

- This project has no dependencies, LocalAudio is used to test it, so if you want to test it, run ``wally install``

In order to build the desired copy, run
```bash
rojo build {project file you want to use} --output Sequencer.rbxm
```
## Example
This is an example of a sequence

### A sequence
```
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
```
First, this thing calls LocalAudio to play an audio called ``Test.Keycard``, it also prints the phrase "Starting New Sequence", and then also prints a warning in the console saying "Hiiii", Then it waits about 3 seconds, it then makes a new part, and you get the gist.

### Macros
```
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
```

This makes 2 macros, one for printing warnings to the console, and one for playing audio with LocalAudio, each macro has a name, you can make a macro execute by adding an entry to the event that you want to play a macro, then adding the parameters as the value

Macros will have their arguments put into a list when added to the event and when running the macro, keep this in mind!

If you don't pass in a macro module script into ``RunSequence`` it will use ``ReplicatedStorage.Data.Macros`` as a fallback

## API
``Sequencer.NewMacro(name: string, code: ({any}) -> ()): Macro``
Creates a new macro, ``name`` will be the name of the macro defined in the event, ``code`` will be what code is ran, the function must take in an array!

``Sequencer.RunSequence(sequence: Instance, MacroScript: Instance & nil)`` Runs a sequence, ``sequence`` is the sequence that you want to run, and ``MacroScript`` is the MacroScript you want to run, defaulting to ``ReplicatedStorage.Data.Macros``

# License
This project is avaliable under the MIT License. See [LICENSE](https://github.com/IIBHF-DevTeam/Sequencer/blob/f573cca82b7f2ad9e25f95971f256fdf5d828997/LICENSE) for details