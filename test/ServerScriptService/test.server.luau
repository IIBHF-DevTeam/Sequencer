local Sequencer = require(game:GetService("ReplicatedStorage").Sequencer)

local test = require(game:GetService("ReplicatedStorage").LocalAudio)
--test:PlayAudio("Test.Keycard", workspace)

Sequencer.RunSequence(game:GetService("ReplicatedStorage").testsequence)