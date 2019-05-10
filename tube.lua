Tube = Model{
    initialWater = 20,
    flow = 1,
    finalTime = 20,
    init = function(model)
        model.water = model.initialWater

        model.chart = Chart{target = model, select = "water"}

        model:notify()
        model.timer = Timer{
            Event{action = function()
                model.water = model.water - model.flow
             end},
            Event{action = model.chart}
        }
    end
}

print(type(Tube)) -- "Model"
Tube:run() -- One can run a Model directly...

MyTube = Tube{initialWater = 50} -- ... or create instances using it
print(type(MyTube)) -- "Tube"
print(MyTube:title()) -- "Initial Water = 50"
MyTube:run()

pcall(function() MyTube2 = Tube{initialwater = 100} end)
-- Warning: Argument 'initialwater' is unnecessary. Do you mean 'initialWater'?
-- (when executing TerraME with mode=strict)

_, err = pcall(function() MyTube2 = Tube{flow = false} end)
print(err)